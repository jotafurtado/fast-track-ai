# Agent Behavior Evals Specification

## Purpose

Provides optional real-agent evaluation of fast-track-ai workflow behavior in disposable repositories without weakening the deterministic maintainer suite.

## Requirements

### Requirement: Agent evaluations are explicit and isolated
The package SHALL provide an explicit maintainer-only agent-eval entry point that creates a fresh disposable target repository for each scenario. It SHALL not run from `evals/run-evals.sh all`, require an installed consumer skill or command, or read the repository's historical `fast-track-ai/` tree as scenario input.

#### Scenario: Deterministic suite remains independent
- **WHEN** a maintainer runs `bash evals/run-evals.sh all` without Kiro credentials or a Kiro CLI
- **THEN** the deterministic suite completes without attempting an agent evaluation

#### Scenario: Agent scenario receives a disposable target
- **WHEN** a maintainer runs one agent-eval scenario
- **THEN** the scenario uses a newly created temporary target repository and removes it unless diagnostics are explicitly retained

### Requirement: Kiro adapter reports machine-verifiable session evidence
The agent-eval entry point SHALL use a Kiro-specific adapter that accepts a target workspace and ordered user turns, including continuation and revision inputs. For every executed turn, it SHALL emit a machine-readable result containing the turn outcome, an ordered checkpoint identifier, and any available action events. It SHALL not use prose in an agent response as a passing oracle.

#### Scenario: Revision turn is represented as input
- **WHEN** a scenario supplies a spec revision instead of `.` after the spec summary
- **THEN** the adapter executes that revision as the next user turn and records a result for that turn

#### Scenario: Action-event support is unavailable
- **WHEN** the installed Kiro CLI cannot provide reliable action events required by an ordering assertion
- **THEN** the scenario records an inconclusive result with the limitation and does not claim that the ordering was verified

### Requirement: Agent scenarios evaluate durable workflow transitions
The suite SHALL evaluate revision, spec approval, failed validation, material planning change, and implementation resume scenarios using filesystem checkpoints, method artifacts, frontmatter, task state, command outcomes, and available action events. Each scenario SHALL assert only durable state or recorded actions and SHALL not assert the wording of an agent response.

#### Scenario: Revision does not begin implementation
- **WHEN** the user supplies a revision after a spec summary
- **THEN** `spec.md` and `tasks.md` remain `draft`, no product edit is present at that checkpoint, and no task is recorded complete

#### Scenario: Spec approval precedes implementation
- **WHEN** the user supplies `.` after a spec summary
- **THEN** `spec.md` and `tasks.md` become `approved` before any implementation action for which reliable ordered evidence is available

#### Scenario: Failed validation prevents completion
- **WHEN** a fixture task's Validate command fails
- **THEN** its task remains open, no dependent task starts, and the track is neither offered as complete nor marked `shipped`

#### Scenario: Material planning change pauses execution
- **WHEN** a material decision changes approved scope, Files, Accept criteria, tasks, or group dependencies during implementation
- **THEN** both planning artifacts return to `draft` and execution waits for a renewed approval

#### Scenario: Resume starts at the first open task
- **WHEN** implementation starts on a track with earlier tasks checked and a later task open
- **THEN** the agent starts from the first open task in dependency order and does not re-run unchanged checked-task validation

### Requirement: Session compatibility and cost limits are explicit
Before relying on multi-turn resume scenarios, the suite SHALL establish whether the installed Kiro CLI can resume a headless session and submit a subsequent user prompt. The runner SHALL use configured model and effort settings, a bounded scenario timeout, local-only fixtures, and an explicit non-blocking result classification for unavailable credentials, unsupported session continuation, timeout, or agent inconclusiveness.

#### Scenario: Resume continuation is unsupported
- **WHEN** the Kiro compatibility check cannot resume a headless session with a subsequent prompt
- **THEN** dependent multi-turn scenarios report `inconclusive` with that reason and the runner returns a result that does not affect the deterministic suite

#### Scenario: Credentials are unavailable
- **WHEN** the Kiro adapter lacks the required local authentication or executable
- **THEN** the agent-eval invocation reports the prerequisite and exits without running a scenario or changing the deterministic suite result
