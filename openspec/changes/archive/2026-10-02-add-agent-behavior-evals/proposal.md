# Proposal

## Why

The deterministic eval suite verifies package text, scripts, and fixture invariants, but it does not prove that an agent follows the continuous-flow protocol across a real session. Finding 2 of the delivery-quality assessment identifies this gap in approval, revision, validation-failure, material-change, and resume behavior.

## What Changes

- Add an optional, maintainer-only Kiro agent-eval runner that operates on disposable target repositories.
- Define a Kiro adapter contract for non-interactive turns, normalized results, checkpoints, and available action events.
- Add a compatibility spike that proves or reports the limitation of resuming a headless Kiro session with a subsequent user prompt.
- Add five behavioral scenarios: spec revision, spec approval before implementation, failed validation, material planning decision, and resume from the first open task.
- Keep deterministic `evals/run-evals.sh all` unchanged in scope, speed, and dependency surface.
- Record inconclusive outcomes and adapter/event limitations without treating response wording as evidence.

## Capabilities

### New Capabilities
- `agent-behavior-evals`: Optional real-agent evaluation of the fast-track-ai workflow through a Kiro-specific adapter and durable behavioral oracles.

### Modified Capabilities
- None.

## Impact

- New maintainer-only files under `evals/` for the runner, Kiro adapter, fixtures, and scenario assertions.
- Documentation in `evals/evals.md` for explicit local invocation, prerequisites, outputs, and non-blocking policy.
- Requires a locally authenticated Kiro CLI, model access, and controlled agent-run cost; it adds no installed skill, command wrapper, or runtime dependency for consumers.
