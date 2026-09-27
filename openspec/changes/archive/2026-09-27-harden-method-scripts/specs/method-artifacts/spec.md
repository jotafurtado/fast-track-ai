# Spec Delta

## MODIFIED Requirements

### Requirement: Refs preserve immutable source inputs
A user-supplied source that materially grounds an intent SHALL be captured under `fast-track-ai/refs/<slug>.md` before the intent cites it. Each ref SHALL declare `type`, `captured`, `owner`, `sha256`, and `content_license`. The whole ref file, including frontmatter, headings, and notes, SHALL be no larger than 500 KB. A ref SHALL remain immutable except by creating a new ref for changed source content.

#### Scenario: Small redistributable text must remain available offline
- **WHEN** exact source text is needed, the resulting ref file is at most 500 KB, and the license permits storage in the repository
- **THEN** the method creates an `inline` ref containing the durable text

#### Scenario: Inline ref file exceeds the limit
- **WHEN** the source text fits in 500 KB but the ref file with its frontmatter and headings exceeds 500 KB
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

### Requirement: Ref hashes identify captured content
The `sha256` field SHALL identify the captured source representation, never merely its URL, file path, or descriptive stub. Pointer refs SHALL hash the source payload observed at capture time.

Inline refs SHALL hash the normalized stored source text. That text is every line after the `## Source content` heading, with these rules:
- Exactly one blank separator line directly after the heading is excluded when present.
- Carriage returns are removed.
- Each line ends with one LF.

The first source line SHALL be included whether or not a separator line is present.

#### Scenario: Duplicate source content is supplied
- **WHEN** newly supplied source content has the same hash as an existing ref
- **THEN** the method reuses the existing ref instead of creating a duplicate under another slug

#### Scenario: Pointer target changes
- **WHEN** a mutable pointer target later produces different content
- **THEN** the existing ref remains unchanged and a new ref is required to represent the new source state

#### Scenario: Inline content starts directly after the heading
- **WHEN** an inline ref has its first source line immediately after `## Source content` with no blank line, and `sha256` is the hash of all source lines
- **THEN** index generation accepts the hash

#### Scenario: Inline content follows a separator line
- **WHEN** an inline ref has one blank line after `## Source content` and `sha256` is the hash of the lines after that blank line
- **THEN** index generation accepts the hash

### Requirement: Handoffs transfer portable working context
A handoff action SHALL write directly to `fast-track-ai/handoffs/<timestamp>-<slug>.md`, preserve the user's exact active instructions, summarize objective and current state, identify completed work and P0/P1 next actions, list relevant paths and observed command results, disclose blockers and risks, and name the first concrete next step. It SHALL reference durable artifacts by path instead of duplicating them and SHALL omit secrets and unnecessary personal data.

Naming and ordering SHALL follow these rules:
- New handoffs SHALL use a UTC timestamp with seconds: filename prefix `YYYY-MM-DD-HHmmssZ` and `captured: YYYY-MM-DDTHH:MM:SSZ`, both naming the same instant.
- The legacy `YYYY-MM-DD-HHmm-OFFSET` filenames SHALL remain valid.
- Active handoffs SHALL be ordered by the instant in `captured`, never by filename text.
- The action SHALL NOT overwrite an existing handoff in either the active directory or the archive.

#### Scenario: Session changes agent or harness
- **WHEN** a user requests a handoff
- **THEN** the next agent can identify the objective, constraints, verified state, and immediate next action from the handoff without relying on conversation history

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

### Requirement: Index discovers and validates all artifact types
The generated `fast-track-ai/INDEX.md` SHALL list tracks plus active refs, research, assessments, decisions, and handoffs in deterministic order. Active handoffs SHALL be listed by ascending `captured` instant.

Index generation SHALL validate each artifact's required metadata, filename rules, permitted lifecycle fields, size constraints, and type-specific invariants. It SHALL also validate cross-artifact integrity:
- Every directory under `tracks/` has an `intent.md`.
- Every slug in an intent's `refs`, `research`, `assessments`, and `decisions` lists names an existing artifact in that category.
- Every `superseded_by` on an intent or decision names an existing artifact of the same type other than itself.
- A new-format handoff filename timestamp equals its `captured` instant.
- No more than three handoffs are active.

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
