# Proposal

## Why

The archived change `2026-09-30-close-assessment-gaps` left six items of the 2026-09-21 skills assessment out of scope: 1.3, 1.5, 3.2, 4.8, 7.3, and 8.2. Each leaves a gap between what the method states and what its scripts check or its skills do. The gaps are a legacy status with no stated purpose, metadata parsed more loosely than the templates imply, a track root check that ignores hidden and mistyped entries, a review step that seems to depend on a file consumers do not have, a handoff that archives before it checks itself, and a second ADR location that no procedure uses.

## What Changes

- **`active` stays a legacy-only intent status (1.3).**
  - The index keeps accepting `active` so consuming repositories with old intents still index. A comment in the script and the spec state that this is for legacy values only.
  - No skill, command, template, or managed block writes `active`. The default eval fixtures use `draft`. One dedicated fixture proves the legacy value is still accepted.
  - This deliberately departs from the assessment, which recommended removing `active`. Removing it would break the index in consuming repositories.
- **Frontmatter uses a documented canonical subset (1.5).**
  - Line 1 is `---`, and a later `---` line closes the block.
  - Each non-blank line between the delimiters is one `key: value` field, and no key appears twice.
  - The index and the gate reject an unclosed block, a duplicate key, and a line that is not a field, each with an objective message naming the file. Field extraction reads only the block that opens on line 1. No YAML library is added.
- **The gate checks the whole track root (3.2).**
  - Hidden root entries fail.
  - `intent.md`, `spec.md`, `tasks.md`, and `decisions.md` must be regular files. `assets` and `spec` must be directories.
  - **BREAKING** (consumers): a track holding a hidden entry such as `.DS_Store`, or a mistyped allowed entry, now fails the gate.
- **The code-review reference is provenance only (4.8).** The implement skill states that `fast-track-ai/refs/code-review-skill` names where the approach came from, that the full review procedure is in the skill, and that the consuming project does not need that ref.
- **Handoff validates before archiving (7.3).**
  1. Check for collision before writing.
  2. Write the new handoff, then validate it: required headings, a `captured` format matching the filename instant, and no collision.
  3. Only after that passes, archive older handoffs.
  4. Then run the index.
- **Root `decisions.md` becomes legacy (8.2).**
  - The managed snippet, the spec template, and the README stop listing `decisions.md` as a track-root file.
  - The gate still accepts it, so existing tracks keep passing.
  - The init conformance check lists any track with a root `decisions.md` as legacy, in the same single yes-or-no question. On yes, it moves the file to `assets/legacy/decisions.md`.
- **Evals:** each script or template change gets an assertion or fixture in `evals/run-evals.sh` that fails when the change regresses. `evals/evals.md` describes the new checks.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `package-surface`:
  - The `active` requirement states that the value is legacy-only and requires a dedicated legacy fixture.
  - The managed block's track-root rule drops `decisions.md`.
  - Init conformance treats a root `decisions.md` as legacy and moves it on consent.
- `track-gate`: Structure mode rejects hidden root entries and mistyped allowed entries, and validates frontmatter in `intent.md`, `spec.md`, and `tasks.md`.
- `method-artifacts`:
  - New requirement: a canonical frontmatter subset, enforced by the index and the gate.
  - The handoff requirement orders write, validate, archive, then index.
- `implement-workflow`: New requirement: the review procedure is self-contained, and the code-review ref is provenance only.

## Impact

- **Scripts:** `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh` and `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`. The init script does not change.
- **Templates:** `skills/fast-track-ai-init/assets/AGENTS-snippet.md` and `skills/fast-track-ai-spec/assets/spec.md`.
- **Skills:** `fast-track-ai-implement`, `fast-track-ai-handoff`, and `fast-track-ai-init` `SKILL.md`.
- **Commands:** `commands/fast-track-ai-handoff.md`, if its wording of the order conflicts.
- **Docs:** `README.md` (track-root line) and `evals/evals.md`.
- **Evals:** `evals/run-evals.sh`.
- **Consumers:** the gate becomes stricter on track roots and frontmatter. Init conformance is the documented path to fix existing tracks.
- **Not in scope:**
  - Agent-driven behavioral evals.
  - Merging `Done` with `Accept`.
  - Any edit under the repository's `fast-track-ai/` tree.
  - Removing `active` or root `decisions.md` from the validators.
