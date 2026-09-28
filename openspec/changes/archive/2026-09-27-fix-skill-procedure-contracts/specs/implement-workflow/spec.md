# Spec Delta

## Purpose

Defines how the implement skill executes an approved track: durable task completion, which files it may touch, harness-neutral execution, acceptance evidence before ship, and the review-fix-revalidate loop.

## ADDED Requirements

### Requirement: Task completion is persisted when validated
The implement skill SHALL set a task line to `- [x] ` in `tasks.md` as soon as that task's Validate passes, before starting the next dependent group. A harness task tracker SHALL NOT replace this durable record. The completion gate SHALL run only after every task line is persisted as done.

#### Scenario: Gate sees persisted state
- **WHEN** all tasks have passed Validate and the implement skill runs the completion gate
- **THEN** every task line in `tasks.md` is already `- [x] ` and the gate does not fail on open tasks

#### Scenario: Failed Validate keeps the box open
- **WHEN** a task's Validate fails
- **THEN** its line stays `- [ ] ` and the skill does not report that task as complete

### Requirement: Product files and method files are distinct
The implement skill SHALL restrict product edits to files named in the spec Files and each task's Files. It SHALL stop and ask before touching any other product file. Method-administration files SHALL change only through these transitions:
- task checkboxes in `tasks.md`
- files under the track's `assets/`
- `fast-track-ai/INDEX.md` through the owner index script
- intent `status: shipped` after the ship confirmation
- new ADRs under `fast-track-ai/decisions/`
- returning `spec.md` and `tasks.md` to `draft` on a material change

#### Scenario: Unlisted product file is needed
- **WHEN** a task requires editing a source file absent from every Files list
- **THEN** the skill stops and asks before editing it

#### Scenario: Administrative writes proceed
- **WHEN** a task passes Validate
- **THEN** the skill updates its checkbox without asking, because `tasks.md` checkboxes are a named administrative transition

### Requirement: Execution does not depend on a specific harness
The implement skill SHALL track tasks in the task tracker the harness provides, if any, without naming a harness-specific tool. When the harness cannot run subagents, it SHALL run the tasks of each group one at a time and keep group dependency order. Validation SHALL use each task's Validate and the checks the target project actually provides. It SHALL NOT assume that a typechecker or a test suite exists.

#### Scenario: No subagents available
- **WHEN** the harness offers no subagent mechanism
- **THEN** the skill runs every task sequentially in dependency order and still validates and marks each one

#### Scenario: Project without tests
- **WHEN** the target project has no test suite
- **THEN** the skill runs each task's Validate and reports that no suite exists instead of inventing a test command

### Requirement: Acceptance is demonstrated before ship is offered
Before presenting the implement summary, the skill SHALL write `fast-track-ai/tracks/<track>/assets/acceptance.md`. It SHALL contain one row for the spec Outcome and one row per phase `Accept:` line, with these columns: criterion, check executed, observed result, and `met` or `pending`. Each check SHALL be executed against the final state of the change. The summary's acceptance bullet SHALL state the met count and the file path. The skill SHALL NOT present `. para ship (marca a track como concluida)` while any row is `pending`. It SHALL instead report the pending criteria and continue fixing or ask the user how to proceed.

#### Scenario: All criteria met
- **WHEN** every phase Accept and the Outcome have an executed check with a satisfying observed result
- **THEN** `assets/acceptance.md` marks every row `met` and the summary ends with the ship next-step line

#### Scenario: Passing tasks with an unmet criterion
- **WHEN** every task passed Validate but one phase Accept has no satisfying evidence
- **THEN** that row is `pending`, the summary names it, and no ship next-step line is shown

### Requirement: Review findings loop until blocking findings are resolved
After the completion gate passes, the skill SHALL review the change with severities `[blocking]`, `[important]`, `[nit]`, and `[suggestion]`. For each `[blocking]` finding it SHALL:
1. Fix the finding.
2. Re-run the Validate of affected tasks and the acceptance checks of affected phases.
3. Re-run the completion gate.
4. Review the changed code again.

The loop SHALL repeat until no `[blocking]` finding remains. Each `[important]` finding SHALL be fixed or listed as open in the review bullet. The evidence in the summary and in `assets/acceptance.md` SHALL reflect the state after the last fix.

#### Scenario: Review forces a fix
- **WHEN** review reports a `[blocking]` finding and the skill fixes it
- **THEN** the affected Validate commands, acceptance checks, and gate run again before the summary, and the summary reports those later results

#### Scenario: Blocking finding cannot be fixed within scope
- **WHEN** fixing a `[blocking]` finding requires an unlisted file or an out-of-scope change
- **THEN** the skill stops, reports the finding, and asks instead of offering ship
