# Proposal

## Why

After `harden-method-scripts` and `fix-skill-procedure-contracts`, the 2026-09-21 assessments still have open items that those changes deferred. The package is the set of skills (`skills/`, `commands/`, `install.sh`). The repository's own `fast-track-ai/` tree is a legacy dogfooding history that is no longer used, yet the only eval runner lives inside it. Four selectors also read its artifacts, and `AGENTS.md` still carries the method's managed block. As long as that holds, package tests depend on archive content, and the repository instructs agents to work in a tree the maintainer abandoned.

## What Changes

- **Eval suite leaves the legacy tree.** The runner and its selector table move to `evals/` at the repository root and read only package files plus `/tmp` fixtures. **BREAKING** (maintainer workflow): the documented eval command changes path.
  - The `audit` selector (six retired `dot-ai-*` skills) and the `contract` selector (a legacy track document) are removed.
  - `approval` no longer gates the repository's shipped tracks.
  - `workflows` no longer reads `fast-track-ai/research/artifact-standards.md`.
  - `decisions` no longer reads ADR 007.
- **Repository `AGENTS.md` drops the managed block** and documents the new eval path and command links in Map and Install.
- **README stops drifting.** The retired `Track concluida...` line and its paragraph, the old handoff filename format, and the mentions of `openspec/` and of the repository `fast-track-ai/` tree as live memory are removed.
- **The `fast-track-ai/` tree stays as an untouched archive.** It is not deleted, normalized, or referenced by any live file.
- **Init reports non-conforming tracks and asks before normalizing.**
  - When the target already has tracks, init runs the owner gate against each track in the mode its intent status implies and lists those that fail.
  - It asks once whether to normalize them. Only on a yes does it rewrite them to the current contract, preserving the prior content under the track's `assets/`.
  - The rules are generic: nothing names a package version or a specific track.
- **Intent** triggers research when a decision depends on an unverified external fact (not on unfamiliarity), and records `Assumed state` by provenance: stated by the user, unverified assumption, access limit.
- **Ref template** keeps only the section for the chosen type. Its `## Contract` block moves into the intent skill, which then owns every capture rule.
- **Spec template** defines `Done` (the delivered, observable state) and `Accept` (the check that proves it). Each task names its phase. `Validate` means a command or an observable procedure with its expected result. The gate does not change.
- **ADRs** keep evidence only in the `## Evidence` body section. The spec skill documents replacement: create the new ADR, set the old one to `superseded` with `superseded_by`, and keep its decision text.
- **Implement**:
  - It delegates to subagents only tasks that warrant it, runs trivial tasks directly, and defers global checks until a group's agents finish.
  - On resume it continues from the first open task without rerunning verified ones.
  - When an unverified assumption proves false, it records the divergence and stops before changing the solution.
- **Research and assess**:
  - Both stop instead of silently overwriting an existing slug or same-day file.
  - Research records an inconclusive result as inconclusive.
  - Assessment findings state problem, evidence, consequence, and recommendation, with priority derived from consequence.
  - The assessment `tracks:` field lists the evaluated track IDs or `[]`.
- **Handoff** replaces P0, P1, and First next action with one ordered `## Next actions` list. The index accepts both the new and the legacy heading sets.
- **The managed block** shrinks to the global contract a consuming repository needs. Detail stays in the owner skills.
- **Every skill** states that `./` and `../fast-track-ai-*` paths resolve from the installed skill directory, never from the target repository.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `package-surface`:
  - The track 010 requirement is removed.
  - The flow-eval requirement points at the relocated runner.
  - New requirements: a self-contained eval suite, init conformance reporting with consent-gated normalization, a lean managed block, and skill-relative path resolution.
- `continuous-flow`: The research trigger depends on evidence need. New requirement: intent records assumed state by provenance.
- `method-artifacts`:
  - Research, assessment, ref, decision, and handoff requirements change as listed above.
  - Tasks carry a phase tag and a defined Validate.
  - New requirement: spec phases separate the delivered state from its check.
- `implement-workflow`: New requirements for proportional delegation, resume, and assumption divergence.

## Impact

- **Skills:** all seven `skills/fast-track-ai-*/SKILL.md` files.
- **Templates:** `intent.md`, `ref.md`, `spec.md`, `tasks.md`, `decisions.md`, `assessment.md`, `handoff.md`, and `AGENTS-snippet.md`.
- **Scripts:** `fast-track-ai-index.sh`, where handoff heading validation accepts both heading sets. The gate and the init script do not change.
- **Commands:** `commands/fast-track-ai-init.md` and `commands/fast-track-ai-handoff.md`.
- **Evals:** `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh` and `spec/evals.md` move to `evals/run-evals.sh` and `evals/evals.md`.
- **Repository docs:** `AGENTS.md` and `README.md`.
- **Not in scope:**
  - Agent-driven behavioral evals (delivery-quality 2).
  - Assessment items 1.3 (`active` stays accepted), 1.5 (frontmatter subset), 3.2 (hidden or mistyped root entries), 4.8 (code-review provenance), 7.3 (archive-then-validate order), and 8.2 (`decisions.md` at the track root).
  - Deleting or editing anything under the repository's `fast-track-ai/` tree beyond moving the two eval files out of it.
  - Global harness links created by `install.sh`.
