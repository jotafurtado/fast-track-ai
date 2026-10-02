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

### Requirement: Intent active is not a live written status
Live skills, command wrappers, templates, and the managed AGENTS block SHALL NOT instruct the agent to set or require intent `status: active`, and SHALL NOT contain `status: active`. New intents SHALL be written `draft` and leave `draft` only for `shipped`, `dropped`, or `superseded`.

The index SHALL keep accepting `active` only as a legacy value, so that consuming repositories with intents written by earlier package versions keep indexing. The index script and this requirement SHALL state that `active` is accepted for legacy intents only. The eval runner SHALL prove this acceptance with one dedicated legacy fixture. Every other intent fixture SHALL use `draft` or another live status.

#### Scenario: AGENTS does not say tracks leave active
- **WHEN** an agent reads the managed AGENTS block
- **THEN** it does not contain a rule that a track leaves `active` only by maintainer command

#### Scenario: Default eval fixtures use draft
- **WHEN** the live eval runner constructs a passing gate or index fixture
- **THEN** the intent status is `draft`, not `active`, unless that fixture is the dedicated legacy fixture

#### Scenario: Legacy active intent still indexes
- **WHEN** a consuming repository holds an intent with `status: active`
- **THEN** index generation accepts it and lists the track with status `active`

#### Scenario: No live surface writes active
- **WHEN** every `skills/fast-track-ai-*/SKILL.md`, every template under `skills/fast-track-ai-*/assets/`, and every `commands/fast-track-ai-*.md` file is searched
- **THEN** none contains `status: active`

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

### Requirement: Init reports non-conforming tracks and asks before normalizing
After creating or verifying the tree, the init skill SHALL check each existing track under `fast-track-ai/tracks/` with the owner gate. The gate mode follows the intent status:
- `completion` for `shipped`.
- `structure` for a track whose root holds `spec.md` or `tasks.md` and whose intent is not `shipped`, `dropped`, or `superseded`.
- No check for `dropped` or `superseded` tracks, or for a track holding only `intent.md`.

Independently of the gate result, init SHALL treat a track-root `decisions.md` as legacy and list that track as non-conforming, for every track including `dropped` and `superseded` ones.

When any track fails the gate or holds a legacy root `decisions.md`, init SHALL list each such track with its first gate message or the legacy `decisions.md` reason. It SHALL then ask the user one yes-or-no question about whether to normalize the listed tracks. Init SHALL NOT modify any track before that answer.

On yes, init SHALL rewrite each listed track to the current track contract:
- Move each root entry the gate rejects, including hidden entries, into the track's `assets/legacy/`.
- Move a root `decisions.md` to `assets/legacy/decisions.md`.
- Rewrite `spec.md` and `tasks.md` in the current template shape from their existing content.
- Rerun the gate.

A move SHALL stop and report a collision when its destination already exists. Init SHALL NOT invent a Done, Files, Accept, or Validate value, or an approval. When a value or an approval cannot be derived from existing content, init SHALL ask for it or leave that track failing and report it.

On no, init SHALL change no track and SHALL report the tracks as left non-conforming.

The check SHALL NOT depend on which package version produced a track, and SHALL NOT special-case any track ID.

#### Scenario: Conforming target
- **WHEN** init runs on a target whose checked tracks all pass the gate and no track holds a root `decisions.md`
- **THEN** init reports that the tracks conform and asks no normalization question

#### Scenario: Non-conforming track found
- **WHEN** a shipped track keeps a root `plan.md`
- **THEN** init lists that track with the gate message about `plan.md`, asks whether to normalize, and leaves the track byte-identical until the user answers

#### Scenario: Legacy root decisions file
- **WHEN** a track passes the gate but holds a root `decisions.md`
- **THEN** init lists that track as legacy in the same single question, and on yes moves the file to `assets/legacy/decisions.md` without changing its content

#### Scenario: User declines normalization
- **WHEN** the user answers no
- **THEN** no track file changes and init reports the tracks as left non-conforming

#### Scenario: Normalization cannot derive a value
- **WHEN** a legacy spec has no content from which a phase `Accept:` line can be derived
- **THEN** init asks for that value or reports the track as still failing, and writes no invented acceptance line

#### Scenario: Idempotent rerun
- **WHEN** init runs twice on the same conforming target
- **THEN** the second run changes no file and asks no question

### Requirement: Managed block states only the global contract
The managed block installed by `fast-track-ai-init` SHALL state only what an agent in a consuming repository needs before invoking a skill:
- The `fast-track-ai/` memory location, and reading `INDEX.md` first.
- The cycle order (intent, spec, implement) and the rule that no implementation happens without approved `spec.md` and `tasks.md`.
- The `.` continuation protocol.
- One line per supporting artifact type naming its location.
- The track root file rule: `intent.md`, `spec.md`, `tasks.md`, plus `assets/`.
- The intent terminal status rule.

The block SHALL NOT restate per-skill procedure owned by a skill: autonomous trigger lists, parallel-group mechanics, per-artifact field contracts, or package-internal ownership rules. The block SHALL NOT list `decisions.md` as a track-root file.

#### Scenario: Block omits skill procedure
- **WHEN** the snippet is inspected
- **THEN** it contains no `Intent autonomy`, `Tasks parallelism`, or `Each script and template has one owner skill` paragraph

#### Scenario: Block keeps the lock
- **WHEN** the snippet is inspected
- **THEN** it states that implementation requires `spec.md` and `tasks.md` with `status: approved`

#### Scenario: Block omits the root decisions file
- **WHEN** the snippet is inspected
- **THEN** it does not contain `decisions.md`

### Requirement: Skill-relative paths resolve from the installed skill
Every published `SKILL.md` SHALL state that `./` paths and `../fast-track-ai-*` sibling paths resolve from that skill's installed directory, and that `fast-track-ai/` paths resolve from the target repository root.

#### Scenario: Path rule is present in every skill
- **WHEN** each `skills/fast-track-ai-*/SKILL.md` is inspected
- **THEN** each contains the path resolution rule
