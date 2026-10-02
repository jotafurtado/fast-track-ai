# Tasks

## 1. Legacy `active` status (1.3)

- [x] 1.1 In `fast-track-ai-index.sh`, add a comment directly above the intent status `case`. It states that `active` is accepted only as a legacy value from earlier package versions and that no live skill writes it. Leave the accepted set unchanged. Verify: `bash -n` passes and `grep -n 'legacy' skills/fast-track-ai-init/scripts/fast-track-ai-index.sh` shows the comment on the line before the `case`.
- [x] 1.2 In `run_index`, switch `001-example` to `draft` and update its row assertion to `| 001-example | draft |`. Add a dedicated `003-legacy-active` intent written `active`, and assert `| 003-legacy-active | active |`. Verify: `evals/run-evals.sh index` exits 0, and `grep -n '"active"' evals/run-evals.sh` shows only the legacy fixture and the handoff slug.
- [x] 1.3 Add an `active` selector and register it in `run_case` and `all`. It does the following:
  - Fails if any `skills/fast-track-ai-*/SKILL.md`, `skills/fast-track-ai-*/assets/*`, or `commands/fast-track-ai-*.md` contains `status: active`.
  - Fails if the index script lacks the legacy comment.

  Verify: `evals/run-evals.sh active` exits 0. Temporarily adding `status: active` to a copy of a template under `/tmp` and pointing the check at it makes the check fail; remove the copy afterwards.

## 2. Canonical frontmatter subset (1.5)

- [x] 2.1 In `fast-track-ai-index.sh`:
  - Replace `field` with an extractor that reads only the block opening on line 1.
  - Add the D1 validator: unclosed block, duplicate key, and a line that is not a `key: value` field (blank lines allowed).
  - Run the validator first for every intent, ref, research, assessment, decision, and handoff. On a violation, `fail` with `<file> frontmatter ...` and skip that artifact's other checks.
  - Document the subset in the header comment.

  Verify: `bash -n` passes and `evals/run-evals.sh index` still exits 0.
- [x] 2.2 In `fast-track-ai-gate.sh`:
  - Replace `frontmatter_field` the same way, and add the identical validator.
  - Apply it to `intent.md` before reading `id`, and to `spec.md` and `tasks.md` when present, printing `FAIL: <file> frontmatter ...`.
  - Document the subset in the header comment.

  Verify: `bash -n` passes and `evals/run-evals.sh approval` and `evals/run-evals.sh spec` exit 0.
- [x] 2.3 Add a `frontmatter` selector and register it in `run_case` and `all`. It does the following:
  - Feeds the index and the gate the same malformed fixtures, and asserts the same rule text from both scripts:
    - An unclosed block.
    - A duplicate `status:`, or a duplicate `captured:` in research.
    - An indented `- slug` under `refs:`.
    - A `---` pair below line 1.
  - Asserts that `INDEX.md` is byte-identical after every index rejection.
  - Checks that every template under `skills/fast-track-ai-*/assets/` that starts with `---` passes the same subset rules.

  Verify: `evals/run-evals.sh frontmatter` exits 0. Reverting either script's duplicate-key check in a `/tmp` copy makes the selector fail.

## 3. Track root types and hidden entries (3.2)

- [x] 3.1 In `fast-track-ai-gate.sh`, run the root checks in the D4 order:
  - Enumerate hidden entries, excluding `.` and `..`, and fail with `hidden root entry: <name>`.
  - Keep the unknown-name check.
  - Add the type checks: `must be a file` for `intent.md`, `spec.md`, `tasks.md`, and `decisions.md`, and `must be a directory` for `spec` and `assets`.

  Verify: `bash -n` passes and `evals/run-evals.sh approval` exits 0.
- [x] 3.2 Extend `run_spec` with structure-mode fixtures:
  - `.notes` fails and names `.notes`.
  - `.DS_Store` fails and names `.DS_Store`.
  - A regular file `assets` fails with `must be a directory`.
  - A directory `spec.md` fails with `must be a file`.
  - A regular file `spec` fails with `must be a directory`.
  - A regular root `decisions.md` on an otherwise valid track passes.

  Verify: `evals/run-evals.sh spec` exits 0, and removing the hidden-entry loop in a `/tmp` copy of the gate makes it fail.

