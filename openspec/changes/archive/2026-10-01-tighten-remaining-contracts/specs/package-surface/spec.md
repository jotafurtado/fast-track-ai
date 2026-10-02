## MODIFIED Requirements

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
