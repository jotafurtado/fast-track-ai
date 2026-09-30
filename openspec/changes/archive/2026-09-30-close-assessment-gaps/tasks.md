# Tasks

## 1. Self-contained eval suite

- [x] 1.1 `git mv` `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh` to `evals/run-evals.sh` and `spec/evals.md` to `evals/evals.md`. Set `repo_root` to one level above the script. Verify: `bash -n evals/run-evals.sh` passes and `evals/run-evals.sh self` exits 0.
- [x] 1.2 Update the runner's selectors:
  - Delete `run_audit` and `run_contract` and their `case` and `all` entries.
  - In `run_approval`, delete the loop that gates tracks 008 to 010 of the repository.
  - In `run_workflows`, delete the `artifact-standards.md` license-row assertions.
  - In `run_decisions`, delete the ADR 007 block.

  Verify: `rg -n 'repo_root/fast-track-ai|repo_root"/fast-track-ai|--root "\$repo_root"' evals/run-evals.sh` returns nothing, `evals/run-evals.sh audit` and `evals/run-evals.sh contract` exit non-zero with `unknown eval`, and `evals/run-evals.sh all` exits 0.
- [x] 1.3 Add an `isolation` selector. It copies `skills/`, `commands/`, `install.sh`, `AGENTS.md`, and `evals/` into the work dir without `fast-track-ai/`, then runs the copy's runner with `all` under an environment guard that stops it from running `isolation` again. Add `isolation` to `all`. Verify: `evals/run-evals.sh isolation` exits 0, and so does `evals/run-evals.sh all`.
- [x] 1.4 Rewrite `evals/evals.md`:
  - Remove the `audit` and `contract` rows.
  - Add the `isolation` row.
  - Update the `approval` and `workflows` descriptions and the runner command to `bash evals/run-evals.sh all`.
  - Keep the behavioral fixture sections.

  Verify: every selector in the runner's `all` list has exactly one table row, and the file contains no `001-skill-standards` path.

## 2. Repository instructions and README

- [x] 2.1 Edit `AGENTS.md`:
  - Delete everything from `<!-- BEGIN MANAGED BLOCK: fast-track-ai` through `<!-- END MANAGED BLOCK: fast-track-ai -->`.
  - Add `evals/` to Map.
  - Change the Install command to `./evals/run-evals.sh all` and state that `install.sh` also links `commands/fast-track-ai-*.md`.
  - Add the rule that this repository does not run the method on itself: never run `fast-track-ai-init` here, and treat `fast-track-ai/` as a read-only archive.

  Verify: `rg -c 'MANAGED BLOCK' AGENTS.md` prints nothing, `rg -F './evals/run-evals.sh all' AGENTS.md` matches, and `evals/run-evals.sh init` exits 0.
- [x] 2.2 Edit `README.md`:
  - Remove `Track concluida. Nenhuma implementacao necessaria.` and the paragraph that repeats it.
  - Change the handoff path to `YYYY-MM-DD-HHmmssZ-<slug>.md`.
  - Remove the tree lines for `fast-track-ai/` and `openspec/specs/`, the paragraph on the repository's own `fast-track-ai/`, and the OpenSpec spec list.
  - Replace the `Assumed state` sentence with the three lists.
  - Mention init's conformance question.

  Verify: `rg -n -i 'openspec|Track concluida|HHmm-OFFSET' README.md` returns nothing.

## 3. Init conformance and managed block (depends on 1)

- [x] 3.1 Add a conformance step to `skills/fast-track-ai-init/SKILL.md`, after the index step:
  - Walk each `fast-track-ai/tracks/*/intent.md`, read `status`, and run `../fast-track-ai-spec/scripts/fast-track-ai-gate.sh` in the mode package-surface specifies.
  - List the failing tracks with each one's first gate message and ask one yes-or-no question about normalizing them. Change no track before the answer.
  - On yes, move rejected root entries to `assets/legacy/<name>` and stop on a collision. Rewrite `spec.md` and `tasks.md` from the owner templates using only existing content. Ask before any approval or any value that cannot be derived, then rerun the gate.
  - On no, report the tracks as left non-conforming.

  Update `commands/fast-track-ai-init.md` to match. Add `init` selector assertions that the skill names the owner gate path, the yes-or-no question, `assets/legacy/`, and the rule against inventing values. Verify: `evals/run-evals.sh init` and `evals/run-evals.sh resources` exit 0.
- [x] 3.2 Rewrite `skills/fast-track-ai-init/assets/AGENTS-snippet.md` to the paragraphs listed in design decision 7. Keep the continuous-flow paragraph and the approval lock verbatim. Add `init` assertions that the snippet:
  - Lacks `Intent autonomy`, `Tasks parallelism`, and `Each script and template has one owner skill`.
  - Contains `status: approved` and `intent, spec, and implement end with a four-bullet summary`.

  Verify: `evals/run-evals.sh init` exits 0, including the byte-identical refresh fixture.

## 4. Intent, ref, and research trigger (depends on 1)

