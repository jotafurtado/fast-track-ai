# Package Surface

## Purpose

Governs live package copy, installer command links, INDEX terminal state for completed tracks, and eval coverage so published skills match the continuous-flow description without leftover Spec Kit or unused lifecycle language.

## Requirements

### Requirement: Live package copy does not mention Spec Kit
Live skills, command wrappers, templates, AGENTS house rules, the managed AGENTS block, the live evals table, and the skill-package contract SHALL describe the current cycle without naming Spec Kit, Speckit, speckit, or `.specify`. Init SHALL still omit `specs/` and `.specify/` from the created tree; that omission is verified by evals, not by user-facing copy.

#### Scenario: Spec template has no Spec Kit sentence
- **WHEN** an agent copies `skills/fast-track-ai-spec/assets/spec.md` into a new track
- **THEN** the template does not contain "Spec Kit" or equivalent

#### Scenario: Init skill does not advertise Spec Kit absence
- **WHEN** an agent reads the init skill or init command
- **THEN** those files do not mention Spec Kit, speckit, or `.specify`

#### Scenario: Init still creates only the method tree
- **WHEN** init runs on an empty target
- **THEN** the target has no `specs/` directory and no `.specify/` tree, and the eval that asserts that fact does not require the skill text to name those paths

### Requirement: Explicit actions are first-class exits
The managed AGENTS block SHALL NOT say that every request must become `intent.md` with no exceptions. Assess, research, and handoff SHALL remain valid stops after their artifact and index regeneration, without drafting an intent.

#### Scenario: Assessment request does not require an intent
- **WHEN** the user asks only to assess the project
- **THEN** the assess skill writes the assessment, regenerates INDEX, and stops without creating a track intent

#### Scenario: Managed block names the exits
- **WHEN** an agent reads the managed AGENTS block
- **THEN** it can tell that research, assess, and handoff may complete without an intent, and that implementation still requires approved `spec.md` and `tasks.md`

### Requirement: Live evals cover the continuous-flow protocol
The executable eval runner at `evals/run-evals.sh` SHALL include a selector that fails unless the published intent, spec, and implement skills plus the tasks template contain the continuous-flow protocol strings: `. para continuar com a spec`, `. para implementar`, `. para ship`, `## Group`, and `(depends:`. The same selector SHALL fail if the intent skill contains the retired line `Track concluida. Nenhuma implementacao necessaria.`.

#### Scenario: Flow selector passes on the live package
- **WHEN** `run-evals.sh flow` runs against the repository
- **THEN** it exits 0 after asserting those strings in the owner skills and tasks template and the absence of the retired line

#### Scenario: Missing next-step line fails
- **WHEN** the intent skill no longer contains `. para continuar com a spec`
- **THEN** the flow selector exits non-zero

#### Scenario: Retired exit line reappears
- **WHEN** the intent skill contains `Track concluida. Nenhuma implementacao necessaria.`
- **THEN** the flow selector exits non-zero

### Requirement: Init refreshes the managed AGENTS block
`fast-track-ai-init.sh` SHALL create `AGENTS.md` from the snippet when the file is absent and append the snippet when the file exists without managed-block markers. When the file contains exactly one `BEGIN MANAGED BLOCK: fast-track-ai` line followed later by exactly one `END MANAGED BLOCK: fast-track-ai` line, init SHALL replace those lines and everything between them with the current snippet. It SHALL preserve every byte outside the block, avoid writing the file when the result is identical, and fail without writing `AGENTS.md` or creating any other file when the markers are duplicated, unclosed, or out of order.

#### Scenario: Outdated block is refreshed
- **WHEN** `AGENTS.md` contains user text, then a managed block whose body differs from the current snippet, then more user text
- **THEN** init replaces only the block with the current snippet and both user sections remain byte-identical

#### Scenario: Current block is left alone
- **WHEN** init runs twice on a target whose block already matches the snippet
- **THEN** `AGENTS.md` is byte-identical after the second run and contains exactly one managed block

#### Scenario: Begin marker without end marker
- **WHEN** `AGENTS.md` contains a `BEGIN MANAGED BLOCK: fast-track-ai` line and no matching end line
- **THEN** init exits unsuccessfully, names the malformed markers, and `AGENTS.md` is unchanged

#### Scenario: Duplicated block
- **WHEN** `AGENTS.md` contains two managed blocks
- **THEN** init exits unsuccessfully, names the duplicated markers, and `AGENTS.md` is unchanged

#### Scenario: Symlinked AGENTS file
- **WHEN** `AGENTS.md` is a symlink to another file and its block is outdated
- **THEN** init updates the link target's content and `AGENTS.md` remains a symlink

