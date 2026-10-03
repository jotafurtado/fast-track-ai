# Spec Delta

## ADDED Requirements

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