- [x] 4.1 Update `skills/fast-track-ai-intent/SKILL.md`:
  - Reword the Research trigger per the modified continuous-flow requirement, removing the familiarity waiver.
  - Move every rule from the ref template's `## Contract` into the Ref bullet.
  - Say to keep only the section for the chosen type.
  - Say to fill `Assumed state` by provenance.

  Keep the strings asserted by the `refs` and `decisions` selectors. Verify: `rg -F 'Well-known technologies' skills` returns nothing, and `evals/run-evals.sh refs` and `evals/run-evals.sh decisions` exit 0.
- [x] 4.2 Edit `skills/fast-track-ai-intent/assets/ref.md`: delete `## Contract`, and label `## Locator` as pointer-only and `## Source content` as inline-only. Edit `skills/fast-track-ai-intent/assets/intent.md` so `## Assumed state` holds `Stated by the user`, `Unverified assumptions`, and `Access limits`. Move the `refs` selector's template string assertions to the intent skill. Assert that the ref template has no `## Contract` and that the intent template has the three lists. Verify: `evals/run-evals.sh refs` and `evals/run-evals.sh index` exit 0.
- [x] 4.3 Update `commands/fast-track-ai-intent.md` where it cites the old research trigger or `Assumed state` wording. Verify: `rg -n 'unknown tech|without questioning' README.md commands skills` returns nothing.

## 5. Spec, tasks, and ADR templates (depends on 1)

- [x] 5.1 Edit `skills/fast-track-ai-spec/assets/spec.md`:
  - `Done:` names the delivered, observable state.
  - `Accept:` names the proving command or procedure and its expected result.

  Edit `skills/fast-track-ai-spec/assets/tasks.md` so every task line reads `- [ ] Task N (Phase N): name. Files: list. Validate: command or procedure with expected result.` Update `skills/fast-track-ai-spec/SKILL.md` steps 2 and 3 to define Done, Accept, the phase tag, and Validate. Add `spec` selector assertions for those definitions. Verify: `evals/run-evals.sh spec` exits 0, and a fixture built from the new templates passes `--mode structure`.
- [x] 5.2 Edit `skills/fast-track-ai-spec/assets/decisions.md` to drop `evidence: []`. Add to `skills/fast-track-ai-spec/SKILL.md` the replacement procedure: create the next accepted ADR, set the original to `superseded` with `superseded_by`, and keep its decision text. Update the `decisions` selector to assert that the template has no `evidence:` field, still has `## Evidence`, and that the skill has the replacement procedure. Verify: `evals/run-evals.sh decisions` and `evals/run-evals.sh index` exit 0.

## 6. Implement procedure (depends on 1)

- [x] 6.1 Update `skills/fast-track-ai-implement/SKILL.md`:
  - In step 2, replace `Never question assumed_state` with the stated-versus-unverified rule and the divergence stop recorded under the track's `assets/`.
  - In step 4, add proportional delegation and deferred global checks.
  - Add the resume rule: continue from the first open task, and rerun a checked task's Validate only when later edits touch its Files.

  Keep the ADR phrases the `decisions` selector asserts. Verify: `rg -F 'Never question' skills` returns nothing, and `evals/run-evals.sh decisions` and `evals/run-evals.sh flow` exit 0.

## 7. Research, assess, and handoff (depends on 1)

- [x] 7.1 Update `skills/fast-track-ai-research/SKILL.md` with the inconclusive-result rule and the slug collision rule. Update `skills/fast-track-ai-assess/SKILL.md` and `skills/fast-track-ai-assess/assets/assessment.md` with:
  - The finding format: problem, evidence, consequence, recommendation, and priority from consequence.
  - The `tracks` content rule.
  - The same-day collision rule.

  Add `workflows` assertions for each rule. Verify: `evals/run-evals.sh workflows` exits 0.
- [x] 7.2 Replace `## P0 next actions`, `## P1 next actions`, and `## First next action` in `skills/fast-track-ai-handoff/assets/handoff.md` with one `## Next actions` ordered list whose first item is the first step. Update `skills/fast-track-ai-handoff/SKILL.md` and `commands/fast-track-ai-handoff.md`. In `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`, require the eight shared headings plus either `## Next actions` or all three legacy headings. Add `index` and `handoff` fixtures for:
  - A new-format handoff: accepted.
  - A legacy-format handoff: accepted.
  - A handoff with neither set: rejected, with `INDEX.md` unchanged.

  Update the `workflows` heading list. Verify: `evals/run-evals.sh index`, `evals/run-evals.sh handoff`, and `evals/run-evals.sh workflows` exit 0.

## 8. Path rule (depends on 3, 4, 5, 6, 7)

- [x] 8.1 Add one line to each of the seven `skills/fast-track-ai-*/SKILL.md` files: `./` and `../fast-track-ai-*` paths resolve from this skill's installed directory, and `fast-track-ai/` paths resolve from the target repository root. Add a `resources` assertion that loops over every skill. Verify: `evals/run-evals.sh resources` exits 0.

## 9. Integration

- [x] 9.1 Run `evals/run-evals.sh all`. Run `openspec validate close-assessment-gaps --strict`. Run `rg -n -i 'openspec' skills commands install.sh README.md AGENTS.md evals`. Run `git status --short fast-track-ai/`. Verify: the runner prints `PASS: all evals`, validation passes, the `rg` returns nothing, and git status shows only the two renamed eval files under `fast-track-ai/`.
