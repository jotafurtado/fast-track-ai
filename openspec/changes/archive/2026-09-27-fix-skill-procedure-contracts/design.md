# Design

## Context

Every behavior in this change lives in the Markdown skill procedures. The scripts shipped in `harden-method-scripts` already provide what these procedures need:
- gate `--mode structure` for drafting
- a completion gate (the default) that requires closed tasks
- an index that fails without overwriting on dangling citations

Current text that shapes the edits:
- `skills/fast-track-ai-intent/SKILL.md` allocates the track number in step 2, before step 6 decides whether the request is non-implementation. Step 6 then prints `Track concluida. Nenhuma implementacao necessaria.`
- `skills/fast-track-ai-implement/SKILL.md`:
  - Step 2 says "Touch ONLY files listed", while steps 7 and 8 write `tasks.md`, `INDEX.md`, and intent status.
  - Step 3 names `TodoWrite`.
  - Step 6 runs the gate, and only step 7 updates checkboxes.
  - `[blocking]` findings "must fix", with no rerun rule.
- `skills/fast-track-ai-spec/SKILL.md` step 1 copies every open question into phases and tasks. Step 6 approves on `.` without saying what the approval covers.
- The research and assess skills always end with "Stop after ..." and have no caller mode.
- `run-evals.sh` asserts literal skill text:
  - `flow`: the next-step lines and the retired exit line.
  - `decisions`: `materially changes approved \`spec.md\` or \`tasks.md\``, `renewed explicit approval`, `If it does not materially change approved scope or design, record it and continue.`
  - `refs`: `Open questions`, `Assumed state`, and ref-contract phrases in the intent skill.

  Rewrites must keep those phrases or update the asserting selector in the same task.
- This repository's `AGENTS.md` managed block differs from the snippet by one blank line. Running the owner init on the repository refreshes the block to the snippet byte for byte.

## Goals / Non-Goals

**Goals:**
- Each skill step reads as one unambiguous transition, and no step contradicts another.
- The remaining string assertions in the evals stay green, except the retired exit line, which becomes an absence check.

**Non-Goals:**
- Proving agent behavior with executed sessions. This change verifies text and runs the gate on scratch tracks.
- Making the gate check `assets/acceptance.md`. That would make shipped tracks `008`-`010` fail, which contradicts the `track-gate` spec.
- Rewriting skill prose beyond the transitions listed in the proposal.

## Decisions

### 1. Intent routes pure investigation away instead of printing an exit line

**Choice:** Reorder the intent skill:
1. Listen.
2. Classify the request as a change, research-only, or assessment-only, asking the capped clarifying questions if it is ambiguous.
3. For a research-only or assessment-only request, invoke that skill as a direct call and end the intent skill with nothing written by intent.
4. For a change, allocate the number, run the triggers, draft, index, and summarize.

The line `Track concluida. Nenhuma implementacao necessaria.` is deleted everywhere (skill, AGENTS house rule, continuous-flow spec, `flow` eval).

**Why:** Once no track exists there is nothing to conclude. The routed skill already reports its artifact. Keeping a fixed line would require a fifth protocol string with no state behind it.

**Alternatives:**
- Replace the line with `Nenhuma implementacao iniciada.` (rejected: it is a line with no transition or state behind it).
- Keep creating a track for research requests (rejected: that is the defect).

### 2. Acceptance evidence lives in `assets/acceptance.md`, with its format defined in the implement skill

**Choice:**
- **Contents:** One Markdown table with the columns `Criterion | Check | Observed | Result`. It has one row for the Outcome and one per phase `Accept:`, and `Result` is `met` or `pending`.
- **Where the format lives:** The implement skill defines the format inline. There is no new template file.
- **When it is written:** After tasks pass, rewritten after each review fix.
- **How the summary cites it:** The summary bullet is `Acceptance: N/M met (assets/acceptance.md)`.

**Why:**
- **A file survives sessions.** The ship `.` may come in a later session or after a handoff, so the evidence must outlive the chat.
- **`assets/` is already allowed.** The gate and the track root rules already permit it.
- **No new template.** An inline format keeps implement as a skill that owns only its SKILL.md. The AGENTS map and the `resources` eval stay as they are.

