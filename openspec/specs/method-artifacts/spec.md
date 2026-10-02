# Method Artifacts

## Purpose

Defines the supporting artifact types of the fast-track-ai method and the contracts governing refs, research, assessments, decisions, handoffs, and index generation.

## Requirements

### Requirement: Five artifact types have distinct purposes
The method SHALL recognize refs, research, assessments, decisions, and handoffs as distinct supporting artifact types. A ref SHALL preserve a source used as an input, research SHALL investigate external facts, an assessment SHALL evaluate the target project or an idea, a decision SHALL preserve an accepted durable choice and its trade-offs, and a handoff SHALL transfer current working context to another session or agent.

#### Scenario: Artifact is classified by purpose
- **WHEN** an agent needs to preserve supporting information
- **THEN** it selects one of the five artifact types according to the information's purpose rather than storing interchangeable notes

#### Scenario: User-facing actions stay minimal
- **WHEN** a user explicitly requests supporting work
- **THEN** the method exposes research, assessment, and handoff as explicit actions while ref and decision capture occur within the workflows that consume them

### Requirement: Package workflows are self-contained
The research, assessment, and handoff workflows SHALL execute using instructions and templates owned by the fast-track-ai package. They MUST NOT require a separately installed third-party skill at runtime. The package installer SHALL link every `skills/fast-track-ai-*` directory into the harness skills dirs and SHALL link every `commands/fast-track-ai-*.md` file into the harness commands directory.

#### Scenario: Base skills are absent
- **WHEN** fast-track-ai is installed on a machine that has no third-party research, assessment, or handoff skill
- **THEN** all three package workflows remain usable and produce conforming artifacts

#### Scenario: Seventh skill is installed
- **WHEN** the package installer discovers package skills
- **THEN** it installs `fast-track-ai-assess` alongside the existing six fast-track-ai skills and exposes its command

#### Scenario: Command wrappers are installed
- **WHEN** the package installer runs with default or custom directories
- **THEN** all seven `fast-track-ai-*.md` command files resolve in the harness commands directory, and the install eval asserts those links

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

### Requirement: Ref hashes identify captured content
The `sha256` field SHALL identify the captured source representation, never merely its URL, file path, or descriptive stub. Pointer refs SHALL hash the source payload observed at capture time.

Inline refs SHALL hash the normalized stored source text. That text is every line after the `## Source content` heading, with these rules:
- Exactly one blank separator line directly after the heading is excluded when present.
- Carriage returns are removed.
- Each line ends with one LF.

The first source line SHALL be included whether or not a separator line is present.

#### Scenario: Inline content starts directly after the heading
- **WHEN** an inline ref has its first source line immediately after `## Source content` with no blank line, and `sha256` is the hash of all source lines
- **THEN** index generation accepts the hash

#### Scenario: Inline content follows a separator line
- **WHEN** an inline ref has one blank line after `## Source content` and `sha256` is the hash of the lines after that blank line
- **THEN** index generation accepts the hash

#### Scenario: Duplicate source content is supplied
- **WHEN** newly supplied source content has the same hash as an existing ref
- **THEN** the method reuses the existing ref instead of creating a duplicate under another slug

#### Scenario: Pointer target changes
- **WHEN** a mutable pointer target later produces different content
- **THEN** the existing ref remains unchanged and a new ref is required to represent the new source state

### Requirement: Source licensing constrains incorporation
The method SHALL record the known license of captured source content or `unknown` when no explicit license is available. Instructions may incorporate textual or procedural material only from sources verified as MIT or Apache-2.0 compatible for that use. Sources under incompatible, noncommercial, or unknown terms SHALL be limited to citation, pointer capture, and independently expressed concepts.

#### Scenario: Source is CC BY-NC-SA 4.0
- **WHEN** a source uses CC BY-NC-SA 4.0
- **THEN** the method may cite or point to it but does not copy or adapt its protected text into package instructions intended for MIT or Apache-2.0 distribution

#### Scenario: Source has no explicit license
- **WHEN** a web article has no explicit reuse license
- **THEN** the method records `content_license: unknown` and captures it as a pointer only

#### Scenario: ADR article is captured
- **WHEN** this change is implemented
- **THEN** the Jhony Walker article `Guia Completo sobre Architecture Decision Records (ADR): Definição e Melhores Práticas` exists as a pointer ref with its canonical Medium URL, observed-content hash, capture metadata, and unknown license

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
- **THEN** index generation accepts it

#### Scenario: Handoff without next actions
- **WHEN** an active handoff has neither `## Next actions` nor the legacy set
- **THEN** index generation exits unsuccessfully and names the handoff and the missing heading

#### Scenario: Handoff history exceeds the active limit
- **WHEN** more than three handoffs exist in the active handoff directory after a new handoff passes validation
- **THEN** the method retains the three newest by `captured` instant there and moves older handoffs to `fast-track-ai/handoffs/archive/`

#### Scenario: New handoff fails validation
- **WHEN** the newly written handoff lacks a required heading, or its `captured` differs from the filename instant
- **THEN** no older handoff moves to the archive and the index is not run until the new handoff is fixed

