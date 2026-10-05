# Proposal

## Why

Several earlier changes kept the method working for tracks and handoffs written by older package versions. The scripts, the init skill, and the OpenSpec specs therefore carry a second, legacy contract next to the live one:
- The index accepts `active`, minute-and-offset handoff names, and P0/P1 handoff headings.
- The gate accepts a root `decisions.md`, a `spec/` directory, and `tasks.md` without groups.
- Init runs a conformance and normalization pass whose only purpose is migrating old tracks.

The maintainer has dropped backward compatibility. Keeping two contracts makes every skill, script, spec, and eval longer and lets agents read the legacy contract as a valid choice.

## What Changes

**BREAKING** for consuming repositories: artifacts written in a legacy shape now fail the index or the gate with an objective message. No migration path is provided.

- **Index:**
  - The intent `status` enum is `draft | shipped | dropped | superseded`, and `active` fails.
  - Handoff filenames must be `YYYY-MM-DD-HHmmssZ-<slug>.md`, and `captured` must be `YYYY-MM-DDTHH:MM:SSZ`. Offset timestamps and minute-precision names fail.
  - Handoffs must have `## Next actions`. The P0/P1/First-next-action set fails.
- **Gate:**
  - The only allowed track-root entries are `intent.md`, `spec.md`, `tasks.md`, and `assets/`. A root `decisions.md` or `spec/` fails as an unexpected entry.
  - `plan.md` loses its dedicated message and fails under the same unexpected-entry rule.
  - `tasks.md` must contain at least one `## Group` header, and no task may come before the first header. The implicit single-group fallback is removed.
- **Init:** the existing-track conformance check and the consent-gated normalization (step 4, `assets/legacy/`) are removed. Init creates the tree, refreshes the managed block, and runs the index.
- **Skills, commands, templates, managed snippet:** remove the leftover-`spec/`, `plan.md`, and legacy wording. The track-root rule is stated once, positively.
- **Specs:** requirements and scenarios that only protect legacy input are removed or rewritten, and new scenarios assert that legacy input fails.
- **Evals:** remove the legacy fixtures and the dedicated `active` acceptance fixture. Convert fixtures to the live format: grouped tasks, UTC handoffs, `## Next actions`. Add assertions that each legacy shape now fails.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `track-gate`: Track root accepts only the four live entries, and task groups are mandatory.
- `method-artifacts`:
  - Handoffs accept only the UTC-seconds name and `## Next actions`.
  - The index requirement drops the "new-format" qualifier.
  - Handoff ordering scenarios use UTC.
- `package-surface`:
  - `active` is rejected by the index.
  - The init conformance and normalization requirement is removed.
  - The managed block requirement no longer mentions retired files.

## Impact

- **Scripts:** `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh` and `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`.
- **Skills:** `skills/fast-track-ai-init/SKILL.md`, `skills/fast-track-ai-spec/SKILL.md`, `skills/fast-track-ai-implement/SKILL.md`.
- **Templates and snippet:** `skills/fast-track-ai-spec/assets/spec.md`, `skills/fast-track-ai-init/assets/AGENTS-snippet.md`.
- **Commands:** `commands/fast-track-ai-init.md`, `commands/fast-track-ai-spec.md`, `commands/fast-track-ai-implement.md`.
- **Evals:** `evals/run-evals.sh` and `evals/evals.md`. The agent-eval fixtures already use grouped tasks and need no change.
- **Not in scope:**
  - Moving the repository's `fast-track-ai/` tree to `docs/archive/`, the repository `AGENTS.md` rules, and the README rewrite. Those belong to the follow-up change `archive-repo-history`. Until then, README lines about init normalization, `active`, and the `spec/` directory are stale.
  - Changing the consumer layout `fast-track-ai/` or the knowledge model.
