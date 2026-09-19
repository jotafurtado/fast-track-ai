---
status: approved
---

# Plan: 002-assessment-standard

## Phase 1: Template and filing rule
Done: The init-owned template has `captured`, `owner`, `scope`, optional `tracks`, and no `status`. Init tells the agent when a write is an assessment and where to file it.
Files: `skills/fast-track-ai-init/assets/assessment.md`, `skills/fast-track-ai-init/SKILL.md`
Accept: Template greps have no `^status:`; skill text names the filename shape and forbids `status`.

## Phase 2: Index second table
Done: `fast-track-ai-index.sh` still writes the tracks table, then an assessments table (`assessment`, `captured`). It validates assessment files and fails on `status` or missing required fields.
Files: `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`
Accept: A scratch tree with one valid assessment lists it; a file with `status` makes the index exit 1.

## Phase 3: Intent citation and AGENTS rule
Done: Intent template has `assessments: []`. Intent skill cites existing assessments there, not in `research`. Managed AGENTS block distinguishes assessments from research.
Files: `skills/fast-track-ai-intent/assets/intent.md`, `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`
Accept: New intent template greps `^assessments:`; AGENTS managed block names `fast-track-ai/assessments/` and says assessments have no `status`.

## Phase 4: Align the existing example
Done: The completeness report drops `status` and keeps its findings. Index in this repo lists that file. Findings are not edited.
Files: `fast-track-ai/assessments/2026-09-15-project-completeness.md`, `fast-track-ai/INDEX.md`
Accept: File has no `^status:`; `INDEX.md` has an assessments table row for `2026-09-15-project-completeness`.

## Phase 5: Scratch validation
Done: Init, index, and a one-file assessment are green in `/tmp`. A second init stays idempotent. This repo is not the scratch target.
Files: none in this repo beyond reading the scripts above
Accept: Scratch index exits 0 with two tables; injecting `status: open` into the scratch assessment makes index exit 1.

## Out of scope
Resolving findings inside `2026-09-15-project-completeness.md`. The ADR standard (`004`). Adding `fast-track-ai-assess`. Changing Matt Pocock skills. Rewriting frozen `001` prose. Changing how `fast-track-ai-plan` asks open intent questions (`006`).

## File rules
Auxiliary outputs (inventories, reports, exports, evidence) go under `assets/`, never loose at the track root. Track root holds only `intent.md`, `spec.md`, `plan.md`, `tasks.md`, `decisions.md`, plus `assets/`. A leftover `spec/` directory is historical and does not select a cycle.
