# Proposal

## Why

The three package scripts validate less than the method promises. The 2026-09-21 assessments `skills-simplification` and `delivery-quality` found, and a re-check against HEAD `daa9040` confirmed, the following defects:

- `fast-track-ai-index.sh` overwrites `INDEX.md` before it checks for errors. Tracks without `intent.md` never show up, and citations are never resolved.
- `fast-track-ai-init.sh` never refreshes an existing managed block, so consumer projects keep old rules.
- `fast-track-ai-gate.sh` only greps for labels anywhere in the file. A `tasks.md` with zero tasks passes, and so do empty fields and cyclic groups. It also has a single mode, so the spec skill has to tell agents to ignore expected failures.

Fixing these deterministic defects first lets the follow-up procedure change (`fix-skill-procedure-contracts`) rely on a gate and an index that check what they claim to check.

## What Changes

- **Index publishes only valid output.** On any error the index script leaves the existing `INDEX.md` untouched, exits non-zero, and says that the index was not updated. On success it replaces the file atomically.
- **Index checks integrity.** It reports track directories without `intent.md`. It checks that each `superseded_by` (on intents and decisions) points at an existing artifact of the same type and not at itself. It checks that every slug in an intent's `refs`, `research`, `assessments`, and `decisions` lists exists in that category.
- **Inline ref hash covers all stored content.** The extraction after `## Source content` no longer drops the first line when no blank line follows the heading. The 500 KB limit is documented as the whole ref file, which matches what the script already measures.
- **Handoffs order by real time.** New handoffs use UTC with seconds in both the filename and `captured`. The index accepts the legacy minute-and-offset filenames, lists active handoffs by the instant in `captured`, and fails when more than three active handoffs exist. The handoff skill orders by that same instant, never overwrites an existing file, archives the older files, and then runs the index to validate the result.
- **Init refreshes the managed block.** It creates the block when absent, replaces only the text between the markers when present, preserves all outside content byte for byte, and fails without writing when the markers are duplicated, unclosed, or out of order.
- **The gate gets two explicit modes.**
  - `--mode structure` checks documents, per-phase and per-task fields, at least one phase and one task, group names, `depends:` targets, and dependency cycles.
  - `--mode completion` is the default. It adds approved status and closed tasks on top of the structural checks.
  - The spec skill switches to structure mode and drops its instruction to disregard gate failures. The implement skill keeps the default.
- `active` remains an accepted intent status (no change), for projects written before the draft-only cycle.

## Capabilities

### New Capabilities
- `track-gate`: Structural and completion validation of a track (`fast-track-ai-gate.sh`), including per-phase and per-task field checks and group dependency integrity.

### Modified Capabilities
- `method-artifacts`: Index generation publishes only on success and validates cross-artifact links and orphan track directories. Inline ref hashing and the ref size unit are made precise. Handoff naming, ordering, collision, and active-window rules change.
- `package-surface`: Init refreshes an existing managed AGENTS block between its markers and rejects malformed markers.

## Impact

- `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`, `skills/fast-track-ai-init/scripts/fast-track-ai-init.sh`, `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`
- `skills/fast-track-ai-spec/SKILL.md` (gate call switches to structure mode) and `commands/fast-track-ai-spec.md` if it repeats the gate call
- `skills/fast-track-ai-handoff/SKILL.md`, `skills/fast-track-ai-handoff/assets/handoff.md`
- `skills/fast-track-ai-intent/SKILL.md` and `skills/fast-track-ai-intent/assets/ref.md` (500 KB wording only)
- `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh` and `spec/evals.md` (new fixtures, and `write_spec` gains a real `### Phase` section)
- Not in scope:
  - Procedure text of the intent, spec, and implement skills beyond the gate call. That belongs to `fix-skill-procedure-contracts`.
  - Removing `decisions.md` from the track root (shipped track `005` has one).
  - Hidden-file checks at the track root (macOS `.DS_Store`).
  - A general YAML parser.
  - Frozen track `001` and its `plan.md`.
  - Removing `active` from the enum.
