## MODIFIED Requirements

### Requirement: Structure mode validates the track root
Structure mode SHALL fail when:
- `intent.md` is missing.
- `intent.md`, or a present `spec.md` or `tasks.md`, has frontmatter that violates the canonical subset defined by the `method-artifacts` capability.
- The intent `id` differs from the track directory name.
- `plan.md` exists.
- A root entry whose name starts with `.` exists. `.` and `..` are not entries.
- A root entry falls outside `intent.md`, `spec.md`, `tasks.md`, `decisions.md`, `spec`, and `assets`.
- `intent.md`, `spec.md`, `tasks.md`, or `decisions.md` exists and is not a regular file.
- `spec` or `assets` exists and is not a directory.
- `spec.md` or `tasks.md` is missing.

`decisions.md` at the track root is accepted only for tracks created before it was retired from the contract. No live template or managed block lists it.

Each failure SHALL print one `FAIL:` line that names the offending entry or file and the violated rule.

#### Scenario: Intent id mismatch
- **WHEN** `fast-track-ai/tracks/002-example/intent.md` declares `id: 003-other`
- **THEN** structure mode exits non-zero and names the mismatched id

#### Scenario: Leftover plan.md
- **WHEN** a track root contains `plan.md`
- **THEN** structure mode exits non-zero with the existing leftover `plan.md` message

#### Scenario: Hidden root entry
- **WHEN** a track root contains `.notes` or `.DS_Store`, and the track is otherwise valid
- **THEN** structure mode exits non-zero and names the hidden entry

#### Scenario: Allowed name with the wrong type
- **WHEN** a track root contains `assets` as a regular file, or `spec.md` as a directory
- **THEN** structure mode exits non-zero and states that the entry must be a directory, or a file, respectively

#### Scenario: Legacy root decisions file
- **WHEN** an otherwise valid track root contains a regular file `decisions.md`
- **THEN** structure mode passes

#### Scenario: Duplicate field in spec frontmatter
- **WHEN** `spec.md` frontmatter declares `status:` twice
- **THEN** structure mode exits non-zero and names `spec.md` and the duplicated key `status`

#### Scenario: Unclosed intent frontmatter
- **WHEN** `intent.md` starts with `---` and has no closing `---` line
- **THEN** structure mode exits non-zero and states that the `intent.md` frontmatter is not closed
