# Implement Workflow

## Purpose

Defines how the implement skill executes an approved track: durable task completion, which files it may touch, harness-neutral execution, acceptance evidence before ship, and the review-fix-revalidate loop.

## Requirements

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

### Requirement: Delegation is proportional to task size
When the harness offers subagents, the implement skill SHALL delegate a task to a subagent only when the task warrants its own context: more than one file, or a Validate that runs beyond a single quick check. It SHALL run trivial tasks directly in the main agent. It SHALL NOT run project-wide checks, such as a full test suite, a build, or a typechecker, while subagents of the current group are still editing. It SHALL run those checks after every task in the group has returned.

#### Scenario: Trivial task in a parallel group
- **WHEN** a group holds a one-line edit to a single file with a grep Validate
- **THEN** the main agent performs that task directly without spawning a subagent

#### Scenario: Global check waits for the group
- **WHEN** two subagents of one group are still editing files
- **THEN** the skill does not start the project test suite until both have returned

### Requirement: Resume continues from durable task state
When implementation resumes on a track whose `tasks.md` already has checked tasks, the implement skill SHALL treat each `- [x]` task as validated. It SHALL continue from the first open task in dependency order. It SHALL rerun a checked task's Validate only when a later change touches that task's Files.

#### Scenario: Session resumes mid-track
- **WHEN** a new session invokes implement on a track with groups A checked and B open
- **THEN** the skill starts group B without rerunning group A's Validate commands

#### Scenario: Later change touches a checked task's files
- **WHEN** a fix in group B edits a file listed on a checked group A task
- **THEN** the skill reruns that task's Validate before offering ship

### Requirement: Assumption divergence stops before the solution changes
The implement skill SHALL treat the intent's `Stated by the user` facts as given. It SHALL verify an `Unverified assumptions` entry before a task depends on it. When a stated fact or an assumption proves false, the skill SHALL record the divergence in the track's `assets/`. It SHALL then stop and report the divergence to the user before changing the approach, and SHALL NOT adapt the solution on its own.

#### Scenario: Unverified assumption proves false
- **WHEN** a task depends on the assumption that a module has no other callers and a search finds callers
- **THEN** the skill records the divergence under the track's `assets/`, stops, and reports it before editing the module

#### Scenario: Stated fact contradicts the repository
- **WHEN** the user stated that an endpoint exists and the repository has no such endpoint
- **THEN** the skill reports the contradiction and waits for the user instead of creating the endpoint

### Requirement: Review procedure is self-contained
The implement skill SHALL carry the complete review procedure: principles, phases, severities, and the fix loop. It SHALL state that `fast-track-ai/refs/code-review-skill` names only the provenance of the approach. It SHALL state that the consuming project does not need that ref, and that the review runs the same way whether or not the ref exists.

#### Scenario: Consumer without the ref
- **WHEN** implement reaches review in a target repository with no `fast-track-ai/refs/code-review-skill`
- **THEN** the skill runs the full review from its own text and does not stop, fetch, or create the ref

#### Scenario: Skill text marks provenance
- **WHEN** the implement skill is inspected
- **THEN** it names `fast-track-ai/refs/code-review-skill` as provenance only and states that the consuming project does not need it

### Requirement: Dependent groups start only after their prerequisites pass
The implement skill SHALL NOT start a task in a group that declares `(depends: <group>)` until every task in each group it depends on has passed its Validate and is recorded as `- [x]` in `tasks.md`. Until then, the skill SHALL NOT create, edit, or delete any file listed in that dependent task's Files, including to stage work or to collect evidence. When a prerequisite task's Validate fails, the skill SHALL stop before every dependent group and report the failure.

#### Scenario: Prerequisite Validate fails
- **WHEN** a Group A task's Validate fails and Group B declares `(depends: A)`
- **THEN** no file in Group B's task Files is created or edited, every Group B task stays `- [ ]`, and the skill reports the failure instead of continuing

#### Scenario: Prerequisite passes
- **WHEN** every Group A task has passed Validate and is checked
- **THEN** the skill may start the Group B tasks

#### Scenario: Skill text states the rule
- **WHEN** the implement skill is inspected
- **THEN** it states that a dependent group's Files are not created or edited before every task of the groups it depends on has passed Validate and is checked
