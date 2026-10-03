# Tasks

## 1. Runner and Kiro Adapter Foundation

- [x] 1.1 Add the explicit maintainer-only agent-eval runner, temporary-workspace lifecycle, selector handling, configured model/effort/timeout inputs, and pass/fail/inconclusive/prerequisite-unavailable result reporting; verify `bash -n` passes and an unavailable Kiro prerequisite produces the documented non-blocking result.
- [x] 1.2 Add the Kiro-specific adapter that starts headless sessions in the target workspace, records structured per-turn results, session identifiers when available, checkpoints, and available JSON action events; verify a single-turn fixture emits parseable structured evidence without using response prose as an assertion.
- [x] 1.3 Add failure and inconclusive diagnostic retention for the adapter and runner; verify passing temporary workspaces are removed and a requested or non-pass diagnostic workspace preserves its evidence.

## 2. Headless Continuation Compatibility

- [x] 2.1 Implement the compatibility spike that starts a headless Kiro session, attempts a resumed subsequent prompt, and classifies supported, unsupported, timeout, and authentication failures; verify unsupported continuation makes dependent scenarios inconclusive rather than pass or fail.
- [x] 2.2 Add a documented, deterministic fixture for the compatibility invocation; verify the adapter records the exact capability result and does not change `evals/run-evals.sh all` behavior.

## 3. Workflow Scenario Fixtures and Assertions

- [x] 3.1 Add the spec-revision scenario fixture and durable assertions for draft planning artifacts, absence of product changes at the revision checkpoint, and no completed task; verify its verdict relies only on artifacts, snapshots, and recorded actions.
- [x] 3.2 Add the spec-approval scenario fixture and assertions for both planning artifacts becoming approved and, when reliable ordered events exist, approval preceding implementation; verify missing order evidence is reported as inconclusive for that assertion.
- [x] 3.3 Add the failed-validation scenario fixture with a deterministic failing Validate command and dependent work; verify the failing task stays open, dependent work does not start, and the track cannot be shipped.
- [x] 3.4 Add the material-planning-decision scenario fixture and assertions that the planning artifacts return to draft and execution pauses for renewed approval; verify the scenario does not inspect agent response wording.
- [x] 3.5 Add the resume scenario fixture with checked prerequisite tasks and a later open task; verify the first open task in dependency order is selected without revalidating unchanged checked work.

## 4. Maintainer Documentation and Regression Coverage

- [x] 4.1 Document explicit local invocation, Kiro prerequisites, configuration inputs, result classifications, diagnostic retention, non-blocking policy, and the fact that `run-evals.sh all` excludes agent evaluation in `evals/evals.md`; verify every documented command and path matches the runner interface.
- [x] 4.2 Extend deterministic self-validation only for the new published maintainer files that do not invoke Kiro; verify `bash evals/run-evals.sh all` still passes in the isolation fixture without a Kiro CLI, credentials, or the historical `fast-track-ai/` tree.
- [x] 4.3 Run the agent-eval compatibility spike and all five scenario selectors against a locally authenticated Kiro CLI; verify each result is classified and retained diagnostics explain every non-pass result.
