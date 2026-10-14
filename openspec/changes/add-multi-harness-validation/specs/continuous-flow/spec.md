# Spec Delta

## MODIFIED Requirements

### Requirement: Dot continuation chains skills without commands
The method SHALL accept `.` (a single period) as user input after a post-phase summary to approve the current artifact and invoke the next skill in the chain. Any input that is not `.`, an affirmative synonym ("sim", "pode continuar", "yes", "continue"), or empty SHALL be treated as a new instruction addressed to the current skill before proceeding. After a spec summary, the approval action SHALL set both `spec.md` and `tasks.md` to `status: approved` and complete before implementation or any product edit starts. That action SHALL change only the two approval artifacts and SHALL NOT mix approval with product edits, including in a multi-file action. It SHALL NOT prescribe a particular editing tool.

#### Scenario: User sends dot after intent summary
- **WHEN** the intent skill presents its post-phase summary and the user replies `.`
- **THEN** the intent is finalized, the spec skill is invoked for the same track, and the user is not asked to type a command name

#### Scenario: User sends affirmative synonym after spec summary
- **WHEN** the spec skill presents its post-phase summary and the user replies "sim"
- **THEN** `spec.md` and `tasks.md` are set to `status: approved` in a completed approval-only action and the implement skill is then invoked for the same track

#### Scenario: User sends different input after summary
- **WHEN** the user sends different input after the summary, such as "muda a fase 2 para usar Redis"
- **THEN** the spec skill processes the instruction and presents an updated summary without advancing to implement

#### Scenario: Multi-file edit contains approval and product changes
- **WHEN** the agent chooses a multi-file editing operation after spec approval
- **THEN** it may approve both artifacts together, but completes that approval-only action before issuing a product edit
