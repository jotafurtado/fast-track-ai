# Track Gate Specification

## Purpose

Defines how `fast-track-ai-gate.sh` validates a track: a structure mode that checks documents, fields, and task groups for drafting, and a completion mode that additionally requires approval and closed tasks before a track can close.

## Requirements

### Requirement: Gate runs in an explicit mode
The gate SHALL accept `--mode structure` or `--mode completion`. When `--mode` is omitted the gate SHALL run in completion mode. Any other mode value SHALL fail with an objective message naming the accepted values. Structure mode SHALL NOT inspect approval status or checkbox state. Completion mode SHALL run every structure check and then the completion checks.

#### Scenario: Draft track passes structure mode
- **WHEN** a track has a structurally valid `intent.md`, `spec.md`, and `tasks.md`, both planning files are `status: draft`, and its tasks are open
- **THEN** `fast-track-ai-gate.sh --mode structure --track <id>` exits 0

#### Scenario: Same draft track fails completion mode
- **WHEN** the gate runs on that same track without `--mode`
- **THEN** it exits non-zero and names the unapproved file

#### Scenario: Unknown mode
- **WHEN** the gate runs with `--mode draft`
- **THEN** it exits non-zero and names `structure` and `completion` as the accepted modes

### Requirement: Structure mode validates the track root
Structure mode SHALL fail when:
- `intent.md` is missing.
- `intent.md`, or a present `spec.md` or `tasks.md`, has frontmatter that violates the canonical subset defined by the `method-artifacts` capability.
- The intent `id` differs from the track directory name.
- A root entry whose name starts with `.` exists. `.` and `..` are not entries.
- A root entry falls outside `intent.md`, `spec.md`, `tasks.md`, and `assets`.
- `intent.md`, `spec.md`, or `tasks.md` exists and is not a regular file.
- `assets` exists and is not a directory.
- `spec.md` or `tasks.md` is missing.

Retired entries such as `plan.md`, `decisions.md`, or a `spec/` directory SHALL fail under the unexpected-entry rule, with no dedicated message.

Each failure SHALL print one `FAIL:` line that names the offending entry or file and the violated rule.

#### Scenario: Intent id mismatch
- **WHEN** `fast-track-ai/tracks/002-example/intent.md` declares `id: 003-other`
- **THEN** structure mode exits non-zero and names the mismatched id

#### Scenario: Leftover plan.md
- **WHEN** an otherwise valid track root contains `plan.md`
- **THEN** structure mode exits non-zero and names `plan.md` as an entry outside the allowed set

#### Scenario: Hidden root entry
- **WHEN** a track root contains `.notes` or `.DS_Store`, and the track is otherwise valid
- **THEN** structure mode exits non-zero and names the hidden entry

#### Scenario: Allowed name with the wrong type
- **WHEN** a track root contains `assets` as a regular file, or `spec.md` as a directory
- **THEN** structure mode exits non-zero and states that the entry must be a directory, or a file, respectively

#### Scenario: Legacy root decisions file
- **WHEN** an otherwise valid track root contains a regular file `decisions.md`
- **THEN** structure mode exits non-zero and names `decisions.md` as an entry outside the allowed set

#### Scenario: Retired spec directory
- **WHEN** an otherwise valid track root contains a `spec/` directory
- **THEN** structure mode exits non-zero and names `spec` as an entry outside the allowed set

#### Scenario: Duplicate field in spec frontmatter
- **WHEN** `spec.md` frontmatter declares `status:` twice
- **THEN** structure mode exits non-zero and names `spec.md` and the duplicated key `status`

#### Scenario: Unclosed intent frontmatter
- **WHEN** `intent.md` starts with `---` and has no closing `---` line
- **THEN** structure mode exits non-zero and states that the `intent.md` frontmatter is not closed

### Requirement: Structure mode validates every spec phase
`spec.md` SHALL contain at least one `### Phase` section. Each phase section SHALL contain `Done:`, `Files:`, and `Accept:` lines, each followed by non-whitespace text on the same line. A label present elsewhere in the file SHALL NOT satisfy a phase that lacks it.

#### Scenario: Spec without phases
- **WHEN** `spec.md` has `Files:` and `Accept:` lines but no `### Phase` heading
- **THEN** structure mode exits non-zero and reports that the spec has no phases

#### Scenario: Second phase has an empty Accept
- **WHEN** phase 1 is complete and phase 2 contains `Accept:` with nothing after it
- **THEN** structure mode exits non-zero and names phase 2 and the empty `Accept:` field

### Requirement: Structure mode validates every task and group
A task line SHALL start with `- [ ] ` or `- [x] `. `tasks.md` SHALL contain at least one task line and at least one `## Group <name>` header, and the following SHALL hold:
- Each task line contains `Files:` and `Validate:`, each followed by non-whitespace text.
- No task line appears before the first group header.
- Group names are unique.
- Every name listed in a `(depends: <name>[, <name>])` annotation is an existing group other than the group itself.
- The dependency graph has no cycle.

#### Scenario: Tasks file without tasks
- **WHEN** `tasks.md` contains `Files:` and `Validate:` text but no task line
- **THEN** structure mode exits non-zero and reports that there are no tasks

#### Scenario: Second task without Validate
- **WHEN** the first task line has `Files:` and `Validate:` and the second task line has only `Files:`
- **THEN** structure mode exits non-zero and identifies the second task's line number and the missing `Validate:`

#### Scenario: Dependency on a missing group
- **WHEN** a header reads `## Group B (depends: C)` and no group `C` exists
- **THEN** structure mode exits non-zero and names group `B` and the unknown dependency `C`

#### Scenario: Circular dependency
- **WHEN** group `A` depends on `B` and group `B` depends on `A`
- **THEN** structure mode exits non-zero and reports a dependency cycle involving `A` and `B`

#### Scenario: Legacy tasks without groups
- **WHEN** `tasks.md` has valid task lines with Files and Validate and no `## Group` header
- **THEN** structure mode and completion mode both exit non-zero and report that `tasks.md` has no group header

#### Scenario: Single-task group
- **WHEN** `tasks.md` has one `## Group A` header followed by one valid task line
- **THEN** structure mode accepts the group layout

### Requirement: Completion mode requires approval and closed tasks
After the structure checks pass, completion mode SHALL require frontmatter `status: approved` in both `spec.md` and `tasks.md` and SHALL fail while any task line is `- [ ] `. On success it SHALL print `PASS: <track> cycle intact`.

#### Scenario: Approved closed track
- **WHEN** a structurally valid track has approved spec and tasks and every task line is `- [x] `
- **THEN** the gate without `--mode` exits 0 and prints `PASS: <track> cycle intact`

#### Scenario: Open task blocks completion
- **WHEN** one task line remains `- [ ] `
- **THEN** completion mode exits non-zero and reports the open task count

#### Scenario: Shipped unified-spec tracks keep passing
- **WHEN** completion mode runs on a scratch track whose `spec.md` and `tasks.md` are filled from the current package templates, approved, and closed
- **THEN** it exits 0, and no gate scenario depends on tracks stored in this repository

### Requirement: Spec skill drafts against structure mode
The spec skill SHALL run the owner gate with `--mode structure` after writing `spec.md` and `tasks.md` and SHALL report any failure as breakage to fix. It SHALL NOT instruct the agent to disregard gate failures. The implement skill SHALL continue to run the gate in completion mode.

#### Scenario: Spec skill gate call
- **WHEN** an agent reads `skills/fast-track-ai-spec/SKILL.md`
- **THEN** its gate invocation includes `--mode structure` and the skill contains no instruction to ignore a draft-status or open-task gate result
