## ADDED Requirements

### Requirement: Spec phases separate delivered state from its check
Each spec phase SHALL use `Done:` for the delivered state an observer can see when the phase closes, and `Accept:` for the check that proves that state: a command with its expected result, or an observable procedure with its expected observation. The spec template and the spec skill SHALL state this distinction. The gate's phase field requirements SHALL NOT change.

#### Scenario: Phase distinguishes state and check
- **WHEN** the spec skill drafts a phase that adds an index column
- **THEN** `Done:` describes the column as present in generated output and `Accept:` names the command that produces the output and the expected column

#### Scenario: Existing phase shape stays valid
- **WHEN** a spec written before this change has non-empty `Done:`, `Files:`, and `Accept:` lines
- **THEN** the structure gate still passes it

## MODIFIED Requirements

### Requirement: Research preserves traceable external findings
A research action SHALL write one status-free file under `fast-track-ai/research/<slug>.md`. The artifact SHALL identify capture date and owner, state the question and conclusion, cite direct sources for material claims, distinguish facts from inference, report conflicting evidence and limitations, and label material claims that rely on one source or potentially stale evidence. Source records SHALL live in the body so one research artifact can cite multiple sources.

When evidence does not support an answer, the conclusion SHALL state that the result is inconclusive and name the evidence that would settle it.

When `fast-track-ai/research/<slug>.md` already exists, the action SHALL rewrite it only when the user asked to refresh that research, and otherwise SHALL choose a distinct slug. It SHALL never overwrite an existing file silently.

#### Scenario: Research uses multiple sources
- **WHEN** a conclusion depends on more than one source
- **THEN** the artifact cites each source at the relevant claim and does not reduce provenance to one frontmatter `source` value

#### Scenario: Evidence conflicts
- **WHEN** credible sources disagree
- **THEN** the artifact records the conflict and explains which conclusion, if any, the evidence supports

#### Scenario: Evidence is insufficient
- **WHEN** the retrieved sources do not answer the question
- **THEN** the conclusion says the result is inconclusive and names what would settle it, instead of forcing an answer

#### Scenario: Slug already exists
- **WHEN** the chosen slug names an existing research file and the user did not ask to refresh it
- **THEN** the action writes under a distinct slug and leaves the existing file unchanged

#### Scenario: Existing base research skill is unavailable
- **WHEN** a user requests research and no external research skill is installed
- **THEN** `fast-track-ai-research` performs the research and writes the artifact directly

### Requirement: Assessments provide independent inward evaluation
An assessment action SHALL write `fast-track-ai/assessments/<YYYY-MM-DD>-<slug>.md` with capture date, owner, scope, evaluator identity, and related tracks. `tracks` SHALL list the IDs of the tracks the assessment evaluates, or `[]` when it evaluates none. It SHALL contain Conclusion, Scope and basis, Criteria, Findings, Evidence against conclusion, Limitations, and Recommendations. Each finding SHALL state the problem, its evidence, its consequence, and the recommendation, and any priority SHALL follow from the stated consequence. It MUST NOT contain a lifecycle status or require a generic numeric scorecard.

When the target path already exists, the action SHALL rewrite it only when the user asked to redo that assessment, and otherwise SHALL choose a distinct slug. It SHALL never overwrite an existing file silently.

#### Scenario: Another model performs the assessment
- **WHEN** the assessment is delegated to a different provider or model
- **THEN** the artifact records that evaluator and preserves evidence sufficient for a maintainer to review its conclusion

#### Scenario: Evidence challenges the conclusion
- **WHEN** material counterevidence exists
- **THEN** the assessment includes it under Evidence against conclusion instead of presenting only supporting findings

#### Scenario: Finding carries its consequence
- **WHEN** an assessment reports a gap
- **THEN** the finding names the problem, cites the evidence, states the consequence, and gives the recommendation, with any priority justified by that consequence

#### Scenario: Same-day assessment already exists
- **WHEN** `<YYYY-MM-DD>-<slug>.md` already exists and the user did not ask to redo it
- **THEN** the action writes under a distinct slug and leaves the existing file unchanged

