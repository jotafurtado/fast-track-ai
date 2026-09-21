# Design

## Context

See proposal.md for motivation. Live skills already implement continuous-flow. Drift is in copy, installer surface, eval coverage, and one unshipped track.

Constraints that shape the approach:

- ADR `003-live-evals-vs-frozen-spec` freezes `001` `spec/` prose. Do not rewrite it.
- ADR `006-no-live-plan-md` already forbids live `plan.md`. This change does not discuss leftover `001` `plan.md`.
- Accepted Decision text in `fast-track-ai/decisions/` is immutable.
- Shipped track bodies stay historical. Only `010` intent status plus INDEX change.
- `install.sh` already discovers `skills/fast-track-ai-*` and mirrors them into a Claude skills dir. Command files currently live only in repo `commands/`.

## Goals / Non-Goals

**Goals:**

- One live description of the cycle across AGENTS, skills, commands, templates, and evals.
- Command wrappers resolve after install the same way skills do.
- `010` is a terminal INDEX row.
- Continuous-flow strings are regression-checked.

**Non-Goals:**

- Numbered-track dogfooding of this OpenSpec change.
- Rewriting shipped tracks, frozen `001` `spec/`, ADRs, or historical research/assessments.
- Changing gate behavior around leftover `plan.md`.
- Translating Portuguese next-step lines into English.
- Removing `active` from the index enum.

## Decisions

### 1. Commands install next to Claude skills

**Choice:** `install.sh` gains `--commands-dir`, default `$HOME/.claude/commands`. When `--claude-dir` is set and `--commands-dir` is omitted, commands default to a sibling `commands` directory of that skills dir (`dirname(claude-dir)/commands`). Link each `commands/fast-track-ai-*.md` with `ln -sfn`, same pattern as skills.

**Why:** Claude slash commands live under `~/.claude/commands`. A sibling of a custom `--claude-dir` keeps custom-dir evals honest without inventing a Cursor-specific commands path. Agents skills dir stays skills-only.

**Alternatives:** Document that commands are never installed (rejected: method-artifacts already says the seventh skill exposes its command). Link commands into the agents skills dir (rejected: they are not skills).

### 2. Spec Kit silence is live-copy only

**Choice:** Strip Spec Kit / speckit / `.specify` from live skills, commands, the spec template, AGENTS, evals.md table prose, and the skill-package contract. Keep the init eval's filesystem assertions that `specs/` and `.specify/` are absent. Init skill text describes what it creates, not what it refuses.

**Why:** The user asked not to mention Spec Kit. Behavior (do not create those trees) stays. Historical tracks, ADRs, and research citations of GitHub Spec Kit as a license-checked source stay.

**Alternatives:** Rewrite every shipped track spec that says "Not a Spec Kit artifact" (rejected: historical). Drop the filesystem assertion (rejected: still required behavior).

### 3. Portuguese strings stay; English rule gets an exception

**Choice:** Keep the exact next-step and exit lines already in the skills. Change AGENTS house rule to: English for commands, skills, and error messages, except the continuous-flow next-step and non-implementation-exit lines.

**Why:** Those strings are the published protocol. Translating them would change the continuous-flow spec.

**Alternatives:** Translate to English (rejected: user asked to match the live description). Drop the English house rule entirely (rejected: code and other prose stay English).

### 4. `active` remains an index-accepted leftover

**Choice:** Index enum stays `draft|active|shipped|dropped|superseded`. Managed block and skills stop talking about leaving `active`. Eval fixtures that only need a valid intent use `draft`. One index fixture may still use `active` to prove the enum.

**Why:** Removing the enum is a breaking validation change with no current live writer. Keeping the word in AGENTS as if it were the cycle is the actual bug.

**Alternatives:** Drop `active` from the index (rejected: extra migration, no current track needs it removed). Start writing `active` again (rejected: continuous-flow says draft until shipped).

### 5. Flow eval is string assertions, not a host session

**Choice:** New selector `flow` greps owner skills and the tasks template for the protocol strings. It does not simulate a `.` continuation in a harness.

**Why:** The protocol is instruction-based. File-level assertions catch copy drift cheaply. A live host session is out of scope.

**Alternatives:** End-to-end harness test (rejected: no harness runner in this package). Fold into `contract` (rejected: a named selector matches other evals).

### 6. Ship 010 by status only

**Choice:** Set intent `status: shipped`, run the owner index script. Do not edit `010` spec.md or tasks.md.

**Why:** User set P0 aside except this mark. The historical approval-ask spec is leftover narrative, not live copy.

### 7. Managed-block "no exceptions" becomes a lock, not a universal entry

**Choice:** Replace "Mandatory flow, no exceptions: a new request becomes `intent.md` first" with a sentence that implementation still requires approved spec and tasks, while research, assess, and handoff may stop after their artifact. Intent remains the start of a change request that will be implemented.

**Why:** Matches assess/research/handoff skills and this assessment workflow.

## Risks / Trade-offs

- [Custom harnesses that do not use `~/.claude/commands`] → `--commands-dir` exists; Cursor-only machines still get the repo `commands/` files even if unused.
- [Evals.md table must not name `.specify` while the script still checks it] → table prose says "canonical tree only"; script keeps the paths.
- [Agents may still read shipped track specs that mention Spec Kit] → INDEX-first discovery plus live skills are the prescribed path; historical files stay historical.
- [Keeping `active` in the index enum] → a future agent could still write it; mitigated by skill and AGENTS text forbidding it.

## Migration Plan

1. Edit live package files and installer.
2. Ship `010` intent and regenerate INDEX.
3. Run `run-evals.sh all` including the new `flow` selector.
4. Rollback is revert of the same files; no data migration.

## Open Questions

None.