#### Scenario: Offsets disagree with filename order
- **WHEN** active handoffs are `2026-09-21-1000-+0200-a.md` captured `2026-09-21T10:00:00+02:00` and `2026-09-21-0930-Z-b.md` captured `2026-09-21T09:30:00Z`
- **THEN** `a` is treated as older than `b`

#### Scenario: Destination already exists
- **WHEN** the computed handoff path, or the archive path for a handoff being moved, already exists
- **THEN** the action stops without overwriting and reports the collision

#### Scenario: External handoff skill is unavailable
- **WHEN** no base handoff skill is installed
- **THEN** `fast-track-ai-handoff` still creates the package-owned handoff artifact directly

### Requirement: Index discovers and validates all artifact types
The generated `fast-track-ai/INDEX.md` SHALL list tracks plus active refs, research, assessments, decisions, and handoffs in deterministic order. Active handoffs SHALL be listed by ascending `captured` instant. Index generation SHALL validate each artifact's required metadata, filename rules, permitted lifecycle fields, size constraints, and type-specific invariants, and SHALL fail with an objective artifact-specific error when validation fails.

Index generation SHALL also validate that every track directory contains an `intent.md`; every slug in an intent's `refs`, `research`, `assessments`, and `decisions` flow lists names an existing artifact in that category; every `superseded_by` on an intent or decision names an existing artifact of the same type other than itself; new-format handoff filename timestamps match their `captured` instants; and no more than three handoffs are active.

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

### Requirement: Spec phases separate delivered state from its check
Each spec phase SHALL use `Done:` for the delivered state an observer can see when the phase closes, and `Accept:` for the check that proves that state: a command with its expected result, or an observable procedure with its expected observation. The spec template and the spec skill SHALL state this distinction. The gate's phase field requirements SHALL NOT change.

#### Scenario: Phase distinguishes state and check
- **WHEN** the spec skill drafts a phase that adds an index column
- **THEN** `Done:` describes the column as present in generated output and `Accept:` names the command that produces the output and the expected column

#### Scenario: Existing phase shape stays valid
- **WHEN** a spec written before this change has non-empty `Done:`, `Files:`, and `Accept:` lines
- **THEN** the structure gate still passes it

### Requirement: Implement selects efficient agents from the harness
The implement skill SHALL instruct the harness to use an execution-class agent for task subagents and reserve the session-class model for planning, integration, and review. The skill SHALL NOT hardcode model names or provider-specific identifiers. Agent selection defers entirely to the harness runtime.

#### Scenario: Harness provides execution agent
- **WHEN** the implement skill spawns a subagent for a task
- **THEN** it requests an efficient execution-class agent from the harness rather than using the session model

#### Scenario: Planning stays on session model
- **WHEN** the implement skill performs integration, review, or cross-task coordination
- **THEN** it uses the session model, not the execution-class agent

### Requirement: Frontmatter uses a canonical subset
Method artifacts SHALL carry metadata in a canonical frontmatter subset, not general YAML:
- The block opens on line 1 with a line that is exactly `---`.
- The block closes at the next line that is exactly `---`.
- Each non-blank line between the delimiters is one field of the form `key: value`, where `key` starts with a lowercase letter and holds only lowercase letters, digits, and `_`. The value may be empty and stays on the same line. A flow list such as `[a, b]` is one value.
- No key appears twice in one block.

A file whose line 1 is not `---` has no frontmatter, and its required fields are reported as missing. Field extraction SHALL read only the block that opens on line 1, never a later `---` pair.

Index generation SHALL apply the subset to every artifact it reads metadata from: intents, refs, research, assessments, decisions, and active handoffs. The gate SHALL apply it to `intent.md`, and to `spec.md` and `tasks.md` when they are present. Both SHALL reject a violation with a message that names the file and the rule:
- An unclosed block.
- A duplicate key, naming the key.
- A line that is not a field, naming its line number.

Neither script SHALL depend on a YAML library.

#### Scenario: Unclosed block
- **WHEN** an intent starts with `---` and no later line is exactly `---`
- **THEN** index generation exits unsuccessfully, names the intent, states that its frontmatter is not closed, and leaves `INDEX.md` unchanged

#### Scenario: Duplicate key
- **WHEN** a research file declares `captured:` twice in its frontmatter
- **THEN** index generation exits unsuccessfully and names the file and the duplicated key `captured`

#### Scenario: Block-style list
- **WHEN** an intent frontmatter has `refs:` followed by an indented `- slug` line
- **THEN** index generation and the gate both reject the indented line as not a field and name its line number

#### Scenario: Later delimiter pair is ignored
- **WHEN** a file has no `---` on line 1 but contains a `---` pair further down
- **THEN** no field is read from that pair and the file's required fields are reported as missing

#### Scenario: Templates conform
- **WHEN** every template under `skills/fast-track-ai-*/assets/` that carries frontmatter is checked against the subset
- **THEN** each conforms