#### Scenario: Assessment supports a later track
- **WHEN** a track is created from an assessment
- **THEN** the intent cites the assessment slug in `assessments:` rather than treating it as external research

### Requirement: Refs preserve immutable source inputs
A user-supplied source that materially grounds an intent SHALL be captured under `fast-track-ai/refs/<slug>.md` before the intent cites it. Each ref SHALL declare `type`, `captured`, `owner`, `sha256`, and `content_license`. The entire ref file, including frontmatter, headings, and notes, SHALL be no larger than 500 KB. A ref SHALL remain immutable except by creating a new ref for changed source content.

A written ref SHALL contain only the body section of its type: `## Locator` for `pointer`, and `## Source content` for `inline`. The capture rules SHALL be owned by the intent skill. The ref template SHALL NOT restate them in a `## Contract` section.

#### Scenario: Small redistributable text must remain available offline
- **WHEN** exact source text is needed, the resulting ref file is at most 500 KB, and its license permits storage in the repository
- **THEN** the method creates an `inline` ref containing the durable text

#### Scenario: Inline ref file exceeds the limit
- **WHEN** the source text fits in 500 KB but the complete ref file with frontmatter, headings, and notes exceeds 500 KB
- **THEN** index generation rejects the ref as over 500 KB and the method uses a `pointer` ref instead

#### Scenario: Source must not be copied
- **WHEN** a source is large, binary, stable upstream, or its license does not permit repository redistribution
- **THEN** the method creates a `pointer` ref with a canonical locator rather than copying the protected content

#### Scenario: Versioned source is available
- **WHEN** the source offers an immutable version, release, commit, or content-addressed identifier
- **THEN** a pointer ref records that value as its pin

#### Scenario: Mutable source has no immutable version
- **WHEN** a pointer targets mutable content with no available immutable identifier
- **THEN** it records when the content was retrieved and the hash of the content observed at that time without inventing a pin

#### Scenario: Source content cannot be accessed
- **WHEN** the agent cannot retrieve or receive the source after asking for it once
- **THEN** it does not create a synthetic ref or hash a URL or locator stub as if it were source content, and the consuming intent records the missing basis as an open question or assumed state

#### Scenario: Pointer ref carries only its section
- **WHEN** the intent skill writes a `pointer` ref
- **THEN** the file has a `## Locator` section and no `## Source content` or `## Contract` section

### Requirement: Decisions are captured when accepted
A qualifying user decision SHALL be recorded as an accepted ADR during intent, spec, or implementation. A decision qualifies when it is durable, costly to reverse, surprising without context, or resolves a meaningful trade-off. ADRs SHALL use only `accepted` or `superseded` status, and SHALL preserve context, decision, rationale, alternatives, consequences, and optional evidence or ref citations. Evidence SHALL be recorded only in the `## Evidence` body section. The ADR template SHALL NOT carry an `evidence` frontmatter field.

To replace an ADR, the workflow SHALL:
1. Create the replacement as the next numbered accepted ADR.
2. Set the original's `status: superseded` and add `superseded_by: <replacement-id>`.
3. Leave the original's other content unchanged.

#### Scenario: Decision occurs during intent
- **WHEN** the user makes a qualifying accepted decision while intent is being drafted
- **THEN** the intent workflow creates the ADR and cites it in `decisions:` without waiting for spec

#### Scenario: Decision does not qualify
- **WHEN** a choice is local, easily reversible, or obvious from the surrounding implementation
- **THEN** the method does not create an ADR for it

#### Scenario: Accepted decision changes during implementation
- **WHEN** a new qualifying decision conflicts with or materially changes approved spec or tasks
- **THEN** implementation pauses until the ADR, spec, and tasks are reconciled and the planning artifacts are approved again

#### Scenario: Decision is replaced
- **WHEN** a later accepted decision supersedes an ADR
- **THEN** the original ADR retains its decision content, changes status to `superseded`, identifies its replacement in `superseded_by`, and the replacement records the new decision

