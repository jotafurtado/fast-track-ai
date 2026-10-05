# Tasks

## 1. Live-format eval helpers

- [x] 1.1 In `evals/run-evals.sh`:
  - `write_tasks` emits `## Group A` above its task line.
  - `write_handoff` emits `## Next actions` instead of the P0, P1, and First next action headings.
  - Every handoff fixture uses `YYYY-MM-DD-HHmmssZ-<slug>.md` names with matching `Z` `captured` values.

  Leave the legacy-acceptance assertions untouched for now. Verify: `bash evals/run-evals.sh all` exits 0 with the old scripts.

## 2. Scripts

- [x] 2.1 In `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`:
  - Remove the `plan.md` branch.
  - Remove `decisions.md` and `spec` from the root allow-list and from the file and directory type checks.
  - In the task parser, fail with `tasks.md has no group header` when there is no header, and always fail a task line before the first header.

  Verify:
  - `bash -n` passes.
  - Scratch tracks in `/tmp` with root `plan.md`, root `decisions.md`, a `spec/` directory, or ungrouped tasks each exit 1 with a message naming the entry or the missing header.
  - A track with one `## Group A` and one task passes structure mode.
- [x] 2.2 In `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`:
  - Remove `active` and the legacy comment from the intent status `case`.
  - Accept only `YYYY-MM-DD-HHmmssZ-<slug>.md` handoff names, and require a `Z` `captured`.
  - Drop the offset arithmetic from the epoch function.
  - Remove the P0, P1, and First next action heading branch.

  Verify:
  - `bash -n` passes.
  - Scratch fixtures with `status: active`, an `HHmm-+0200` handoff name, a `+02:00` `captured`, or P0 and P1 headings each exit 1 with an objective message, and `INDEX.md` stays unchanged.

## 3. Skill, command, template, and snippet text

- [x] 3.1 Delete step 4 from `skills/fast-track-ai-init/SKILL.md` and the conformance sentence from `commands/fast-track-ai-init.md`. Verify: `rg -n 'assets/legacy|normaliz|conformance|non-conforming' skills/fast-track-ai-init/SKILL.md skills/fast-track-ai-init/assets commands/fast-track-ai-init.md` returns nothing. The index script's ref-hash message (`normalized inline source content`) is unrelated to init migration and is out of this search.
- [x] 3.2 Remove the leftover-`spec/` and `plan.md` sentences from:
  - `skills/fast-track-ai-implement/SKILL.md` step 1
  - `skills/fast-track-ai-spec/SKILL.md` step 2
  - the `## File rules` section of `skills/fast-track-ai-spec/assets/spec.md`
  - `skills/fast-track-ai-init/assets/AGENTS-snippet.md`
  - `commands/fast-track-ai-implement.md` and `commands/fast-track-ai-spec.md`

  State the track root once as `intent.md`, `spec.md`, `tasks.md`, and `assets/`. Verify: `rg -n 'leftover|historical|plan\.md|spec/` |legacy' skills commands` returns no match outside the index and gate scripts' error messages.

## 4. Evals

- [x] 4.1 Invert the legacy assertions in `evals/run-evals.sh`:
  - The `index` and `active` selectors expect `invalid status: active` and an unchanged `INDEX.md`.
  - Offset and P0/P1 handoffs fail.
  - The `approval` and `spec` selectors expect failure for root `plan.md`, root `decisions.md`, `spec/`, and ungrouped tasks.
  - `run_init` stops asserting normalization text and asserts that it is absent.
  - Remove the legacy comment-position check.

  Update the affected rows in `evals/evals.md`, and replace the remaining "legacy accepted" wording. Verify: `bash evals/run-evals.sh all` exits 0 and prints `PASS: all evals`.
- [x] 4.2 Run the final checks. Verify:
  - `rg -n 'HHmm-OFFSET|P0 next actions|assets/legacy|accepted only as a legacy' skills commands evals` matches only `expect_failure` fixtures in `evals/run-evals.sh`.
  - `bash evals/run-evals.sh all` exits 0.
  - `bash -n` passes on `evals/run-agent-evals.sh` and `evals/agent/kiro-adapter.sh`.
