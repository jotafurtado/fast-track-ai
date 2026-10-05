# Spec Delta

## ADDED Requirements

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

## MODIFIED Requirements

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

## REMOVED Requirements

### Requirement: Intent active is not a live written status
**Reason**: It kept `active` as an accepted legacy status. Backward compatibility is dropped, and "Intent status enum excludes active" replaces it.
**Migration**: Change any `status: active` intent to `draft`, or to its terminal status, before running the index.

### Requirement: Init reports non-conforming tracks and asks before normalizing
**Reason**: The conformance pass existed only to migrate tracks from earlier package versions. Backward compatibility is dropped.
**Migration**: Fix failing tracks by hand using the gate messages. Move retired root files such as `plan.md`, `decisions.md`, or `spec/` under the track's `assets/`, or delete them.
