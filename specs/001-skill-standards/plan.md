# Implementation Plan: Skill Standards Compliance

**Branch**: `001-skill-standards` | **Date**: 2026-09-15 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-skill-standards/spec.md`

## Summary

Bring the 6 `dot-ai-*` skills into compliance with the skill-creator reference guide: pushy trigger descriptions, per-skill resource anatomy, and lightweight evals. Shared scripts get one declared owner each; the `shared/` tree is removed.

## Technical Context

**Language/Version**: Markdown skills + POSIX bash (existing stack, no change)

**Primary Dependencies**: None new. Base third-party skills (`research`, `handoff`, `grilling`) reused as-is.

**Storage**: N/A (files in `skills/`)

**Testing**: Existing `/tmp` validation (syntax, init, index, gate FAIL/PASS) plus new lightweight eval prompts with expected files and exit codes.

**Target Platform**: Any machine with bash, `grep`, `sed`, `awk` (POSIX, macOS and Linux)

**Project Type**: skills package (agent skills, not application code)

**Performance Goals**: N/A

**Constraints**: English-only user-facing prose; `via: rapida | completa` enum frozen; no live target touched, scratch repos only.

**Scale/Scope**: 6 skills, 3 shared scripts, 5 shared templates to migrate; 1 installer script to update.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- I. Surgical Changes: migration lands as one behavior per commit (audit, descriptions, layout, evals). PASS.
- II. No Stubs: every moved script re-validated in `/tmp` after the move. PASS.
- III. Package Portability: per-skill layout MUST NOT reintroduce machine-fixed paths; owner copies referenced by package-relative path. PASS with gate below.
- IV. Gate-Locked Flow: no intent/plan/implement locks are weakened; MUSTs preserved with rationale. PASS.
- V. Validation Before Yield: FAIL/PASS states re-exercised post-migration. PASS.
- Portability gate: after migration, `grep` MUST show zero references to `skills/shared` outside historical notes. Any leftover reference fails the gate.

## Project Structure

### Documentation (this feature)

```text
specs/001-skill-standards/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
skills/
├── dot-ai-init/         # SKILL.md + scripts/dot-ai-init.sh + assets/ (AGENTS-snippet, INDEX seed)
├── dot-ai-intent/       # SKILL.md + assets/ (intent template)
├── dot-ai-plan/         # SKILL.md + scripts/sdd-gate.sh + assets/ (plan, tasks templates)
├── dot-ai-implement/    # SKILL.md (references owner copies, no new scripts)
├── dot-ai-research/     # SKILL.md (no bundled resources)
├── dot-ai-handoff/      # SKILL.md (no bundled resources)
├── dot-ai-index-owner/  # NOT a skill: index script owner is dot-ai-init (see research.md)
```

**Structure Decision**: Per-skill anatomy per FR-005. Owner assignments: `dot-ai-index.sh` → `dot-ai-init`; `sdd-gate.sh` → `dot-ai-plan`; `dot-ai-specify.sh` → `dot-ai-intent`; templates follow their primary skill (`intent` → intent, `plan`+`tasks` → plan, `decisions` → plan, `AGENTS-snippet` → init). Rationale in `research.md`.

## Complexity Tracking

> No constitution violations. Table intentionally empty.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| — | — | — |
