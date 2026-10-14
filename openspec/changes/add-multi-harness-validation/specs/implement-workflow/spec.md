# Spec Delta

## MODIFIED Requirements

### Requirement: Resume continues from durable task state
When implementation resumes on a track whose `tasks.md` already has checked tasks, the implement skill SHALL treat each `- [x]` task as validated. It SHALL continue from the first open task in dependency order. It SHALL rerun a checked task's Validate only when a later change touches that task's Files. This rule SHALL also govern task-scoped project checks selected during implementation or final validation; a task's Validate SHALL remain task-scoped even when it is the project's only check script. The skill SHALL still execute the spec's Outcome and phase acceptance checks against the final state.

#### Scenario: Session resumes mid-track
- **WHEN** a new session invokes implement on a track with groups A checked and B open
- **THEN** the skill starts group B without rerunning group A's Validate commands

#### Scenario: Later change touches a checked task's files
- **WHEN** a fix in group B edits a file listed on a checked group A task
- **THEN** the skill reruns that task's Validate before offering ship

#### Scenario: Final project validation includes a task-scoped script
- **WHEN** final validation discovers a check script that is the Validate of a task checked before resume and no later change touched that task's Files
- **THEN** the skill leaves that task-scoped script unexecuted and still runs the spec's final acceptance checks
