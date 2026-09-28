# Tasks

## 1. Intent routing and index

- [x] 1.1 Rewrite `skills/fast-track-ai-intent/SKILL.md`:
  - Classify the request as a change, research-only, or assessment-only before allocating a number, using the capped clarifying questions when it is ambiguous. Route research-only and assessment-only requests to the research or assess skill as a direct call, with no track and no intent.
  - Invoke the research and assessment triggers "as an auxiliary step" for change requests only, and restate the Assessment trigger as "the intended change depends on the current condition of a system you can inspect".
  - Regenerate `INDEX.md` with the owner script after writing or revising the intent and after setting `dropped` or `superseded`.
  - Delete `Track concluida. Nenhuma implementacao necessaria.`.
  - Keep the phrases asserted by the `refs` and `decisions` selectors.

  Verify: `rg -F 'Track concluida' skills commands` returns nothing, `rg -F 'as an auxiliary step' skills/fast-track-ai-intent/SKILL.md` matches, and `run-evals.sh refs` and `run-evals.sh decisions` exit 0.
- [x] 1.2 Update `commands/fast-track-ai-intent.md` so it says that research-only and assessment-only requests are routed without a track, and that output goes to `intent.md` only for change requests. Verify: the command no longer says output "always" goes to `intent.md`, and `rg -F 'Track concluida' commands` returns nothing.

## 2. Spec approval scope and questions

- [x] 2.1 Rewrite `skills/fast-track-ai-spec/SKILL.md`:
  - Step 1 classifies each open question as blocking or deferrable. Blocking questions (scope, security, data persistence, external integration, architecture, acceptance) are asked, at most three per pass, and the summary is withheld while any stays open. Deferrable questions become bounded tasks in a group that their dependents list in `(depends: ...)`.
  - Step 6 says that `.` approves exactly the presented `spec.md` and `tasks.md`, and that a later material change returns both to `draft` and requires a new summary.
  - Regenerate `INDEX.md` after writing the files and any ADR.
  - Keep `Do not create an ADR for local, easily reversible, or obvious choices.` and the `--mode structure` gate call.

  Verify: `run-evals.sh decisions` exits 0, and the skill names the six blocking categories and the return-to-`draft` rule.
- [x] 2.2 Update `commands/fast-track-ai-spec.md` to match: blocking questions are asked before the summary, and `.` approves the presented version. Verify: the command mentions blocking questions and does not contradict the skill's approval wording.

## 3. Implement workflow

- [x] 3.1 Rewrite `skills/fast-track-ai-implement/SKILL.md`:
  - **Step 2:** product files versus the named method-administration transitions. Keep the three asserted ADR phrases verbatim, and add that a material conflict returns `spec.md` and `tasks.md` to `draft`.
  - **Step 3:** the harness-provided task tracker, with no `TodoWrite`.
  - **Step 4:** sequential execution when there are no subagents.
  - **Step 5:** mark `- [x]` in `tasks.md` right after Validate passes, and run the project's actual checks instead of assuming a typechecker or suite exists.
  - **New acceptance step:** write `assets/acceptance.md` using the `Criterion | Check | Observed | Result` table, with one Outcome row and one row per phase `Accept:`.
  - **Step 6:** run the completion gate, then review. On any `[blocking]` finding, fix and rerun the affected Validate, acceptance checks, gate, and review until none remain. List `[important]` findings as fixed or open.
  - **Step 7:** bullets for completed tasks, acceptance `N/M met (assets/acceptance.md)`, review outcome, and gate result. Show the ship next-step line only when every row is `met` and no `[blocking]` finding remains. Drop the late "Update task checkboxes" instruction.

  Verify: `rg -F 'TodoWrite' skills commands` returns nothing, `rg -F 'assets/acceptance.md' skills/fast-track-ai-implement/SKILL.md` matches, and `run-evals.sh decisions` and `run-evals.sh flow` exit 0.
- [x] 3.2 Update `commands/fast-track-ai-implement.md` to name acceptance evidence before ship, the review loop, and the new bullet set. Verify: the command mentions `assets/acceptance.md` and still ends its description with the `. para ship` summary.

## 4. Auxiliary return contract

- [x] 4.1 Add a conditional step to `skills/fast-track-ai-research/SKILL.md` and `skills/fast-track-ai-assess/SKILL.md`. When invoked by another skill as an auxiliary step, write the artifact, regenerate the index, return conclusion, limitations, and artifact path to the caller, and present nothing to the user. A direct call reports the result, path, and index outcome without a `.` line. Verify: both skills contain `auxiliary step`, and `run-evals.sh workflows` exits 0.
- [x] 4.2 Check `commands/fast-track-ai-research.md` and `commands/fast-track-ai-assess.md`, and add only the direct-call ending (result, path, no continuation line) if the command describes an ending. Verify: neither command contains `auxiliary step` or a `.` next-step line.

## 5. AGENTS copy

- [x] 5.1 In `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, make two edits. Continuous flow: "intent, spec, and implement end with a four-bullet summary plus a next-step line". Intent autonomy: purely investigative or evaluative requests are routed to research or assess without creating a track. Then run `skills/fast-track-ai-init/scripts/fast-track-ai-init.sh .` to refresh this repository's block. Verify: the block in `AGENTS.md` extracted between the markers is byte-identical to the snippet (`cmp`), and `rg -F 'each skill ends' AGENTS.md skills` returns nothing.
- [x] 5.2 Edit the `AGENTS.md` house rule so the Portuguese exception lists only the three next-step lines. Verify: `rg -F 'Track concluida' AGENTS.md` returns nothing, and the exception still names `. para continuar com a spec`, `. para implementar`, and `. para ship (marca a track como concluida)`.

## 6. Evals and smoke run

- [x] 6.1 In `run-evals.sh` `run_flow`, replace the assertion for `Track concluida. Nenhuma implementacao necessaria.` with `assert_not_contains` on the intent skill. Update the `flow` row in `evals.md`. Verify: `run-evals.sh flow` exits 0, and `run_flow` contains no `assert_contains` for the retired line.
- [x] 6.2 Run `bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all`. Verify: it exits 0 and prints `PASS: all evals`.
- [x] 6.3 In `/tmp`, run the smoke test:
  1. Init a scratch target and write a track from the intent, spec, and tasks templates with filled fields.
  2. Run the gate with `--mode structure` while tasks are open.
  3. Mark the tasks `[x]`, set both planning files to approved, write `assets/acceptance.md` with all rows `met`, and run the default gate.
  4. Run the index.

  Verify: structure mode prints `PASS: <track> structure valid`, completion prints `PASS: <track> cycle intact`, and the index exits 0 with the track listed.
