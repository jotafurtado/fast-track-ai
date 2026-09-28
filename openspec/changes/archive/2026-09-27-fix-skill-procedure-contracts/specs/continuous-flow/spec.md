# Spec Delta

## MODIFIED Requirements

### Requirement: Post-phase summaries replace approval gates
The intent, spec, and implement skills SHALL each end with a structured summary with three parts: exactly four short bullets describing what was captured, a list of any supporting artifacts generated, and a concrete next-step line. The summary SHALL NOT report draft status as a failure or ask a separate approval question. The next-step line SHALL show the `.` shorthand.

Init, research, assess, and handoff SHALL NOT end with a four-bullet summary or a `.` next-step line. When invoked directly, they SHALL report their result, the artifact path, and any pending items or validation errors.

#### Scenario: Intent skill summary format
- **WHEN** the intent skill finishes drafting `intent.md`
- **THEN** it presents four bullets summarizing problem, outcome, scope, and constraints, names any generated artifacts (research, refs, ADRs, assessments), states the track location, and ends with ". para continuar com a spec"

#### Scenario: Spec skill summary format
- **WHEN** the spec skill finishes drafting `spec.md` and `tasks.md`
- **THEN** it presents four bullets summarizing outcome, phases, task count, and parallel groups, and ends with ". para implementar"

#### Scenario: Implement skill summary format
- **WHEN** the implement skill finishes all tasks, acceptance checks, review, and gate
- **THEN** it presents four bullets for completed tasks, acceptance, review outcome, and gate result, and ends with ". para ship (marca a track como concluida)"

#### Scenario: Direct research ends without continuation
- **WHEN** the user invokes `fast-track-ai-research` directly and the artifact is written
- **THEN** the skill reports the conclusion, the artifact path, and the index result, and shows no `.` next-step line

#### Scenario: Managed block scopes the rule
- **WHEN** an agent reads the managed AGENTS block
- **THEN** it states that intent, spec, and implement end with the four-bullet summary and a next-step line, and does not claim that every skill does

### Requirement: Intent skill autonomously generates supporting artifacts
While drafting an intent for a change request, the intent skill SHALL invoke supporting artifact workflows without a user command when explicit triggers are met. Before each invocation, it SHALL inform the user in one sentence (e.g., "Vou pesquisar X.") without asking permission. The triggers are:

- **Research**: the user mentions a technology, API, pattern, or external fact the model cannot confirm with confidence.
- **Ref**: the user supplies a URL, document, or external code snippet that materially grounds the intent.
- **ADR**: an answer to a clarifying question meets the qualifying criteria (durable, costly to reverse, surprising without context, or meaningful trade-off).
- **Assessment**: the intended change depends on the current condition of a system the model can inspect.

A request that asks only for evaluation, with no desired change, SHALL be routed rather than treated as an assessment trigger.

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

#### Scenario: Change depends on current system state
- **WHEN** the user asks to refactor module Y and the right scope depends on its current condition
- **THEN** the intent skill runs an assessment, receives the result as the caller, and cites the slug in `assessments:`

### Requirement: Non-implementation intents exit cleanly
When a request is purely investigative or evaluative and describes no desired change to the system, the intent skill SHALL do the following before allocating a track number:
- Route the request to `fast-track-ai-research` or `fast-track-ai-assess`.
- Create no track directory and no `intent.md`.
- Not present `. para continuar com a spec` or any track-completion line.

The routed skill SHALL handle the request as a direct invocation. When the classification is ambiguous, the intent skill's clarifying questions SHALL resolve it before anything is written.

#### Scenario: Research-only intent
- **WHEN** the user's request is purely investigative ("pesquise como funciona X")
- **THEN** a research artifact is written and indexed, no new directory appears under `fast-track-ai/tracks/`, and the reply suggests neither spec nor implement

#### Scenario: Assessment-only intent
- **WHEN** the user's request is an evaluation ("avalie o estado do modulo Y")
- **THEN** an assessment artifact is written and indexed, and no track or intent is created

#### Scenario: Change request that needs research
- **WHEN** the user asks for a change that depends on an unconfirmed external fact
- **THEN** the intent skill creates the track, runs research as an auxiliary call, and continues to its own summary

