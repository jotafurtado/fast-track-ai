# Spec Delta

## ADDED Requirements

### Requirement: Portuguese continuation copy is the user-facing protocol
The required next-step and non-implementation-exit lines SHALL be the Portuguese strings already named by this capability. Other user-facing package prose MAY stay English. Those named Portuguese strings SHALL NOT be treated as a house-rule violation.

#### Scenario: House rule allows the named strings
- **WHEN** an agent reads AGENTS house rules
- **THEN** English remains the default for commands, skills, and error messages, with an explicit exception for the continuous-flow next-step and exit lines

#### Scenario: Next-step lines stay Portuguese
- **WHEN** intent, spec, or implement presents a post-phase summary
- **THEN** the next-step line is `. para continuar com a spec`, `. para implementar`, or `. para ship (marca a track como concluida)` respectively, not an English rewrite of those strings

## MODIFIED Requirements

### Requirement: Intent status stays draft until shipped
The `.` continuation SHALL NOT change the intent's `status` field. The intent stays `draft` through spec and implement. Only the implement skill's ship confirmation sets `status: shipped`. Live skills SHALL NOT write `status: active`. This preserves the existing rule that intent approval is not required before `spec.md`.

#### Scenario: Dot does not approve intent
- **WHEN** the user sends `.` after the intent summary
- **THEN** `intent.md` retains `status: draft` and the spec skill is invoked

#### Scenario: Ship sets shipped
- **WHEN** the user confirms ship after implementation
- **THEN** the implement skill sets `intent.md` to `status: shipped`

#### Scenario: Live skills never write active
- **WHEN** intent, spec, or implement updates intent status
- **THEN** the written value is `draft`, `shipped`, `dropped`, or `superseded`, never `active`
