# Spec Delta

## ADDED Requirements

### Requirement: Tasks declare parallelism groups and dependency edges
The `tasks.md` artifact SHALL organize tasks into named parallel groups. Tasks within the same group have no mutual dependency and MAY execute concurrently. Groups SHALL declare dependencies on other groups using a `depends:` annotation. The implement skill SHALL read these annotations to determine which tasks to parallelize and which to serialize.

#### Scenario: Independent tasks are grouped
- **WHEN** the spec skill identifies tasks that touch disjoint files and have no data dependency
- **THEN** it places them in the same parallel group

#### Scenario: Dependent group waits for predecessor
- **WHEN** a parallel group declares `depends: A`
- **THEN** the implement skill starts that group only after all tasks in group A are complete

#### Scenario: Single-task group
- **WHEN** a group contains exactly one task
- **THEN** it is valid and the implement skill treats it as a serial step

### Requirement: Implement selects efficient agents from the harness
The implement skill SHALL instruct the harness to use an execution-class agent for task subagents and reserve the session-class model for planning, integration, and review. The skill SHALL NOT hardcode model names or provider-specific identifiers. Agent selection defers entirely to the harness runtime.

#### Scenario: Harness provides execution agent
- **WHEN** the implement skill spawns a subagent for a task
- **THEN** it requests an efficient execution-class agent from the harness rather than using the session model

#### Scenario: Planning stays on session model
- **WHEN** the implement skill performs integration, review, or cross-task coordination
- **THEN** it uses the session model, not the execution-class agent