### Requirement: Portuguese continuation copy is the user-facing protocol
The required next-step lines SHALL be the Portuguese strings `. para continuar com a spec`, `. para implementar`, and `. para ship (marca a track como concluida)`. Other user-facing package prose MAY stay English. Those named Portuguese strings SHALL NOT be treated as a house-rule violation. The retired line `Track concluida. Nenhuma implementacao necessaria.` SHALL NOT appear in live skills, command wrappers, or the managed AGENTS block.

#### Scenario: House rule allows the named strings
- **WHEN** an agent reads AGENTS house rules
- **THEN** English remains the default for commands, skills, and error messages, with an explicit exception for the three continuous-flow next-step lines only

#### Scenario: Next-step lines stay Portuguese
- **WHEN** intent, spec, or implement presents a post-phase summary
- **THEN** the next-step line is `. para continuar com a spec`, `. para implementar`, or `. para ship (marca a track como concluida)` respectively, not an English rewrite of those strings

## ADDED Requirements

### Requirement: Spec approval covers the presented version
A `.` or affirmative synonym after the spec summary SHALL approve exactly the `spec.md` and `tasks.md` content that summary presented. After approval, a material change to either file SHALL return both files to `status: draft`, whether it comes from the spec skill or from a decision during implementation. Material changes are to scope, Files, Accept criteria, tasks, or group dependencies. The skill SHALL then present a new spec summary before implementation continues. Checkbox updates and administrative writes defined by the implement workflow SHALL NOT count as material changes.

#### Scenario: Revision after approval
- **WHEN** the user approves the spec and later asks to add a phase before implementation starts
- **THEN** both files return to `draft`, the spec skill revises them, and it presents a new summary ending with `. para implementar`

#### Scenario: Implementation finds a material conflict
- **WHEN** during implementation an accepted decision changes a phase's Accept criterion
- **THEN** implementation stops, both planning files return to `draft`, and a new spec summary is presented before any further task runs

### Requirement: Spec resolves blocking questions before approval
The spec skill SHALL classify each unanswered intent `Open questions` item before drafting.
- A question is blocking when its answer changes scope, security, data persistence, external integration, architecture, or acceptance. The skill SHALL ask blocking questions interactively (at most three per pass). It SHALL NOT present the spec summary or `. para implementar` while any blocking question is unanswered.
- A deferrable question SHALL become a bounded task whose Validate states the expected answer or artifact. That task sits in a group that every dependent group lists in `(depends: ...)`.

The spec skill SHALL NOT invent answers to either kind.

#### Scenario: Authorization question blocks approval
- **WHEN** the intent leaves "who may read the report?" unanswered and the answer changes access control
- **THEN** the spec skill asks that question and withholds the summary until it is answered

#### Scenario: Local question becomes a task
- **WHEN** the intent leaves "which date format should the export use?" unanswered and the choice is local and reversible
- **THEN** `tasks.md` contains a task to settle it, and the groups that use the export depend on that task's group

### Requirement: Auxiliary skills return results to their caller
When the intent skill invokes research or assess as an auxiliary step of a change request, that skill SHALL write its artifact and regenerate the index. It SHALL return its conclusion, limitations, and artifact path to the intent skill. It SHALL NOT present its own user-facing summary, next-step line, or stop message. The intent skill SHALL cite the returned slug and continue its own procedure.

#### Scenario: Assessment during intent
- **WHEN** the intent skill triggers an assessment while drafting a change request
- **THEN** the user sees one intent summary at the end, which lists the assessment among generated artifacts, and no separate assessment stop message

### Requirement: Cycle skills keep the index current
The intent skill SHALL regenerate `fast-track-ai/INDEX.md` with the owner index script after writing or revising `intent.md` and after setting `dropped` or `superseded`. The spec skill SHALL regenerate it after writing `spec.md`, `tasks.md`, and any ADR it filed. Each SHALL report an index validation failure instead of presenting its summary as complete.

#### Scenario: New intent is discoverable
- **WHEN** the intent skill drafts `fast-track-ai/tracks/011-example/intent.md`
- **THEN** `INDEX.md` lists `011-example` before the intent summary is presented

#### Scenario: Spec files an ADR
- **WHEN** the spec skill files a new ADR while drafting
- **THEN** `INDEX.md` lists that decision before the spec summary is presented
