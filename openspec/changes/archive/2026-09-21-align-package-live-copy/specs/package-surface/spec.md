# Spec Delta

## Purpose

Governs live package copy, installer command links, INDEX terminal state for completed tracks, and eval coverage so published skills match the continuous-flow description without leftover Spec Kit or unused lifecycle language.

## ADDED Requirements

### Requirement: Live package copy does not mention Spec Kit
Live skills, command wrappers, templates, AGENTS house rules, the managed AGENTS block, the live evals table, and the skill-package contract SHALL describe the current cycle without naming Spec Kit, Speckit, speckit, or `.specify`. Init SHALL still omit `specs/` and `.specify/` from the created tree; that omission is verified by evals, not by user-facing copy.

#### Scenario: Spec template has no Spec Kit sentence
- **WHEN** an agent copies `skills/fast-track-ai-spec/assets/spec.md` into a new track
- **THEN** the template does not contain "Spec Kit" or equivalent

#### Scenario: Init skill does not advertise Spec Kit absence
- **WHEN** an agent reads the init skill or init command
- **THEN** those files do not mention Spec Kit, speckit, or `.specify`

#### Scenario: Init still creates only the method tree
- **WHEN** init runs on an empty target
- **THEN** the target has no `specs/` directory and no `.specify/` tree, and the eval that asserts that fact does not require the skill text to name those paths

### Requirement: Explicit actions are first-class exits
The managed AGENTS block SHALL NOT say that every request must become `intent.md` with no exceptions. Assess, research, and handoff SHALL remain valid stops after their artifact and index regeneration, without drafting an intent.

#### Scenario: Assessment request does not require an intent
- **WHEN** the user asks only to assess the project
- **THEN** the assess skill writes the assessment, regenerates INDEX, and stops without creating a track intent

#### Scenario: Managed block names the exits
- **WHEN** an agent reads the managed AGENTS block
- **THEN** it can tell that research, assess, and handoff may complete without an intent, and that implementation still requires approved `spec.md` and `tasks.md`

### Requirement: Intent active is not a live written status
Live skills, command wrappers, and the managed AGENTS block SHALL NOT instruct the agent to set or require intent `status: active`. New intents SHALL be written `draft` and leave `draft` only for `shipped`, `dropped`, or `superseded`. The index MAY continue to accept `active` as a valid historical value.

#### Scenario: AGENTS does not say tracks leave active
- **WHEN** an agent reads the managed AGENTS block
- **THEN** it does not contain a rule that a track leaves `active` only by maintainer command

#### Scenario: Default eval fixtures use draft
- **WHEN** the live eval runner constructs a passing gate fixture
- **THEN** the intent status is `draft`, not `active`, unless that fixture is specifically proving the index still accepts `active`

### Requirement: Track 010 is shipped
The intent `fast-track-ai/tracks/010-approval-ask-not-gate-fail/intent.md` SHALL have `status: shipped`. Generated `INDEX.md` SHALL list that track as shipped. The track's existing spec and tasks files SHALL NOT be rewritten.

#### Scenario: Index lists 010 shipped
- **WHEN** the index generator runs after this change
- **THEN** the tracks table contains `| 010-approval-ask-not-gate-fail | shipped |`

#### Scenario: 010 historical spec stays
- **WHEN** the change is applied
- **THEN** `010` `spec.md` and `tasks.md` remain byte-identical to their pre-change content except for any index-unrelated files that this change does not touch

### Requirement: Live evals cover the continuous-flow protocol
The executable eval runner SHALL include a selector that fails unless the published intent, spec, and implement skills plus the tasks template contain the continuous-flow protocol strings: `. para continuar com a spec`, `. para implementar`, `. para ship`, `Track concluida. Nenhuma implementacao necessaria.`, `## Group`, and `(depends:`.

#### Scenario: Flow selector passes on the live package
- **WHEN** `run-evals.sh flow` runs against the repository
- **THEN** it exits 0 after asserting those strings in the owner skills and tasks template

#### Scenario: Missing next-step line fails
- **WHEN** the intent skill no longer contains `. para continuar com a spec`
- **THEN** the flow selector exits non-zero
