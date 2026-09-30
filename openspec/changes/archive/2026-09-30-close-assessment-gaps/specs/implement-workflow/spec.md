## ADDED Requirements

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
