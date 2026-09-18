---
id: 003-full-cycle-contract
status: dropped
research: []
decisions: []
---

# Intent: Full Cycle Contract

## Problem
The full-cycle wrapper does not reliably route Spec Kit output into the canonical track spec directory. It emits the wrong OMP command form, does not set the feature directory, and allows physical specs to be created in a compatibility view. The adopted track also exposes root-level `plan.md` and `tasks.md` symlinks even though their presence duplicates the artifacts already owned by `spec/`. The current `via: rapida | completa` enum and `via_motivo` field also violate the requirement that frontmatter keys and values remain in English.

## Proposed outcome
An intent with `via: speckit` enters the full Spec Kit cycle through one deterministic wrapper path, while `via: dot-ai` selects the short cycle. All physical full-cycle artifacts live under `dot-ai/tracks/<track>/spec/`, while `dot-ai/specs/<track>` and root `specs/<track>` remain compatibility views. The presence of `spec/` unambiguously selects the full cycle, so root-level `plan.md` and `tasks.md` exist only for the short cycle. All method frontmatter uses English keys and values, and Markdown template structure remains in English regardless of the language the user chooses for document content.

## Users and systems
Method maintainers and coding agents start, plan, validate, and implement full-cycle tracks. The affected systems are the intent wrapper, Spec Kit OMP integration, track layout, structural gate, implementation skill, public specs view, and installed AGENTS rules.

## Constraints
Use `full cycle` and `short cycle` as the canonical English terms. Replace the frozen `via: rapida | completa` enum with `via: speckit | dot-ai` and migrate existing tracks. Rename non-English frontmatter fields such as `via_motivo` to English. Frontmatter keys and values, Markdown template headings, and structural instructions remain in English; users may choose another language only for document body content. Never write physical feature artifacts under `dot-ai/specs/` or root `specs/`. Never duplicate or symlink full-cycle `plan.md` and `tasks.md` at the track root. Preserve short-cycle behavior. Keep the wrapper portable across installed skill locations and target repositories.

## Out of scope
The assessment standard, unrelated findings from the project-completeness report, changes to third-party Spec Kit internals, and redesign of short-cycle artifacts are outside this track.

## Assumed state
`dot-ai/tracks/<track>/spec/` is the canonical full-cycle directory. `dot-ai/specs/<track>` is a symlink to that directory, and root `specs` is the Spec Kit compatibility view. Direct invocation of Spec Kit remains forbidden when the dot-ai wrapper applies. Existing tracks still use the legacy `via: rapida | completa` and `via_motivo` schema and require migration.

## Open questions
- Should the wrapper only emit a harness command, or must it also create and validate the compatibility symlink before handoff? Owner: maintainer.
- Which complete-cycle artifacts are mandatory before the structural gate may pass? Owner: maintainer.
