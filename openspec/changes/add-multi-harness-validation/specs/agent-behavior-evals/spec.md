# Spec Delta

## MODIFIED Requirements

### Requirement: Agent evaluations are explicit and isolated
The package SHALL provide an explicit maintainer-only agent-eval entry point that creates a fresh disposable target repository for each scenario. It SHALL not run from `evals/run-evals.sh all`, require an installed consumer skill or command, or read the repository's historical `fast-track-ai/` tree as scenario input. Each target SHALL expose the package under the selected harness's native skill-discovery location. Results and retained diagnostics SHALL identify the harness and SHALL not overwrite evidence from another harness.

#### Scenario: Deterministic suite remains independent
- **WHEN** a maintainer runs `bash evals/run-evals.sh all` without Kiro, Claude Code, or Codex credentials or executables
- **THEN** the deterministic suite completes without attempting an authenticated agent evaluation

#### Scenario: Agent scenario receives a disposable target
- **WHEN** a maintainer runs one agent-eval scenario
- **THEN** the scenario uses a newly created temporary target repository and removes it on pass unless diagnostics are explicitly retained, retaining non-passing diagnostics

#### Scenario: Harness configuration is not product work
- **WHEN** a scenario compares checkpoints or evaluates product edit actions
- **THEN** its installed harness configuration and skill directories are excluded from product work while actual fixture product paths remain observable

### Requirement: Session compatibility and cost limits are explicit
Before relying on multi-turn resume scenarios, the suite SHALL establish whether the selected Kiro, Claude Code, or Codex CLI can resume a headless session and submit a subsequent user prompt. The runner SHALL use configured model and effort settings, a bounded per-turn timeout, local-only fixtures, and an explicit result classification for unavailable credentials, unsupported session continuation, timeout, or agent inconclusiveness. Session compatibility evidence SHALL be scoped to the selected harness and invocation. Agent-eval results SHALL remain independent of the deterministic suite.

#### Scenario: Resume continuation is unsupported
- **WHEN** the selected harness's compatibility check cannot resume a headless session with a subsequent prompt
- **THEN** dependent multi-turn scenarios report `inconclusive` with that reason and the runner returns a result that does not affect the deterministic suite

#### Scenario: Credentials are unavailable
- **WHEN** the selected adapter lacks the required local authentication or executable
- **THEN** the agent-eval invocation reports the prerequisite without executing that harness's scenarios or changing the deterministic suite result

#### Scenario: Model and effort are configured
- **WHEN** a maintainer supplies a model or effort for the selected harness
- **THEN** the run uses the requested supported setting or reports an unsupported setting explicitly rather than silently substituting another

## ADDED Requirements

### Requirement: Harness selection preserves shared workflow assertions
The runner SHALL accept explicit selection of `kiro`, `claude`, or `codex`, defaulting to `kiro` when selection is omitted. Every harness SHALL support the same `compat`, `revision`, `approval`, `failed-validation`, `material-change`, `resume`, and `all` selectors with shared scenario semantics and assertions. Unknown harnesses SHALL be rejected before starting an agent.

#### Scenario: Existing Kiro invocation
- **WHEN** a maintainer invokes `run-agent-evals.sh all` without a harness option
- **THEN** the runner selects Kiro and preserves the existing scenario and exit-code behavior

#### Scenario: Claude Code and Codex selection
- **WHEN** a maintainer selects Claude Code or Codex with `all`
- **THEN** the runner evaluates all six existing selectors for that harness and identifies the harness in results

### Requirement: Additional adapters report machine-verifiable evidence
Claude Code and Codex adapters SHALL accept a disposable workspace and ordered user turns and emit per-turn outcomes, native session identifiers, filesystem checkpoints, raw events, and normalized ordered action evidence compatible with the shared workflow assertions. Reliably correlated native command results or trusted deterministic command-boundary instrumentation MAY supplement native action evidence, with the evidence source and coverage limitations recorded explicitly. Agent response prose SHALL NOT serve as a passing oracle. Missing or incomplete evidence SHALL NOT prove absence of an action or its ordering. Concurrent or batched edits SHALL NOT be assigned an invented sequential order. Polling, a shell call's final exit code alone, or uncorrelated snapshots SHALL NOT prove per-operation success or order within that call.

#### Scenario: Approval ordering is observable
- **WHEN** native events reliably show separate approval writes before the first product edit
- **THEN** the shared approval assertion can pass using normalized evidence

#### Scenario: Ordering or action coverage is unavailable
- **WHEN** required native action evidence is incomplete, ambiguous, or absent, including mutations performed through shell commands without reliable mutation evidence
- **THEN** the affected assertion reports `inconclusive` instead of passing from final file state alone

#### Scenario: Resumed conversation retains its identity
- **WHEN** a second turn resumes the native session from the first turn
- **THEN** compatibility uses the native session identifier and the token supplied only in the first turn, not a replayed synthetic conversation

#### Scenario: Shell operations have observed execution boundaries
- **WHEN** trusted instrumentation records file state at actual synchronous command boundaries and reliably correlates those boundaries with the native tool call
- **THEN** the ordering assertion may use the proven boundaries while keeping opaque, concurrent, batched, or uncovered operations inconclusive

#### Scenario: Instrumentation observes only the whole call
- **WHEN** approval and product changes occur within one shell call and evidence shows only the state before and after that call
- **THEN** approval order remains inconclusive even if the final files are correct and the call exited zero

### Requirement: Readiness requires passing evidence for every selected surface
The maintainer documentation SHALL record generic installation validation and all six real-agent selectors for Kiro, Claude Code, and Codex, identifying package revision or working-tree state, run date, CLI version, model and effort when observable, and diagnostic evidence. Package readiness across these surfaces SHALL require every required result to be `pass`; `fail`, `inconclusive`, and `prerequisite-unavailable` SHALL remain explicit blockers even when the optional runner exits zero.

#### Scenario: Runner exits zero with unavailable credentials
- **WHEN** a harness run reports `prerequisite-unavailable` and exits zero
- **THEN** the readiness record marks that harness as unvalidated, not approved

#### Scenario: Complete matrix passes
- **WHEN** generic installation validation and every selector on all three harnesses have passing evidence for the evaluated package state
- **THEN** the record can identify that package state as ready across those surfaces
