# Spec Delta

## MODIFIED Requirements

### Requirement: Handoffs transfer portable working context
A handoff action SHALL write directly to `fast-track-ai/handoffs/<timestamp>-<slug>.md`, preserve the user's exact active instructions, summarize objective and current state, identify completed work, list next actions in one ordered `## Next actions` list whose first item is the first concrete step, list relevant paths and observed command results, and disclose blockers and risks. It SHALL reference durable artifacts by path instead of duplicating them and SHALL omit secrets and unnecessary personal data.

Index generation SHALL require `## Next actions` and SHALL reject a handoff without it, including one that carries `## P0 next actions`, `## P1 next actions`, and `## First next action` instead.

Handoffs SHALL use a UTC timestamp with seconds: filename prefix `YYYY-MM-DD-HHmmssZ` and `captured: YYYY-MM-DDTHH:MM:SSZ`, both naming the same instant. Index generation SHALL reject any other filename or `captured` form, including minute-precision names and numeric offsets. Active handoffs SHALL be ordered by the instant in `captured`, and the action SHALL NOT overwrite an existing handoff in either the active directory or archive.

The action SHALL run in this order:
1. Check that the computed path exists in neither the active directory nor the archive.
2. Write the new handoff.
3. Validate the new handoff: every required heading from the template is present, `captured` has the `YYYY-MM-DDTHH:MM:SSZ` form and names the filename instant, and the frontmatter conforms to the canonical subset.
4. Only after step 3 passes, move older handoffs to the archive.
5. Only after step 4, run the index.

When step 3 fails, the action SHALL fix the new handoff or stop and report the failure, and SHALL NOT archive any handoff.

#### Scenario: Session changes agent or harness
- **WHEN** a user requests a handoff
- **THEN** the next agent can identify the objective, constraints, verified state, and immediate next action from the handoff without relying on conversation history

#### Scenario: Legacy handoff headings
- **WHEN** an active handoff has P0, P1, and First next action headings and no `## Next actions`
- **THEN** index generation exits unsuccessfully and names the handoff and the missing `## Next actions` heading

#### Scenario: Handoff without next actions
- **WHEN** an active handoff has no `## Next actions` heading
- **THEN** index generation exits unsuccessfully and names the handoff and the missing heading

#### Scenario: Handoff history exceeds the active limit
- **WHEN** more than three handoffs exist in the active handoff directory after a new handoff passes validation
- **THEN** the method retains the three newest by `captured` instant there and moves older handoffs to `fast-track-ai/handoffs/archive/`

#### Scenario: New handoff fails validation
- **WHEN** the newly written handoff lacks a required heading, or its `captured` differs from the filename instant
- **THEN** no older handoff moves to the archive and the index is not run until the new handoff is fixed

#### Scenario: Offsets disagree with filename order
- **WHEN** an active handoff is named `2026-09-21-1000-+0200-a.md` with `captured: 2026-09-21T10:00:00+02:00`
- **THEN** index generation exits unsuccessfully and names the invalid filename and the invalid `captured` form

#### Scenario: Destination already exists
- **WHEN** the computed handoff path, or the archive path for a handoff being moved, already exists
- **THEN** the action stops without overwriting and reports the collision

#### Scenario: External handoff skill is unavailable
- **WHEN** no base handoff skill is installed
- **THEN** `fast-track-ai-handoff` still creates the package-owned handoff artifact directly

### Requirement: Index discovers and validates all artifact types
The generated `fast-track-ai/INDEX.md` SHALL list tracks plus active refs, research, assessments, decisions, and handoffs in deterministic order. Active handoffs SHALL be listed by ascending `captured` instant. Index generation SHALL validate each artifact's required metadata, filename rules, permitted lifecycle fields, size constraints, and type-specific invariants, and SHALL fail with an objective artifact-specific error when validation fails.

Index generation SHALL also validate that every track directory contains an `intent.md`; every slug in an intent's `refs`, `research`, `assessments`, and `decisions` flow lists names an existing artifact in that category; every `superseded_by` on an intent or decision names an existing artifact of the same type other than itself; every handoff filename timestamp matches its `captured` instant; and no more than three handoffs are active.

When validation fails, index generation SHALL exit unsuccessfully, name the file and violated rule, leave any existing `INDEX.md` unchanged, and state that the index was not updated. On success it SHALL replace `INDEX.md` atomically.

#### Scenario: Valid tree is indexed twice
- **WHEN** the index generator runs twice without artifact changes
- **THEN** both runs succeed and produce byte-identical `INDEX.md` content

#### Scenario: Supporting artifact is added
- **WHEN** a valid ref, research, assessment, decision, or active handoff is added
- **THEN** the next generated index contains a discoverable row for that artifact type

#### Scenario: Invalid artifact is present
- **WHEN** an artifact omits required metadata, uses a forbidden status, violates its naming convention, or claims an invalid type
- **THEN** index generation exits unsuccessfully and names the file and violated rule

#### Scenario: Failed validation keeps the previous index
- **WHEN** a valid tree has been indexed and an invalid artifact is then added
- **THEN** index generation exits unsuccessfully, `INDEX.md` is byte-identical to the previous successful output, and the error output says the index was not updated

#### Scenario: Track directory without intent
- **WHEN** `fast-track-ai/tracks/011-orphan/` exists without `intent.md`
- **THEN** index generation exits unsuccessfully and names `011-orphan`

#### Scenario: Intent cites a missing artifact
- **WHEN** an intent declares `research: [missing-topic]` and `fast-track-ai/research/missing-topic.md` does not exist
- **THEN** index generation exits unsuccessfully and names the intent, the `research` list, and `missing-topic`

#### Scenario: Superseded decision points at a missing replacement
- **WHEN** a decision has `status: superseded` and `superseded_by: 099-nowhere` with no such decision file
- **THEN** index generation exits unsuccessfully and names the decision and `099-nowhere`

#### Scenario: Superseded artifact points at itself
- **WHEN** an intent or decision declares `superseded_by` equal to its own id
- **THEN** index generation exits unsuccessfully and reports a self-reference

#### Scenario: Too many active handoffs
- **WHEN** four handoffs exist directly under `fast-track-ai/handoffs/`
- **THEN** index generation exits unsuccessfully and reports that more than three handoffs are active

#### Scenario: Archived handoffs exist
- **WHEN** handoffs have been moved to `handoffs/archive/`
- **THEN** the active index excludes them from the current handoff table
