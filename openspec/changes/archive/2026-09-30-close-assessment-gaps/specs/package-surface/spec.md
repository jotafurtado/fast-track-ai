## ADDED Requirements

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

When any checked track fails, init SHALL list each failing track with its first gate message, then ask the user one yes-or-no question about whether to normalize the listed tracks. Init SHALL NOT modify any track before that answer.

On yes, init SHALL rewrite each listed track to the current track contract:
- Move the files the gate rejects into the track's `assets/`.
- Rewrite `spec.md` and `tasks.md` in the current template shape from their existing content.
- Rerun the gate.

Init SHALL NOT invent a Done, Files, Accept, or Validate value, or an approval. When a value or an approval cannot be derived from existing content, init SHALL ask for it or leave that track failing and report it.

On no, init SHALL change no track and SHALL report the tracks as left non-conforming.

The check SHALL NOT depend on which package version produced a track, and SHALL NOT special-case any track ID.

#### Scenario: Conforming target
- **WHEN** init runs on a target whose checked tracks all pass the gate
- **THEN** init reports that the tracks conform and asks no normalization question

#### Scenario: Non-conforming track found
- **WHEN** a shipped track keeps a root `plan.md`
- **THEN** init lists that track with the gate message about `plan.md`, asks whether to normalize, and leaves the track byte-identical until the user answers

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
- The track root file rule.
- The intent terminal status rule.

The block SHALL NOT restate per-skill procedure owned by a skill: autonomous trigger lists, parallel-group mechanics, per-artifact field contracts, or package-internal ownership rules.

#### Scenario: Block omits skill procedure
- **WHEN** the snippet is inspected
- **THEN** it contains no `Intent autonomy`, `Tasks parallelism`, or `Each script and template has one owner skill` paragraph

#### Scenario: Block keeps the lock
- **WHEN** the snippet is inspected
- **THEN** it states that implementation requires `spec.md` and `tasks.md` with `status: approved`

### Requirement: Skill-relative paths resolve from the installed skill
Every published `SKILL.md` SHALL state that `./` paths and `../fast-track-ai-*` sibling paths resolve from that skill's installed directory, and that `fast-track-ai/` paths resolve from the target repository root.

#### Scenario: Path rule is present in every skill
- **WHEN** each `skills/fast-track-ai-*/SKILL.md` is inspected
- **THEN** each contains the path resolution rule

## MODIFIED Requirements

### Requirement: Live evals cover the continuous-flow protocol
The executable eval runner at `evals/run-evals.sh` SHALL include a selector that fails unless the published intent, spec, and implement skills plus the tasks template contain the continuous-flow protocol strings: `. para continuar com a spec`, `. para implementar`, `. para ship`, `## Group`, and `(depends:`. The same selector SHALL fail if the intent skill contains the retired line `Track concluida. Nenhuma implementacao necessaria.`.

#### Scenario: Flow selector passes on the live package
- **WHEN** `evals/run-evals.sh flow` runs against the repository
- **THEN** it exits 0 after asserting those strings in the owner skills and tasks template and the absence of the retired line

#### Scenario: Missing next-step line fails
- **WHEN** the intent skill no longer contains `. para continuar com a spec`
- **THEN** the flow selector exits non-zero

#### Scenario: Retired exit line reappears
- **WHEN** the intent skill contains `Track concluida. Nenhuma implementacao necessaria.`
- **THEN** the flow selector exits non-zero

## REMOVED Requirements

### Requirement: Track 010 is shipped
**Reason**: It asserts data in the repository's legacy `fast-track-ai/` tree, which is no longer part of the package or its tests.
**Migration**: None. The archived track keeps its current content; no eval or index run over the repository checks it.
