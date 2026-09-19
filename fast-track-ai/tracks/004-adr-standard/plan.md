---
status: approved
---

# Plan: 004-adr-standard

## Phase 1: ADR template and filing rule
Done: The plan-owned template is one file per ADR (`id`, `status`, `date`, `owner`, Context, Decision, Rationale, Alternatives considered, Consequences). Plan and implement tell the agent when a write is a qualifying decision and where to file it.
Files: `skills/fast-track-ai-plan/assets/decisions.md`, `skills/fast-track-ai-plan/SKILL.md`, `skills/fast-track-ai-implement/SKILL.md`
Accept: Template greps have no track-log heading; skill texts name `fast-track-ai/decisions/<NNN-slug>.md` and `accepted | superseded`.

## Phase 2: Index third table
Done: `fast-track-ai-index.sh` still writes tracks and assessments, then a decisions table (`decision`, `status`). It validates ADR files and fails on `proposed`, missing required fields, or `superseded` without `superseded_by`.
Files: `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`
Accept: A scratch tree with one valid ADR lists it; a file with `status: proposed` makes the index exit 1.

## Phase 3: Intent citation and AGENTS rule
Done: Intent skill cites ADRs in `decisions:`. Managed AGENTS block names `fast-track-ai/decisions/` and repeats that a recorded Decision is never relitigated.
Files: `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`
Accept: Skill text names `decisions:` and `fast-track-ai/decisions/`; both AGENTS files name that path; `AGENTS.md` still has one managed block.

## Phase 4: Promote complete 005 records
Done: Four ADR files exist under `fast-track-ai/decisions/` for the 005 records. Rationale and Alternatives are `None`. Decision text matches the 005 source. The 005 `decisions.md` is not rewritten as the source of truth. `005` intent `decisions:` lists the four slugs.
Files: `fast-track-ai/decisions/001-spec-md-owner.md`, `fast-track-ai/decisions/002-historical-spec-dir.md`, `fast-track-ai/decisions/003-live-evals-vs-frozen-spec.md`, `fast-track-ai/decisions/004-drop-vendored-speckit.md`, `fast-track-ai/tracks/005-lightweight-sdlc/intent.md`, `fast-track-ai/INDEX.md`
Accept: Index decisions table has those four rows at `accepted`; each Decision paragraph equals the 005 source; `grep` of those files finds `Rationale` and `Alternatives considered` as `None`.

## Phase 5: Scratch validation
Done: Init, index, and one accepted ADR are green in `/tmp`. A second init stays idempotent. Injecting `status: proposed` makes index exit 1. This repo is not the scratch target.
Files: none in this repo beyond reading the scripts above
Accept: Scratch index exits 0 with three tables; `status: proposed` then exits 1.

## Out of scope
Writing ADRs for trivial preferences. Resolving findings in `2026-09-15-project-completeness.md` other than the missing decision standard. Changing third-party ADR tools. Unified spec (`008`). Track terminal states (`009`). Refs standard (`007`) beyond citing existing slugs. Filing the Obsidian ADR clipping as a ref.

## File rules
Auxiliary outputs (inventories, reports, exports, evidence) go under `assets/`, never loose at the track root. Track root holds only `intent.md`, `spec.md`, `plan.md`, `tasks.md`, `decisions.md`, plus `assets/`. A leftover `spec/` directory is historical and does not select a cycle.