#### Scenario: Evidence has one home
- **WHEN** a new ADR is written from the template
- **THEN** its evidence citations appear under `## Evidence` and its frontmatter has no `evidence` field

### Requirement: Handoffs transfer portable working context
A handoff action SHALL write directly to `fast-track-ai/handoffs/<timestamp>-<slug>.md`, preserve the user's exact active instructions, summarize objective and current state, identify completed work, list next actions in one ordered `## Next actions` list whose first item is the first concrete step, list relevant paths and observed command results, and disclose blockers and risks. It SHALL reference durable artifacts by path instead of duplicating them and SHALL omit secrets and unnecessary personal data.

Index generation SHALL accept a handoff that has `## Next actions`. It SHALL also accept a legacy handoff that has `## P0 next actions`, `## P1 next actions`, and `## First next action` in its place. It SHALL reject a handoff that has neither set.

New handoffs SHALL use a UTC timestamp with seconds: filename prefix `YYYY-MM-DD-HHmmssZ` and `captured: YYYY-MM-DDTHH:MM:SSZ`, both naming the same instant. Legacy `YYYY-MM-DD-HHmm-OFFSET` filenames remain valid. Active handoffs SHALL be ordered by the instant in `captured`, never by filename text, and the action SHALL NOT overwrite an existing handoff in either the active directory or archive.

#### Scenario: Session changes agent or harness
- **WHEN** a user requests a handoff
- **THEN** the next agent can identify the objective, constraints, verified state, and immediate next action from the handoff without relying on conversation history

#### Scenario: Legacy handoff headings
- **WHEN** an active handoff has P0, P1, and First next action headings and no `## Next actions`
- **THEN** index generation accepts it

#### Scenario: Handoff without next actions
- **WHEN** an active handoff has neither `## Next actions` nor the legacy set
- **THEN** index generation exits unsuccessfully and names the handoff and the missing heading

#### Scenario: Handoff history exceeds the active limit
- **WHEN** more than three handoffs exist in the active handoff directory
- **THEN** the method retains the three newest by `captured` instant there and moves older handoffs to `fast-track-ai/handoffs/archive/`

#### Scenario: Offsets disagree with filename order
- **WHEN** active handoffs are `2026-09-21-1000-+0200-a.md` captured `2026-09-21T10:00:00+02:00` and `2026-09-21-0930-Z-b.md` captured `2026-09-21T09:30:00Z`
- **THEN** `a` is treated as older than `b`

#### Scenario: Destination already exists
- **WHEN** the computed handoff path, or the archive path for a handoff being moved, already exists
- **THEN** the action stops without overwriting and reports the collision

#### Scenario: External handoff skill is unavailable
- **WHEN** no base handoff skill is installed
- **THEN** `fast-track-ai-handoff` still creates the package-owned handoff artifact directly

### Requirement: Tasks declare parallelism groups and dependency edges
The `tasks.md` artifact SHALL organize tasks into named parallel groups. Tasks within the same group have no mutual dependency and MAY execute concurrently. Groups SHALL declare dependencies on other groups using a `depends:` annotation. The implement skill SHALL read these annotations to determine which tasks to parallelize and which to serialize.

Each task line SHALL name the spec phase it serves in a `(Phase N)` tag. Its `Validate:` SHALL be a command with its expected result, or an observable procedure with its expected observation. The gate's task field requirements SHALL NOT change.

#### Scenario: Independent tasks are grouped
- **WHEN** the spec skill identifies tasks that touch disjoint files and have no data dependency
- **THEN** it places them in the same parallel group

#### Scenario: Dependent group waits for predecessor
- **WHEN** a parallel group declares `depends: A`
- **THEN** the implement skill starts that group only after all tasks in group A are complete

#### Scenario: Single-task group
- **WHEN** a group contains exactly one task
- **THEN** it is valid and the implement skill treats it as a serial step

#### Scenario: Task names its phase and check
- **WHEN** the spec skill writes a task
- **THEN** the line carries a `(Phase N)` tag matching a spec phase and a `Validate:` naming a command or procedure with its expected result
