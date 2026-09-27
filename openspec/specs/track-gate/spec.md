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
- The intent `id` differs from the track directory name.
- `plan.md` exists.
- A non-hidden root entry falls outside `intent.md`, `spec.md`, `tasks.md`, `decisions.md`, `spec`, and `assets`.
- `spec.md` or `tasks.md` is missing.

#### Scenario: Intent id mismatch
- **WHEN** `fast-track-ai/tracks/002-example/intent.md` declares `id: 003-other`
- **THEN** structure mode exits non-zero and names the mismatched id

#### Scenario: Leftover plan.md
- **WHEN** a track root contains `plan.md`
- **THEN** structure mode exits non-zero with the existing leftover `plan.md` message

### Requirement: Structure mode validates every spec phase
`spec.md` SHALL contain at least one `### Phase` section. Each phase section SHALL contain `Done:`, `Files:`, and `Accept:` lines, each followed by non-whitespace text on the same line. A label present elsewhere in the file SHALL NOT satisfy a phase that lacks it.

#### Scenario: Spec without phases
- **WHEN** `spec.md` has `Files:` and `Accept:` lines but no `### Phase` heading
- **THEN** structure mode exits non-zero and reports that the spec has no phases

#### Scenario: Second phase has an empty Accept
- **WHEN** phase 1 is complete and phase 2 contains `Accept:` with nothing after it
- **THEN** structure mode exits non-zero and names phase 2 and the empty `Accept:` field

### Requirement: Structure mode validates every task and group
A task line SHALL start with `- [ ] ` or `- [x] `. `tasks.md` SHALL contain at least one task line. Each task line SHALL contain `Files:` and `Validate:`, each followed by non-whitespace text. When `tasks.md` contains `## Group <name>` headers, the following SHALL hold:
- Group names are unique.
- Every name listed in a `(depends: <name>[, <name>])` annotation is an existing group other than the group itself.
- The dependency graph has no cycle.
- No task line appears before the first group header.

A `tasks.md` without group headers SHALL be treated as a single implicit group, so tracks shipped before groups existed remain valid.

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
- **WHEN** a shipped track's `tasks.md` has closed task lines with Files and Validate and no group headers
- **THEN** structure mode and completion mode both accept the group layout

### Requirement: Completion mode requires approval and closed tasks
After the structure checks pass, completion mode SHALL require frontmatter `status: approved` in both `spec.md` and `tasks.md` and SHALL fail while any task line is `- [ ] `. On success it SHALL print `PASS: <track> cycle intact`.

#### Scenario: Approved closed track
- **WHEN** a structurally valid track has approved spec and tasks and every task line is `- [x] `
- **THEN** the gate without `--mode` exits 0 and prints `PASS: <track> cycle intact`

#### Scenario: Open task blocks completion
- **WHEN** one task line remains `- [ ] `
- **THEN** completion mode exits non-zero and reports the open task count

#### Scenario: Shipped unified-spec tracks keep passing
- **WHEN** completion mode runs on this repository's tracks `008-unified-spec`, `009-track-terminal-states`, and `010-approval-ask-not-gate-fail`
- **THEN** each exits 0

### Requirement: Spec skill drafts against structure mode
The spec skill SHALL run the owner gate with `--mode structure` after writing `spec.md` and `tasks.md` and SHALL report any failure as breakage to fix. It SHALL NOT instruct the agent to disregard gate failures. The implement skill SHALL continue to run the gate in completion mode.

#### Scenario: Spec skill gate call
- **WHEN** an agent reads `skills/fast-track-ai-spec/SKILL.md`
- **THEN** its gate invocation includes `--mode structure` and the skill contains no instruction to ignore a draft-status or open-task gate result
