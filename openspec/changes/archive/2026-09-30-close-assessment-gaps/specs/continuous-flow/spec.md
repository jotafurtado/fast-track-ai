## ADDED Requirements

### Requirement: Intent records assumed state by provenance
The intent template's `Assumed state` section SHALL separate three lists:
- `Stated by the user`: facts the user asserted.
- `Unverified assumptions`: premises the agent adopted without checking.
- `Access limits`: sources or systems the agent could not reach.

The intent skill SHALL place each premise in exactly one list. It SHALL NOT present an unverified assumption as a stated fact.

#### Scenario: User states a fact
- **WHEN** the user says the API already returns paginated results
- **THEN** the intent records it under `Stated by the user`

#### Scenario: Agent assumes without checking
- **WHEN** the agent assumes a module has no other callers without searching for them
- **THEN** the intent records it under `Unverified assumptions`

#### Scenario: Source is unreachable
- **WHEN** a referenced repository or document cannot be accessed
- **THEN** the intent records it under `Access limits`

## MODIFIED Requirements

### Requirement: Intent skill autonomously generates supporting artifacts
While drafting an intent for a change request, the intent skill SHALL invoke supporting artifact workflows without a user command when explicit triggers are met. Before each invocation, it SHALL inform the user in one sentence (e.g., "Vou pesquisar X.") without asking permission. The triggers are:
- **Research**: a scope, design, or acceptance decision in the intent depends on an external fact (version behavior, API contract, configuration, limit, license, or price) that is not verified in the repository or in sources already read in the session. Familiarity with a technology does not waive the trigger when the decision depends on such a fact.
- **Ref**: the user supplies a URL, document, or external code snippet that materially grounds the intent.
- **ADR**: an answer to a clarifying question meets the qualifying criteria (durable, costly to reverse, surprising without context, or meaningful trade-off).
- **Assessment**: the intended change depends on the current condition of a system the model can inspect.

A request that asks only for evaluation, with no desired change, SHALL be routed rather than treated as an assessment trigger.

#### Scenario: Technology mention triggers research
- **WHEN** the intent's scope depends on whether a library version supports a specific API and nothing read in the session confirms it
- **THEN** the intent skill announces it will research, produces a research artifact, and cites the slug in the intent's `research:` field

#### Scenario: URL triggers ref capture
- **WHEN** the user supplies a URL as basis for the intent
- **THEN** the intent skill captures a ref and cites the slug in the intent's `refs:` field

#### Scenario: Qualifying answer triggers ADR
- **WHEN** the user answers "Postgres" to a database choice question and the choice is durable and costly to reverse
- **THEN** the intent skill creates an ADR and cites it in the intent's `decisions:` field

#### Scenario: Known fact does not trigger research
- **WHEN** the user mentions a technology but no decision in the intent depends on an unverified external fact about it
- **THEN** no research artifact is produced

#### Scenario: Change depends on current system state
- **WHEN** the user asks to refactor module Y and the right scope depends on its current condition
- **THEN** the intent skill runs an assessment, receives the result as the caller, and cites the slug in `assessments:`
