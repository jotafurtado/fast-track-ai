# Design

## Context

See proposal.md for motivation. Current state that shapes the approach:

- `install.sh` links only `skills/fast-track-ai-*` and `commands/fast-track-ai-*.md`. Anything else in the repository is not shipped.
- The runner at `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh` computes `repo_root` five levels up. Its selectors read the legacy tree in five places:
  - `approval` gates tracks 008 to 010 of this repository.
  - `audit` reads `spec/audit.md`.
  - `workflows` counts license rows in `research/artifact-standards.md`.
  - `decisions` reads ADR 007.
  - `contract` reads `spec/contracts/skill-package.md`.
- The runner's `refs` selector asserts capture-rule strings in the ref template's `## Contract` section. `decisions` asserts `evidence: []` in the ADR template. `workflows` asserts the P0, P1, and First next action headings in the handoff template.
- The index requires all eleven handoff headings, including the three being merged.
- The gate is not changed by this change. The init script stays deterministic and non-interactive.
- The continuous-flow spec requires the managed block to keep stating that intent, spec, and implement end with the four-bullet summary and a next-step line.

## Goals / Non-Goals

**Goals:**

- The eval suite runs green in a clone with the `fast-track-ai/` directory removed.
- Every template change is paired with an eval assertion or index check that fails if it regresses.
- Consuming repositories with older artifacts keep indexing successfully.

**Non-Goals:**

- A script-level conformance scanner. Init uses the existing gate from the skill.
- Changing gate rules to accept or reject new shapes.
- Agent-driven evals of the new procedure text. That work belongs to delivery-quality 2.

## Decisions

### 1. Runner moves to `evals/` at the repository root

**Choice:** `git mv` both `run-evals.sh` and `evals.md` to `evals/`. `repo_root` becomes one level up from the script.

**Why:** The runner is a maintainer tool for the package, not a shipped skill resource, so it sits beside `skills/` and outside every skill directory. `install.sh` does not link it.

**Alternatives:**
- Keep the runner in the archive and only drop the reads (rejected: the maintainer abandoned that tree, and the documented command would still point into it).
- Put the runner under `skills/` (rejected: install would ship it into every harness).

### 2. Retired and rewired selectors

**Choice:**
- Delete `run_audit`, `run_contract`, and their `case` and `all` entries.
- In `approval`, delete the loop that gates this repository's tracks. The fixture assertions stay.
- In `workflows`, delete the `artifact-standards.md` license-row assertions. The package-file checks for the Jhony Walker text stay.
- In `decisions`, delete the ADR 007 block. The `superseded_by` fixture stays.
- Add assertions for every new contract:
  - The path rule in each `SKILL.md`.
  - The snippet omits its retired paragraphs and keeps the approval lock and the summary scope sentence.
  - The ref template has no `## Contract`, and the intent skill holds the capture rules that were in it.
  - The ADR template has no `evidence:` field.
  - The handoff template has `## Next actions`, and the index accepts both heading sets and rejects a handoff with neither.
  - The init skill names the owner gate and the normalization question.
  - The intent template has the three `Assumed state` lists.
  - The spec and tasks templates define Done, Accept, the phase tag, and Validate.
  - The research and assess skills carry the collision rules.
- A new `isolation` selector copies the repository without `fast-track-ai/` into the work dir and runs `all` there.

**Why:** The removed checks tested archive data, not package behavior. The isolation selector turns "self-contained" into an executable claim.

**Alternatives:** Recreate the removed artifacts as fixtures (rejected: they asserted specific historical content with no package contract behind it).

The isolation selector runs the copy's runner with an environment guard so that it does not recurse into `isolation` again.

### 3. Init conformance check lives in the skill, not the script

**Choice:** After step 3 of the init skill, add a step that walks `fast-track-ai/tracks/*/intent.md`, reads `status`, and runs `../fast-track-ai-spec/scripts/fast-track-ai-gate.sh` in the mode the spec names. Init collects the failures, asks one yes-or-no question, and normalizes only on yes.

Normalization procedure:
1. Move each gate-rejected root entry to `assets/legacy/<name>`, and stop on a destination collision.
2. Rewrite `spec.md` and `tasks.md` from the owner templates using only content present in the track. Keep the existing `status`. On a status mismatch, such as a shipped intent with a draft spec, ask before approving.
3. Rerun the gate and report the result per track.

