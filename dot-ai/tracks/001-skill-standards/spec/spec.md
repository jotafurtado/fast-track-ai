# Feature Specification: Skill Standards Compliance

**Feature Branch**: `001-skill-standards`

**Created**: 2026-09-15

**Status**: Draft

**Input**: User description: "usando a skill /skill:skill-creator vamos montar uma especificação para aplicar as melhores práticas as nossas skills de acordo com os padrões."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Skills pass a standards audit (Priority: P1)

As the method maintainer, I run a standards checklist derived from the official skill-creator guide against every `skills/dot-ai-*` skill, so that agents trigger the right skill and follow it reliably.

**Why this priority**: Untriggered or misfollowed skills silently break the dot-ai flow (the intent-before-plan lock was missed exactly this way). Standards compliance is the cheapest prevention.

**Independent Test**: Apply the checklist to the 6 existing skills and record pass/fail per item; every gap becomes a tracked fix.

**Acceptance Scenarios**:

1. **Given** the 6 dot-ai skills, **When** the audit runs, **Then** each skill gets a pass/fail row per checklist item with evidence quotes.
2. **Given** a failing item, **When** the fix lands, **Then** a re-audit shows pass without breaking the `/tmp` validation.

---

### User Story 2 - Shared layout decision recorded (Priority: P2)

As the method maintainer, I get an explicit decision on the `skills/shared/` cross-skill layout versus the skill-creator per-skill anatomy (`scripts/`, `references/`, `assets/` inside each skill), so the deviation is either removed or permanently justified.

**Why this priority**: The shared layout is load-bearing for portability but contradicts the reference anatomy; an undocumented deviation invites future "fixes" that break installs.

**Independent Test**: The decision is recorded in one place and the tree either matches per-skill anatomy or carries a justification pointer.

**Acceptance Scenarios**:

1. **Given** the layout question, **When** decided, **Then** `skills/` either nests resources per skill or documents why `shared/` stays.
2. **Given** the decision, **When** a new skill is added later, **Then** its author finds where resources belong without asking.

---

### User Story 3 - Regression evals for deterministic skills (Priority: P3)

As the method maintainer, I have lightweight eval prompts for the deterministic skills (init, index, gate flows), so regressions in triggering and file outputs are caught before they reach a live project.

**Why this priority**: Skills with objectively verifiable outputs benefit most from test cases per the skill-creator guide; ours produce files and exit codes, which are cheap to assert.

**Independent Test**: Each eval prompt runs with-skill and produces the expected files and exit codes on a scratch repo.

**Acceptance Scenarios**:

1. **Given** eval prompts for init/index/gate, **When** executed on an empty scratch repo, **Then** outputs match the expected tree, INDEX content, and FAIL/PASS states.
2. **Given** a future skill edit, **When** evals re-run, **Then** regressions are detected before commit.

---

### Edge Cases

- A skill that legitimately needs no `assets/` or `references/` keeps a clean directory; absence MUST be allowed, not penalized.
- The `via: rapida | completa` enum and other frozen identifiers are method constraints, not skill-creator violations; the audit MUST NOT flag them.
- Third-party base skills (`research`, `handoff`, `grilling`) are out of scope; only the `dot-ai-*` wrappers are audited.
## Requirements *(mandatory)*

### Functional Requirements
- **FR-001**: Audit MUST cover all 6 `skills/dot-ai-*` skills plus `skills/shared/` against a checklist derived from the skill-creator guide (frontmatter, anatomy, progressive disclosure, triggering, writing patterns).
- **FR-002**: Skill descriptions MUST follow the skill-creator "pushy" pattern: state what the skill does AND the exact contexts that trigger it, including user phrases that should trigger it even when the skill is not named. This overrides the house terse style for descriptions only.
- **FR-003**: SKILL.md bodies MUST stay under 500 lines and reference bundled files with explicit read guidance.
- **FR-004**: Scripts referenced by skills MUST execute without loading into context and MUST be covered by the existing `/tmp` validation.
- **FR-005**: Resources MUST live per skill (`scripts/`, `references/`, `assets/` inside each skill). Truly shared scripts MUST have one declared owner skill; other skills reference the owner copy, never duplicate it. Owner assignment per script happens in plan. The `shared/` directory and symlink are removed, `install.sh` links per-skill trees.
- **FR-006**: Deterministic skills (init, index, gate paths) MUST gain lightweight eval prompts with expected files and exit codes.
- **FR-007**: Method locks expressed as MUSTs (intent-before-plan, no-loose-files) MUST be preserved; the skill-creator "explain why over MUSTs" guidance applies to rationale text, not to the locks themselves.
- **FR-008**: Audit evidence MUST quote the offending or passing skill text per item; bare pass/fail without quotes is rejected.

### Key Entities

- **Skill**: a `skills/dot-ai-*` directory with SKILL.md and optional bundled resources; attributes: name, description, body steps, resource refs.
- **Checklist item**: one skill-creator rule; attributes: rule text, pass/fail per skill, evidence quote.
- **Eval prompt**: a realistic user utterance plus expected files and exit codes on a scratch repo.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 6 skills audited with evidence quotes in under one working session.
- **SC-002**: Zero unresolved checklist failures remain, or each is tracked as a follow-up task with an owner.
- **SC-003**: A new skill author can place every new file correctly on the first attempt by reading the recorded layout decision.
- **SC-004**: Re-running the eval prompts after any skill edit reproduces the same pass/fail within the session, with no manual interpretation step.

## Assumptions

- The skill-creator guide version read from `anthropics/skills` main branch on 2026-09-15 is the reference standard.
- House rules (English prose, terse style, surgical changes) stay in force unless a clarification answer overrides them for a specific item.
- `commands/` thin wrappers follow whatever description style is decided in FR-002.
- No live target project is touched; all verification happens on scratch repos.

## Clarifications

### Session 2026-09-15

- Q: Which skill should own the shared `dot-ai-index` script after the per-skill migration? → A: Single owner skill keeps the canonical copy, others reference it (owner assignment per script happens in plan).
