# Tasks: Skill Standards Compliance

**Input**: Design documents from `/specs/001-skill-standards/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

## Phase 1: Setup

- [x] T001 Create scratch dirs and snapshot current skills in /tmp/skill-std/snapshot
- [x] T002 Write audit checklist to specs/001-skill-standards/audit.md from skill-creator rules

## Phase 2: Foundational

- [x] T003 Verify baseline green: bash -n on skills/shared/scripts/*.sh plus init/index/gate on scratch repo

## Phase 3: US1 - Skills pass a standards audit

**Story goal**: every skill audited with evidence quotes; gaps become fixes.
**Independent test**: audit.md holds a pass/fail row per rule per skill, each with a quote; re-audit after fixes shows pass.

- [x] T004 [US1] Audit all 6 skills in specs/001-skill-standards/audit.md with evidence quotes
- [x] T005 [P] [US1] Rewrite description in skills/dot-ai-init/SKILL.md in pushy pattern
- [x] T006 [P] [US1] Rewrite description in skills/dot-ai-intent/SKILL.md in pushy pattern
- [x] T007 [P] [US1] Rewrite description in skills/dot-ai-plan/SKILL.md in pushy pattern
- [x] T008 [P] [US1] Rewrite description in skills/dot-ai-implement/SKILL.md in pushy pattern
- [x] T009 [P] [US1] Rewrite description in skills/dot-ai-research/SKILL.md in pushy pattern
- [x] T010 [P] [US1] Rewrite description in skills/dot-ai-handoff/SKILL.md in pushy pattern
- [x] T011 [US1] Fix remaining audit failures and re-audit to all-pass in specs/001-skill-standards/audit.md

## Phase 4: US2 - Shared layout decision recorded and migrated

**Story goal**: per-skill anatomy live, shared/ gone, decision traceable.
**Independent test**: fresh install resolves every cross-skill reference; no `shared` path exists; decision recorded in research.md.

- [x] T012 [US2] Move skills/shared/scripts/dot-ai-index.sh into skills/dot-ai-init/scripts/
- [x] T013 [US2] Move skills/shared/scripts/sdd-gate.sh into skills/dot-ai-plan/scripts/
- [x] T014 [US2] Move skills/shared/scripts/dot-ai-specify.sh into skills/dot-ai-intent/scripts/
- [x] T015 [US2] Move templates into per-skill assets/ (intent, plan+tasks+decisions, AGENTS-snippet per research.md)
- [x] T016 [US2] Update all SKILL.md resource references to owner-copy package-relative paths
- [x] T017 [US2] Update install.sh to link per-skill trees and drop the shared symlink
- [x] T018 [US2] Run portability gate: zero refs to skills/shared plus full /tmp validation green

## Phase 5: US3 - Regression evals for deterministic skills

**Story goal**: eval prompts catch regressions before commit.
**Independent test**: evals run on an empty scratch repo reproduce expected files and exit codes.

- [x] T019 [US3] Write eval prompts with expected files and codes in specs/001-skill-standards/evals.md
- [x] T020 [US3] Run evals on scratch repo and record results in specs/001-skill-standards/evals.md

## Final Phase: Polish

- [x] T021 Re-run full /tmp validation and sign off checklist in specs/001-skill-standards/checklists/requirements.md

## Dependencies

US1 → US2 (audit first, migration second) → US3 (evals run against migrated tree). US1 alone is the MVP: audited skills with fixed descriptions. Phase 1 → Phase 2 → Phases 3–5 sequential; T005–T010 parallel.

## Parallel Execution per Story

- US1: T005, T006, T007, T008, T009, T010 in parallel (different files).
- US2: T012, T013, T014 in parallel (different destinations); T015–T018 sequential.
- US3: T019 then T020 sequential.

## Implementation Strategy

MVP first: US1 audit plus description fixes. Then US2 migration. Then US3 evals. Each story independently testable and shippable.
