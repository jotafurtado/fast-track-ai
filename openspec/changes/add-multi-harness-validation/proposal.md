# Proposal

## Why

The package has deterministic installation checks and real-agent workflow evidence for Kiro, but no equivalent evidence for Claude Code or Codex. Package readiness now requires reproducible `.agents` installation validation and passing real-agent scenarios on all three executable harnesses.

## What Changes

- Extend the existing maintainer-only runner with explicit `--harness kiro|claude|codex` selection, retaining Kiro as the default.
- Add Claude Code and Codex adapters that normalize native session, action, and checkpoint evidence into the existing assertion contract.
- Make scenario skill-location hints harness-aware without duplicating scenario semantics or assertion logic.
- Strengthen deterministic `.agents/skills` and Claude mirror checks by exercising installed owner scripts and sibling resources in disposable targets.
- Record a readiness matrix for the generic installation layout and all six existing scenarios on Kiro, Claude Code, and Codex. Only `pass` satisfies a readiness cell; missing prerequisites and inconclusive evidence remain explicit blockers.
- Clarify that task-scoped project checks follow the implement skill's existing resume rule; a checked task's Validate is not rerun as a final project check when its Files are unchanged.
- Extend ordering evidence to reliably correlated native shell observations or deterministic instrumentation when necessary, without polling, forced tool choice, or invented order inside an atomic batch.
- Clarify the approval-only transition so a multi-file action cannot mix approval statuses with product edits, without prescribing an editing tool.
- Preserve structured Kiro skill-disclosure provenance and native validation-script execution records; reading a Validate script is not execution.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `agent-behavior-evals`: Support three executable harnesses through a common evidence contract and require explicit per-harness readiness evidence.
- `package-surface`: Verify that installed `.agents` skills and Claude mirrors actually resolve owner and sibling resources and execute bundled scripts against disposable targets.
- `implement-workflow`: Make the existing checked-task resume rule explicitly govern task-scoped project checks throughout implementation and final validation.
- `continuous-flow`: Make the existing spec-to-implement ordering explicit as a completed approval-only action before product edits.

## Impact

- `evals/run-agent-evals.sh`, `evals/agent/kiro-adapter.sh`, new sibling Claude and Codex adapters, fixture turn prompts, `evals/run-evals.sh`, `evals/evals.md`, `skills/fast-track-ai-implement/SKILL.md`, and `skills/fast-track-ai-spec/SKILL.md`. Any observer resources remain maintainer-only under `evals/agent/`.
- Documentation for invocation, prerequisites, evidence limitations, and readiness results. The installer interface does not change; the implement skill's validation wording is clarified without changing which completed tasks are eligible for revalidation.
- Claude Code and Codex CLIs and local authentication are required only for their explicit real-agent runs. Real-agent evaluations consume the maintainer's configured model quota and remain outside the deterministic suite and installed package.
- Existing uncommitted repository-history changes belong to another change and are preserved.
