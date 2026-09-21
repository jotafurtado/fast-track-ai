# Continuous Flow

## Purpose

Governs the continuous flow protocol that chains fast-track-ai skills with minimal user ceremony, including the dot-continuation shorthand, post-phase summaries, autonomous artifact generation during intent, and non-implementation exit paths.

## Requirements

### Requirement: Dot continuation chains skills without commands
The method SHALL accept `.` (a single period) as user input after a post-phase summary to approve the current artifact and invoke the next skill in the chain. Any input that is not `.`, an affirmative synonym ("sim", "pode continuar", "yes", "continue"), or empty SHALL be treated as a new instruction addressed to the current skill before proceeding.

#### Scenario: User sends dot after intent summary
- **WHEN** the intent skill presents its post-phase summary and the user replies `.`
- **THEN** the intent is finalized, the spec skill is invoked for the same track, and the user is not asked to type a command name

#### Scenario: User sends affirmative synonym after spec summary
- **WHEN** the spec skill presents its post-phase summary and the user replies "sim"
- **THEN** `spec.md` and `tasks.md` are set to `status: approved` and the implement skill is invoked for the same track

#### Scenario: User sends different input after summary
- **WHEN** the spec skill presents its post-phase summary and the user replies "muda a fase 2 para usar Redis"
- **THEN** the spec skill processes the instruction and presents an updated summary without advancing to implement

### Requirement: Post-phase summaries replace approval gates
Each skill SHALL end with a structured summary containing exactly four short bullets describing what was captured, a list of any supporting artifacts generated, and a concrete next-step line. The summary SHALL NOT report draft status as a failure or present an approval gate. The next-step line SHALL show the `.` shorthand.

#### Scenario: Intent skill summary format
- **WHEN** the intent skill finishes drafting `intent.md`
- **THEN** it presents four bullets summarizing problem, outcome, scope, and constraints, names any generated artifacts (research, refs, ADRs, assessments), states the track location, and ends with ". para continuar com a spec"

#### Scenario: Spec skill summary format
- **WHEN** the spec skill finishes drafting `spec.md` and `tasks.md`
- **THEN** it presents four bullets summarizing outcome, phases, task count, and parallel groups, and ends with ". para implementar"

#### Scenario: Implement skill summary format
- **WHEN** the implement skill finishes all tasks, review, and gate
- **THEN** it presents a summary of completed work and ends with ". para ship"

### Requirement: Intent skill asks interactive clarifying questions
When a user request is too vague to draft a well-scoped intent, the intent skill SHALL ask up to three focused questions using the host interactive pattern. Each question SHALL explain why it matters. The skill SHALL incorporate answers into the intent body, not leave them as disconnected conversation.

#### Scenario: Vague request triggers questions
- **WHEN** a user says "quero melhorar a autenticacao"
- **THEN** the intent skill asks up to three clarifying questions before drafting `intent.md`

#### Scenario: Clear request skips questions
- **WHEN** a user provides a request with explicit problem, outcome, and scope
- **THEN** the intent skill drafts `intent.md` without asking questions

### Requirement: Intent skill autonomously generates supporting artifacts
The intent skill SHALL invoke supporting artifact workflows without user command when explicit triggers are met. Before each invocation, it SHALL inform the user in one sentence (e.g., "Vou pesquisar X.") without asking permission. The triggers are:

- **Research**: the user mentions a technology, API, pattern, or external fact the model cannot confirm with confidence.
- **Ref**: the user supplies a URL, document, or external code snippet that materially grounds the intent.
- **ADR**: an answer to a clarifying question meets the qualifying criteria (durable, costly to reverse, surprising without context, or meaningful trade-off).
- **Assessment**: the user asks to evaluate something existing, or the intent depends on the current condition of a system the model can inspect.

#### Scenario: Technology mention triggers research
- **WHEN** the user mentions an unfamiliar API during intent and the model lacks reliable knowledge
- **THEN** the intent skill announces it will research, produces a research artifact, and cites the slug in the intent's `research:` field

#### Scenario: URL triggers ref capture
- **WHEN** the user supplies a URL as basis for the intent
- **THEN** the intent skill captures a ref and cites the slug in the intent's `refs:` field

#### Scenario: Qualifying answer triggers ADR
- **WHEN** the user answers "Postgres" to a database choice question and the choice is durable and costly to reverse
- **THEN** the intent skill creates an ADR and cites it in the intent's `decisions:` field

#### Scenario: Known fact does not trigger research
- **WHEN** the user mentions a well-known technology the model can confirm with confidence
- **THEN** no research artifact is produced

### Requirement: Non-implementation intents exit cleanly
When an intent is a research question, assessment request, or exploration that does not require spec or implementation, the intent skill SHALL produce the appropriate artifact, present the standard summary, and offer a clean exit instead of showing `. para continuar com a spec`. The intent status stays `draft`; it is not forced through the spec-implement pipeline.

#### Scenario: Research-only intent
- **WHEN** the user's request is purely investigative ("pesquise como funciona X")
- **THEN** the intent skill produces a research artifact, presents the summary, and states the track is complete without suggesting spec or implement

#### Scenario: Assessment-only intent
- **WHEN** the user's request is an evaluation ("avalie o estado do modulo Y")
- **THEN** the intent skill produces an assessment artifact and offers a clean exit

### Requirement: Portuguese continuation copy is the user-facing protocol
The required next-step and non-implementation-exit lines SHALL be the Portuguese strings already named by this capability. Other user-facing package prose MAY stay English. Those named Portuguese strings SHALL NOT be treated as a house-rule violation.

#### Scenario: House rule allows the named strings
- **WHEN** an agent reads AGENTS house rules
- **THEN** English remains the default for commands, skills, and error messages, with an explicit exception for the continuous-flow next-step and exit lines

#### Scenario: Next-step lines stay Portuguese
- **WHEN** intent, spec, or implement presents a post-phase summary
- **THEN** the next-step line is `. para continuar com a spec`, `. para implementar`, or `. para ship (marca a track como concluida)` respectively, not an English rewrite of those strings

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