**Why:** Asking is a harness interaction that a shell script cannot perform. The gate already encodes the contract, so a second scanner would duplicate it. Keeping the script unchanged preserves the `init` eval's byte-identical rerun guarantee.

**Alternatives:**
- A `--check` flag on `fast-track-ai-init.sh` (rejected: it would duplicate gate logic and still need the skill to ask).
- An index-time warning (rejected: every skill would surface it, not just the adoption point).

### 4. Handoff index accepts either heading set

**Choice:** The index requires the eight shared headings. It then requires either `## Next actions` or all three legacy headings. When neither set is complete, it fails with `missing heading ## Next actions`.

**Why:** Consuming repositories may hold active handoffs in the old shape. The filename format already has the same dual acceptance.

### 5. Evidence lives only in the ADR body

**Choice:** Drop `evidence: []` from the template. Keep `## Evidence` with the `None` instruction. The index already ignores the field, so existing ADRs that carry it stay valid.

**Why:** A body section can hold a citation with its reason, and nothing reads the frontmatter list.

### 6. Ref rules move into the intent skill

**Choice:** The intent skill's Ref bullet absorbs the template-only rules:
- UTF-8 and LF normalization with one terminal LF, and a hash that covers only the source bytes.
- `pin` or `retrieved_at`, never both.
- Schema-only metadata enrichment.
- Reuse of a matching hash.

The template keeps frontmatter, `## Capture notes`, and both type sections, each labeled with its type. The skill says to delete the section that does not apply. The index still requires `## Source content` for inline refs.

**Why:** One owner per rule. The template becomes a shape, and the skill becomes the procedure.

**Alternatives:** Two templates, `ref-inline.md` and `ref-pointer.md` (rejected: it would change the `resources` owner count and add a file for a two-section difference).

### 7. Managed block content

**Choice:** The snippet keeps these paragraphs:
- The memory location and reading INDEX first.
- The cycle and the approval lock, plus the sentence that research, assess, and handoff may stop after their artifact.
- The continuous-flow paragraph, unchanged.
- One line per artifact location.
- The track root rule.
- The intent status rule.

It drops Intent autonomy, Tasks parallelism, Explicit actions, Automatic captures, the per-artifact contract bullets, and the ownership rule.

**Why:** Those paragraphs restate owner skills, and the ownership rule governs this package's source tree, not a consumer.

### 8. Repository `AGENTS.md` and README

**Choice:**
- `AGENTS.md`:
  - Delete the managed block.
  - Add `evals/` to Map and point Install at `./evals/run-evals.sh all`.
  - State that `install.sh` also links commands.
  - Add one rule: this repository does not run the method on itself, so `fast-track-ai-init` is never run here, and `fast-track-ai/` is a read-only archive.
- README:
  - Remove the retired line from the protocol list and the paragraph that repeats it.
  - Fix the handoff path to `YYYY-MM-DD-HHmmssZ`.
  - Update the `Assumed state` sentence to the three lists.
  - Remove the tree lines for `fast-track-ai/` and `openspec/specs/` and the paragraph listing OpenSpec specs.
  - Mention init's conformance question where init is described.

**Why:** Without the rule, a later session could run init here and reinstall the block. The README is package documentation and should describe only the package.

## Risks / Trade-offs

- [The procedure text for init, resume, divergence, and delegation is checked only by string presence] → Accepted and scoped out as delivery-quality 2. The isolation selector and index fixtures cover every deterministic part.
- [Normalization might rewrite a consumer's track badly] → It runs only after an explicit yes. It preserves prior content under `assets/legacy/`, never invents values, and reruns the gate.
- [The `git mv` of the runner edits the archive] → It is the only archive edit, and it is required to stop the archive from being a test dependency. Git history keeps the old paths.
- [The shorter managed block loses guidance a consumer relied on] → Every dropped paragraph restates an owner skill that the agent loads when the skill runs.
- [ADR 003 in the archive still says the runner lives under 001] → The archive is historical, and no live file cites it.

## Migration Plan

1. Move the runner, rewire selectors, and confirm `all` passes before any template edit.
2. Apply the template, skill, and index edits together with their assertions.
3. Edit `AGENTS.md` and the README.
4. Run `evals/run-evals.sh all` and `openspec validate close-assessment-gaps --strict`.
5. Rollback is `git revert` of the change commits. No consumer data migrates, because the index keeps accepting old handoffs and ADRs.
