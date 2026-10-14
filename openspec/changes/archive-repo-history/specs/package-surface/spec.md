# Spec Delta

## ADDED Requirements

### Requirement: Repository history is archived outside the root
The repository SHALL NOT have a `fast-track-ai/` directory at its root. The history of how the package was first built (tracks, decisions, assessments, research, refs, and the generated index) SHALL live unchanged under `docs/archive/fast-track-ai/`. Live skills, commands, scripts, templates, and evals SHALL NOT read from that directory.

#### Scenario: Root has no method tree
- **WHEN** the repository root is listed
- **THEN** no `fast-track-ai/` entry exists, and `docs/archive/fast-track-ai/` holds the archived tracks and supporting artifacts

#### Scenario: Archived content is unchanged
- **WHEN** a file under `docs/archive/fast-track-ai/` is compared with the same file before the move
- **THEN** the content is byte-identical and only the path differs

### Requirement: README describes only the current package
The README SHALL describe the current installed behavior of the package and SHALL NOT mention retired behavior: init normalizing or checking existing tracks, `active` as an intent status, a `spec/` directory, `plan.md` as a track file, or any permissive handling of legacy artifacts. It SHALL state that `tasks.md` requires at least one `## Group` header. It SHALL list `docs/archive/` in the repository layout. It SHALL NOT mention OpenSpec.

#### Scenario: Retired wording is absent
- **WHEN** the README is searched for `normaliz`, `active`, `spec/`, `plan.md`, and `openspec` (case-insensitive)
- **THEN** none matches

#### Scenario: Group headers are stated
- **WHEN** the README section on task groups is read
- **THEN** it says that `tasks.md` requires `## Group` headers

#### Scenario: Layout lists the archive
- **WHEN** the README section on the repository layout is read
- **THEN** it lists `docs/archive/` as frozen history

### Requirement: AGENTS describes the repository's own layout
The repository `AGENTS.md` SHALL list `openspec/` (package specs and change history) and `docs/archive/` (frozen history) in its Map. It SHALL NOT describe a root `fast-track-ai/` tree. It SHALL keep the rule that `fast-track-ai-init` is never run in this repository.

#### Scenario: Map lists the new directories
- **WHEN** `AGENTS.md` is inspected
- **THEN** its Map names `openspec/` and `docs/archive/`

#### Scenario: Init is still not run here
- **WHEN** `AGENTS.md` is inspected
- **THEN** it still states that `fast-track-ai-init` is never run in this repository and no longer calls a root `fast-track-ai/` tree a read-only archive

## MODIFIED Requirements

### Requirement: Eval suite is self-contained
The executable eval runner SHALL live at `evals/run-evals.sh`, with its selector table at `evals/evals.md`. Every selector SHALL read only published package files (`skills/`, `commands/`, `install.sh`, `AGENTS.md`, `README.md`) and fixtures it creates under a temporary directory. No selector SHALL read, gate, or assert content from the archived history under `docs/archive/fast-track-ai/`. The runner SHALL NOT expose an `audit` or `contract` selector.

#### Scenario: Runner passes without the legacy tree
- **WHEN** `evals/run-evals.sh all` runs in a copy of the repository that contains neither `docs/` nor a root `fast-track-ai/`
- **THEN** every selector passes and the runner prints `PASS: all evals`

#### Scenario: Retired selectors are rejected
- **WHEN** `evals/run-evals.sh audit` or `evals/run-evals.sh contract` runs
- **THEN** the runner exits non-zero and reports an unknown eval

#### Scenario: No selector references the legacy tree
- **WHEN** the runner source is searched for paths under `docs/archive/fast-track-ai/` or a root `fast-track-ai/` directory
- **THEN** no match is found outside fixture paths built under the temporary work directory