**Alternatives:**
- A table in chat only (rejected: lost on resume).
- A new template asset (rejected: resource ownership churn for a four-column table).
- Adding the evidence to `tasks.md` (rejected: it mixes planning content with runtime evidence, and edits beyond checkboxes would count as material).

### 3. Implement order: validate and mark, accept, gate, review loop, summary

**Choice:**

```
per task: Validate pass --> mark [x] in tasks.md
all tasks --> acceptance checks --> assets/acceptance.md
          --> completion gate --> review
review [blocking]? --> fix --> rerun affected Validate + acceptance --> gate --> review
no [blocking] + all met --> summary + ". para ship ..."
```

The four summary bullets become: completed tasks, acceptance, review outcome, gate result. Test results fold into the acceptance and Validate evidence.

**Why:** The gate requires durable `[x]`. Acceptance before review lets review judge the evidence too. Each loop ends in a state whose evidence is current.

**Alternatives:** Review before acceptance (rejected: review could not challenge missing evidence).

### 4. Two file categories in implement step 2

**Choice:** Product files are the union of spec Files and task Files. Method-administration writes are the fixed list in the `implement-workflow` spec. The ADR sentences that the `decisions` eval asserts stay verbatim inside the same step.

**Why:** It removes the contradiction without broadening edit rights.

### 5. Material change returns both planning files to `draft`

**Choice:** The spec skill states that `.` approves the presented content. Both the spec skill (revision after approval) and the implement skill (conflicting decision or evidence) set both files back to `draft` and re-present the spec summary. The existing phrase `renewed explicit approval` is kept.

**Why:** A `draft` status is visible to the completion gate and to later sessions. A conversational "please re-approve" is not.

### 6. Blocking questions are asked, deferrable ones become grouped tasks

**Choice:** The blocking categories are scope, security, data persistence, external integration, architecture, and acceptance. The spec skill asks at most three per pass through the host's interactive pattern and does not present the summary while one is open. A deferrable question becomes a task in its own group, with `Validate` naming the expected answer or artifact, and its dependents declare `(depends: ...)`.

**Why:** It reuses the intent's capped-question pattern and the dependency groups that the structure gate now validates.

### 7. Auxiliary mode is signalled by the caller, not detected

**Choice:** The research and assess skills gain one step: "When invoked by another skill as an auxiliary step, write the artifact, regenerate the index, return conclusion, limitations, and path to the caller, and present nothing to the user." The intent skill's trigger text says it invokes them "as an auxiliary step". A direct invocation keeps the current ending, minus any continuation line.

**Why:** Harnesses do not expose call stacks. An explicit phrase in the caller is the only portable signal.

### 8. Refresh this repository's managed block with the owner init

**Choice:** After editing `AGENTS-snippet.md`, run `skills/fast-track-ai-init/scripts/fast-track-ai-init.sh .`. The house-rule line outside the block (the exception list) is edited by hand.

**Why:** It dogfoods the refresh shipped in `harden-method-scripts` and guarantees the block equals the snippet.

## Risks / Trade-offs

- [Removing a protocol string breaks consumers or agents that expect it] → It appeared only on a path that no longer creates a track. The `flow` eval now fails if the line comes back.
- [Agents skip `assets/acceptance.md` because nothing enforces it] → The ship line is gated in text only. Agent-driven evals (delivery-quality 2) remain the follow-up to prove behavior.
- [Rewording steps breaks literal eval assertions] → The tasks name each asserted phrase to keep. The full eval suite runs as the final task.
- [Auxiliary mode is misapplied on a direct call] → The auxiliary step is conditional on invocation by another skill. Direct command wrappers do not contain that phrase.

## Migration Plan

1. Edit the skills, commands, snippet, and house rule. Refresh the repository block with init.
2. Update the `flow` selector and `evals.md`, then run `run-evals.sh all`.
3. Smoke-test in `/tmp`:
   - Draft a scratch track from the templates, then run the structure gate with open tasks.
   - Mark the tasks, add `assets/acceptance.md`, and run the completion gate to confirm the file does not break the track root rules.
4. Rollback: revert the commit. There is no data migration, because existing tracks never contained the retired line or `assets/acceptance.md`.