### Requirement: Eval suite is self-contained
The executable eval runner SHALL live at `evals/run-evals.sh`, with its selector table at `evals/evals.md`. Every selector SHALL read only published package files (`skills/`, `commands/`, `install.sh`, `AGENTS.md`) and fixtures it creates under a temporary directory. No selector SHALL read, gate, or assert content from the repository's own `fast-track-ai/` tree. The runner SHALL NOT expose an `audit` or `contract` selector.

#### Scenario: Runner passes without the legacy tree
- **WHEN** `evals/run-evals.sh all` runs in a copy of the repository from which `fast-track-ai/` has been removed
- **THEN** every selector passes and the runner prints `PASS: all evals`

#### Scenario: Retired selectors are rejected
- **WHEN** `evals/run-evals.sh audit` or `evals/run-evals.sh contract` runs
- **THEN** the runner exits non-zero and reports an unknown eval

#### Scenario: No selector references the legacy tree
- **WHEN** the runner source is searched for paths under the repository's `fast-track-ai/` directory
- **THEN** no match is found outside fixture paths built under the temporary work directory

### Requirement: Managed block states only the global contract
The managed block installed by `fast-track-ai-init` SHALL state only what an agent in a consuming repository needs before invoking a skill:
- The `fast-track-ai/` memory location, and reading `INDEX.md` first.
- The cycle order (intent, spec, implement) and the rule that no implementation happens without approved `spec.md` and `tasks.md`.
- The `.` continuation protocol.
- One line per supporting artifact type naming its location.
- The track root file rule: `intent.md`, `spec.md`, `tasks.md`, plus `assets/`.
- The intent terminal status rule.

The block SHALL NOT restate per-skill procedure owned by a skill: autonomous trigger lists, parallel-group mechanics, per-artifact field contracts, or package-internal ownership rules. The block SHALL NOT name retired track files: `decisions.md`, `plan.md`, or a `spec/` directory.

#### Scenario: Block omits skill procedure
- **WHEN** the snippet is inspected
- **THEN** it contains no `Intent autonomy`, `Tasks parallelism`, or `Each script and template has one owner skill` paragraph

#### Scenario: Block keeps the lock
- **WHEN** the snippet is inspected
- **THEN** it states that implementation requires `spec.md` and `tasks.md` with `status: approved`

#### Scenario: Block omits the root decisions file
- **WHEN** the snippet is inspected
- **THEN** it does not contain `decisions.md`, `plan.md`, or `spec/`

### Requirement: Skill-relative paths resolve from the installed skill
Every published `SKILL.md` SHALL state that `./` paths and `../fast-track-ai-*` sibling paths resolve from that skill's installed directory, and that `fast-track-ai/` paths resolve from the target repository root.

#### Scenario: Path rule is present in every skill
- **WHEN** each `skills/fast-track-ai-*/SKILL.md` is inspected
- **THEN** each contains the path resolution rule

### Requirement: Intent status enum excludes active
Live skills, command wrappers, templates, and the managed AGENTS block SHALL NOT instruct the agent to set or require intent `status: active`, and SHALL NOT contain `status: active`. New intents SHALL be written `draft` and leave `draft` only for `shipped`, `dropped`, or `superseded`. Index generation SHALL accept only `draft`, `shipped`, `dropped`, and `superseded` as intent statuses and SHALL reject `active` like any other unknown value.

#### Scenario: Active intent is rejected
- **WHEN** a repository holds an intent with `status: active`
- **THEN** index generation exits unsuccessfully, names the track and `invalid status: active`, and leaves `INDEX.md` unchanged

#### Scenario: No live surface writes active
- **WHEN** every `skills/fast-track-ai-*/SKILL.md`, every template under `skills/fast-track-ai-*/assets/`, and every `commands/fast-track-ai-*.md` file is searched
- **THEN** none contains `status: active`

### Requirement: Init installs without migrating existing tracks
The init skill SHALL create or verify the `fast-track-ai/` tree, refresh the managed block, and run the index. It SHALL NOT inspect, gate, normalize, or move content inside existing tracks, and SHALL NOT ask a normalization question. The init skill and command SHALL NOT mention `assets/legacy/` or track normalization.

#### Scenario: Target with existing tracks
- **WHEN** init runs on a target whose `fast-track-ai/tracks/` already holds a track with a root `plan.md`
- **THEN** init changes no file inside that track and asks no question, and a later gate run reports the track as failing

#### Scenario: Skill text has no migration step
- **WHEN** `skills/fast-track-ai-init/SKILL.md` and `commands/fast-track-ai-init.md` are inspected
- **THEN** neither contains `assets/legacy/`, `normalize`, or a yes-or-no conformance question