## 4. Code-review provenance (4.8)

- [x] 4.1 In `skills/fast-track-ai-implement/SKILL.md` step 7, replace `adapted from \`fast-track-ai/refs/code-review-skill\` (pointer; do not vendor the upstream tree)` with wording that says three things: `fast-track-ai/refs/code-review-skill` names only the provenance of the approach, the full procedure is the text that follows in this skill, and the consuming project does not need that ref. Verify: the step still lists the principles, phases, severities, and fix loop unchanged.
- [x] 4.2 In `run_flow`, assert that the implement skill contains `provenance` and `does not need`, and does not contain `pointer; do not vendor`. Verify: `evals/run-evals.sh flow` exits 0.

## 5. Handoff validates before archiving (7.3)

- [x] 5.1 Rewrite steps 5 to 7 of `skills/fast-track-ai-handoff/SKILL.md` into the spec order:
  - The collision check comes before the write.
  - Then the write.
  - Then validation of the new file: every heading in `./assets/handoff.md`, the `captured` form and its equality with the filename instant, and the frontmatter subset. On failure, fix or stop, and archive nothing.
  - Then archive.
  - Then the index.

  Update `commands/fast-track-ai-handoff.md` to say that the skill validates the new handoff before archiving. Verify: the skill keeps the `./assets/handoff.md` and `../fast-track-ai-init/scripts/fast-track-ai-index.sh` references, and `evals/run-evals.sh resources` exits 0.
- [x] 5.2 In `run_handoff`, assert that the skill's validate line comes before its archive line, and that the archive line comes before its index line, using `grep -n` line numbers. Verify: `evals/run-evals.sh handoff` exits 0, and swapping the steps in a `/tmp` copy makes the assertion fail.

## 6. Root `decisions.md` retired (8.2)

- [x] 6.1 Remove `decisions.md` from the track-root lines of `skills/fast-track-ai-init/assets/AGENTS-snippet.md` and of `skills/fast-track-ai-spec/assets/spec.md` `## File rules`. Change the README line `Raiz da track: ...` the same way. Verify: `grep -n 'decisions.md' skills/fast-track-ai-init/assets/AGENTS-snippet.md skills/fast-track-ai-spec/assets/spec.md README.md` returns nothing.
- [x] 6.2 In `skills/fast-track-ai-init/SKILL.md` step 4, add the D5 legacy rule:
  - List any track with a root `decisions.md`, with the reason `legacy root decisions.md`, in the same single yes-or-no question, including tracks the gate does not check.
  - On yes, move the file to `assets/legacy/decisions.md` with the existing collision stop.
  - State that rejected hidden entries also move to `assets/legacy/`.
  - State the D8 stop for a regular file named `assets`.

  Verify: the step still contains `yes-or-no question` and `Do not invent a Done, Files, Accept, Validate, or approval value`.
- [x] 6.3 In `run_init`, assert that the snippet does not contain `decisions.md` and that the init skill contains `assets/legacy/decisions.md`. In `run_spec`, assert that the spec template does not contain `decisions.md`. Verify: `evals/run-evals.sh init` and `evals/run-evals.sh spec` exit 0.

## 7. Integration

- [x] 7.1 Update `evals/evals.md`:
  - Add the `active` and `frontmatter` rows.
  - Extend the `index`, `spec`, `flow`, `handoff`, and `init` descriptions to cover the new assertions.
  - Update the Spec Cycle failure fixtures and the selector count in `Recorded Run`.

  Verify: every selector in the runner's `all` list has exactly one table row.
- [x] 7.2 Run `bash evals/run-evals.sh all` and `bash evals/run-evals.sh isolation`. Verify: both exit 0 and print `PASS: all evals` and `PASS: isolation`. Also run `git status --short fast-track-ai/`, which must print nothing, and `openspec validate tighten-remaining-contracts --strict`, which must pass.
