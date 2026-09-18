---
status: approved
---

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

## Phase 6: Convergence

- [x] T022 Amend the constitution and impact report to replace the mandatory `shared` link with the approved owner-copy layout per Constitution III and FR-005 (contradicts)
  - Files: `.specify/memory/constitution.md`
  - Validate: `bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh constitution`
- [x] T023 Harden the gate and approval contract so draft intents, unapproved artifacts, and open full-cycle tasks cannot pass per FR-007 and Constitution IV (contradicts)
  - Files: `.specify/templates/plan-template.md`, `.specify/templates/tasks-template.md`, `skills/dot-ai-init/assets/AGENTS-snippet.md`, `skills/dot-ai-plan/SKILL.md`, `skills/dot-ai-plan/assets/plan.md`, `skills/dot-ai-plan/assets/tasks.md`, `skills/dot-ai-plan/scripts/sdd-gate.sh`, `skills/dot-ai-implement/SKILL.md`
  - Validate: `bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh approval`
- [x] T024 Fix custom Claude mirrors to resolve from the configured agents directory and validate both harness layouts per Constitution III and the install contract (contradicts)
  - Files: `install.sh`
  - Validate: `bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh install`
- [x] T025 Replace aggregate audit claims with one evidence-backed verdict per rule and skill, resolve every failure, and re-audit per FR-001, FR-008, US1/AC1-2, and SC-001/002 (partial)
  - Files: `dot-ai/tracks/001-skill-standards/spec/audit.md`, `dot-ai/tracks/001-skill-standards/spec/checklists/requirements.md`
  - Validate: `bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh audit`
- [x] T026 Reference every bundled script and asset from its owner skill with explicit usage guidance or remove the unused resource, including `dot-ai-specify.sh` and `assets/decisions.md`, per FR-003 (partial)
  - Files: `skills/dot-ai-init/SKILL.md`, `skills/dot-ai-intent/SKILL.md`, `skills/dot-ai-plan/SKILL.md`
  - Validate: `bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh resources`
- [x] T027 Repair the `dot-ai-specify` bridge to require an approved intent, emit the correct OMP command, route output to the canonical track spec, and add `/tmp` verification per FR-004 and the plan script-ownership decision (partial)
  - Files: `skills/dot-ai-intent/scripts/dot-ai-specify.sh`
  - Validate: `bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh specify`
- [x] T028 Add an executable deterministic eval runner for init, index, gate, wrapper, install, audit, resource, constitution, and contract behavior without masked failures per FR-006, SC-004, and US3/AC1-2 (partial)
  - Files: `AGENTS.md`, `dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`, `dot-ai/tracks/001-skill-standards/spec/evals.md`
  - Validate: `bash -n dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh && bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh self`
- [x] T029 Reconcile the package path contract with the sibling owner-copy paths that installed skills actually use per SC-003 and the plan structure decision (contradicts)
  - Files: `dot-ai/tracks/001-skill-standards/spec/contracts/skill-package.md`
  - Validate: `bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh contract`
