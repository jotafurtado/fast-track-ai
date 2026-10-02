## ADDED Requirements

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

## MODIFIED Requirements

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
