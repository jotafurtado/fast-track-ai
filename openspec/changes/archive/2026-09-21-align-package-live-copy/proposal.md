# Proposal

## Why

The live cycle already matches the continuous-flow contract, but the package still describes an older world: Spec Kit negatives, an unused intent `active` step, English-only house copy against Portuguese next-step lines, a mandatory-intent sentence that fights assess/research/handoff exits, command files that exist but are not installed, evals that never assert `.` continuation, and track `010` still `draft` after a passing gate. Agents that read INDEX first then follow live skills get contradictory instructions.

## What Changes

- Set `010-approval-ask-not-gate-fail` intent `status: shipped` and regenerate `INDEX.md`. Do not rewrite that track's historical spec or tasks.
- Remove Spec Kit from live package copy (skills, commands, templates, AGENTS, evals table prose, skill-package contract). Init still must not create `specs/` or `.specify/`; that is asserted by evals, not by user-facing "we do not install Spec Kit" sentences.
- Keep Portuguese next-step and non-implementation-exit lines as the live user-facing copy. Narrow the English house rule so those named strings are allowed.
- Stop writing intent `status: active`. Live writers use `draft` until `shipped` (or `dropped` / `superseded`). The index may still accept `active` so old fixtures do not fail, but AGENTS no longer says a track leaves `active`.
- Soften "Mandatory flow, no exceptions" so assess, research, and handoff remain first-class exits without an intent.
- Have `install.sh` link the seven `commands/fast-track-ai-*.md` files into a harness commands directory, and extend the install eval to check them.
- Add a live eval selector that asserts `.` continuation copy, `## Group` / `(depends:)` on the tasks template, and the non-implementation exit line.
- Do not mention leftover `plan.md` as live work. Do not create a numbered track for this OpenSpec change. Do not rewrite frozen `001` `spec/` prose, shipped track bodies, ADRs, or historical research/assessments.

## Capabilities

### New Capabilities

- `package-surface`: Live package copy, installer command links, INDEX terminal state for `010`, and eval coverage that the published skills match the continuous-flow description.

### Modified Capabilities

- `continuous-flow`: Portuguese continuation and exit lines are the required user-facing copy; live skills never write intent `status: active`.
- `method-artifacts`: The installer exposes the seven command wrappers in the harness commands directory, not only skill directories.

## Impact

- `skills/fast-track-ai-init/assets/AGENTS-snippet.md` and this repo's managed `AGENTS.md` block
- `AGENTS.md` house rules (English prose)
- `skills/fast-track-ai-init/SKILL.md`, `commands/fast-track-ai-init.md`, `skills/fast-track-ai-spec/assets/spec.md`
- `install.sh` plus the `install` eval
- `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`, `evals.md`, `spec/contracts/skill-package.md`
- `fast-track-ai/tracks/010-approval-ask-not-gate-fail/intent.md` and regenerated `INDEX.md`
- Eval fixtures that currently construct `status: "active"` unless proving the index still accepts that value
