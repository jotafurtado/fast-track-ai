# Design

## Context

See `proposal.md` for motivation and `specs/agent-behavior-evals/spec.md` for behavior. `evals/run-evals.sh` is a shell-only deterministic suite that already creates disposable fixtures and is intentionally self-contained. The installed Kiro CLI supports headless sessions, session IDs, and JSON event output, but multi-turn headless continuation must be proven against the installed CLI before it is used as an oracle.

## Goals / Non-Goals

**Goals:**
- Execute real Kiro agent sessions against isolated target repositories under a temporary directory.
- Make scenario verdicts from files, frontmatter, task state, command results, checkpoints, and available action events.
- Keep failure diagnostics reproducible enough to inspect locally.
- Keep agent evaluation opt-in, bounded, and separate from deterministic package validation.

**Non-Goals:**
- Make Kiro a consumer-facing dependency or install it through `install.sh`.
- Add a generic multi-provider abstraction, CI gate, external filesystem observer, or textual response matcher.
- Guarantee deterministic model output or prove action order when the Kiro adapter cannot emit reliable ordered evidence.

## Decisions

### Separate maintainer runner
Add a dedicated agent-eval runner and keep `run-evals.sh all` untouched. The runner shares fixture conventions with existing evals but has its own explicit invocation and prerequisites.

Alternative considered: an `agent` selector in `run-evals.sh`. Rejected because it would couple the public deterministic entry point to local credentials, agent cost, and model variance.

### Kiro-specific adapter with a small evidence contract
The runner calls one Kiro adapter responsible for session execution. Its input is the target workspace, model/effort configuration, timeout, and ordered user turns. Its output is a structured per-turn record with process result, checkpoint identifier, session identifier when available, and ordered action events when Kiro provides them. Scenario assertions consume the adapter output and filesystem snapshots, not CLI prose.

Alternative considered: a provider-neutral abstraction from the start. Rejected because only Kiro is in scope and a generic protocol would add unsupported surface before one implementation is proven.

### Compatibility spike gates multi-turn scenarios
The first adapter operation starts a headless session, attempts to resume it, and submits a next prompt. It records supported, unsupported, or inconclusive. Scenarios requiring revision, continuation, or material decisions run only after support is established; otherwise they are inconclusive rather than falsely passing or failing.

Alternative considered: assume `--resume-id` supports subsequent prompts because both flags exist. Rejected because flag compatibility is not a behavior guarantee.

### Checkpoints are the primary order evidence
The runner captures durable workspace snapshots at scenario turn boundaries and records available adapter events. It uses ordered events for intra-turn assertions only when they are present and reliable. No external filesystem watcher is added. An unavailable order signal produces an inconclusive order assertion, not an invented proxy.

Alternative considered: an external filesystem observer. Rejected as unnecessary complexity for the initial runner and vulnerable to platform-specific behavior.

### Fixture-driven five-scenario suite
Each scenario owns a minimal target fixture and expected durable state. Fixtures intentionally make validation failure and material planning change deterministic. The resume fixture is pre-populated with checked and open tasks. Shared fixture setup remains small and package-relative.

Alternative considered: one long end-to-end transcript. Rejected because a failure would be harder to classify, retry, and diagnose.

### Explicit non-blocking classifications
The runner distinguishes pass, fail, inconclusive, and prerequisite-unavailable. Inconclusive covers unsupported headless continuation, missing reliable order evidence, timeout, and model inability to complete an otherwise valid fixture. Prerequisite-unavailable covers missing Kiro CLI or authentication. Only explicit assertion failures are failures; none affect `run-evals.sh all`.

## Risks / Trade-offs

- [Kiro session continuation is unsupported in the installed version] → Run the compatibility spike first and report dependent scenarios as inconclusive.
- [Model variance causes intermittent outcomes] → Fix model and effort configuration per invocation, bound time, retain diagnostics on failure or inconclusiveness, and run manually at first.
- [Kiro emits incomplete tool/action events] → Use them only where present; record the unverified ordering limitation.
- [Real-agent runs consume credits] → Keep fixtures local and small, require explicit invocation, and avoid CI gating.
- [Temporary diagnostics are deleted too early] → Preserve a requested diagnostic directory or retain it automatically for fail/inconclusive results.

## Migration Plan

1. Add the optional runner, adapter, fixtures, and documentation without modifying the deterministic selector interface.
2. Run the compatibility spike locally with the selected Kiro model and effort configuration.
3. Run the five scenarios manually and inspect retained diagnostics for non-pass results.
4. Keep the runner non-blocking; later adoption of scheduled execution requires a separate decision based on observed reliability and cost.

## Open Questions

None. The model and effort are explicit runner configuration rather than a fixed package decision.
