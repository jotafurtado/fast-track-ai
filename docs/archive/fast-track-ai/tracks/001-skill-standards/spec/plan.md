---
status: approved
---

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

## Phase 6: Convergence Remediation

**Done**: The eight convergence findings are fixed, each targeted validation passes, the full regression runner passes, and the final structural gate passes while the track remains `active` for user review.

**Files**:

- `.specify/memory/constitution.md`
- `.specify/templates/plan-template.md`
- `.specify/templates/tasks-template.md`
- `AGENTS.md`
- `install.sh`
- `skills/dot-ai-init/SKILL.md`
- `skills/dot-ai-init/assets/AGENTS-snippet.md`
- `skills/dot-ai-intent/SKILL.md`
- `skills/dot-ai-intent/scripts/dot-ai-specify.sh`
- `skills/dot-ai-plan/SKILL.md`
- `skills/dot-ai-plan/assets/plan.md`
- `skills/dot-ai-plan/assets/tasks.md`
- `skills/dot-ai-plan/scripts/sdd-gate.sh`
- `skills/dot-ai-implement/SKILL.md`
- `dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`
- `dot-ai/tracks/001-skill-standards/spec/audit.md`
- `dot-ai/tracks/001-skill-standards/spec/checklists/requirements.md`
- `dot-ai/tracks/001-skill-standards/spec/contracts/skill-package.md`
- `dot-ai/tracks/001-skill-standards/spec/evals.md`
- `dot-ai/tracks/001-skill-standards/spec/plan.md`
- `dot-ai/tracks/001-skill-standards/spec/tasks.md`
- `dot-ai/INDEX.md`

**Accept**: `bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all` and `skills/dot-ai-plan/scripts/sdd-gate.sh --track 001-skill-standards --root .` both exit 0.

### Execution Order

1. T028 creates the shared regression runner and proves its fixture self-check.
2. T022, T024, T027, and T029 may run in parallel because they edit different files.
3. T023 runs before T026 because both may edit `skills/dot-ai-plan/SKILL.md`.
4. T025 runs after every source fix and records the final evidence-backed audit.
5. The main agent runs the complete eval suite, structural gate, review, checkbox mirror, and index regeneration.

### Task File Boundaries

- T022: `.specify/memory/constitution.md`
- T023: `.specify/templates/plan-template.md`, `.specify/templates/tasks-template.md`, `skills/dot-ai-init/assets/AGENTS-snippet.md`, `skills/dot-ai-plan/SKILL.md`, `skills/dot-ai-plan/assets/plan.md`, `skills/dot-ai-plan/assets/tasks.md`, `skills/dot-ai-plan/scripts/sdd-gate.sh`, `skills/dot-ai-implement/SKILL.md`
- T024: `install.sh`
- T025: `dot-ai/tracks/001-skill-standards/spec/audit.md`, `dot-ai/tracks/001-skill-standards/spec/checklists/requirements.md`
- T026: `skills/dot-ai-init/SKILL.md`, `skills/dot-ai-intent/SKILL.md`, `skills/dot-ai-plan/SKILL.md`
- T027: `skills/dot-ai-intent/scripts/dot-ai-specify.sh`
- T028: `AGENTS.md`, `dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`, `dot-ai/tracks/001-skill-standards/spec/evals.md`
- T029: `dot-ai/tracks/001-skill-standards/spec/contracts/skill-package.md`

## Out of Scope

Third-party base skills and the full skill-creator benchmark viewer remain outside this track.
