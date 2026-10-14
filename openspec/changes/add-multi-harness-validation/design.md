# Design

## Context

See `proposal.md` for motivation. `evals/run-agent-evals.sh` currently fixes the adapter, prerequisites, skill location, product exclusions, and compatibility metadata to Kiro. Its shared assertions already cover six selectors and consume JSONL actions and filesystem checkpoints. The fixture prompts also name `.kiro/skills/` directly.

`install.sh` already links seven skills into `.agents/skills` and mirrors them into Claude locations. The `install` eval checks default and custom layouts, but does not exercise all bundled scripts through those installed paths. No installer API change is needed.

The installed CLIs expose Claude print/stream-json/resume and Codex exec/json/resume. Their help and official documentation establish these interfaces, not the completeness of actual action streams. That completeness must be proven with disposable native-event smoke runs during implementation.

## Goals / Non-Goals

**Goals:** Preserve one scenario oracle, use native skill discovery and native session continuation, and retain enough evidence to distinguish a failed behavior from unavailable observation.

**Non-Goals:** A fourth executable `.agents` harness, universal compatibility with every skills consumer, automatic trigger-quality benchmarking, additional lifecycle scenarios, CI provisioning, credential installation, changes to the installer interface, or changes to the conditions under which a completed task may be revalidated.

## Decisions

### 1. Extend the existing runner with one selected harness per invocation

Add `--harness kiro|claude|codex`, default `kiro`, with explicit `KIRO_CLI`, `CLAUDE_CLI`, and `CODEX_CLI` executable overrides. Select the adapter, prerequisite probe, native skill directory, and CLI-version probe through a small shell dispatch. Keep shared scenario functions and assertions in the existing runner; do not duplicate them into three runners or introduce a plugin framework.

Keep existing selector names, model/effort/timeout flags, environment defaults, and exit codes. Unsupported requested settings produce an explicit usage or capability error, never silent omission. Runs are independent: a missing Claude prerequisite must not imply anything about Codex or Kiro. Diagnostics use `<root>/<harness>/<scenario>`; each result carries the harness identity. Default Kiro invocation remains usable, but diagnostics consumers migrate to the new layout without aliases.

### 2. Expose the exact package under native discovery directories

Method workspaces receive `.kiro/skills`, `.claude/skills`, or `.agents/skills` for Kiro, Claude Code, or Codex respectively. Copy the current package into the disposable workspace so agent edits cannot mutate source through symlinks. Generic installation checks separately exercise the installer's actual symlink topology.

Remove the fixed Kiro hint from canonical scenario prompts. Stage each prompt with only the selected discovery-location hint; keep user decisions, track names, task failures, and `.` inputs identical. Do not inject the whole skill body or replace native discovery with manually pasted instructions. Verify the required package skill was loaded from the staged location with native tool evidence or equivalent machine-verifiable discovery evidence, so a globally installed version cannot count as the evaluated package.

Exclude `.git`, `.kiro`, `.claude`, and `.agents` configuration from checkpoint product comparisons and product action filters consistently. Do not exclude arbitrary hidden product files: the resume marker remains observable.

### 3. Preserve a single evidence contract

Adapters accept `--workspace`, `--turns-dir`, `--out`, `--model`, `--effort`, and `--timeout`. They write the existing `turns.jsonl`, `turn-NN.events.jsonl`, `turn-NN.stderr`, `turn-NN.actions.jsonl`, and checkpoint/manifests, with native session identity and available usage data. Unknown usage remains unknown, not zero credits asserted as observed.

Use shared snapshot/deadline helpers only where the three adapters actually need identical logic. Harness-specific invocation and event normalization stay in their own adapter files. No dependencies beyond the existing shell tools and CLIs are needed.

Claude uses print mode with `--output-format stream-json --verbose`, preserving session persistence and resuming the returned native session id. Normalize completed `Read`, `Edit`, `Write`, and `Bash` tool calls and their results, including reliably correlated subagent events if used.

Codex uses `exec --json` for turn one and `exec resume <thread-id> --json` for subsequent turns, without ephemeral mode or `--last`. Normalize native command execution and file-change events; preserve native patch content where available. Configure workspace-write and noninteractive approval using the installed CLI's supported initial/resume flags or config keys. Do not default to an unsandboxed Codex invocation.

A native event index orders actions only when the native stream proves their ordering. A patch that approves both artifacts and edits the product in one batch does not prove approval preceded implementation. Do not split a batch into fabricated sequential actions. Mutations via shell, nested agents, or missing patch payloads must not yield false passing absence/order assertions. If native output lacks required details, inspect supported local session evidence outside the target as part of the adapter; if proof remains unavailable, classify the assertion as inconclusive and leave readiness blocked. Do not weaken assertions, force a tool choice in user prompts, or infer action order from final files.

The maintainer authorized a scope extension on 2026-10-14: native command results and supported deterministic shell instrumentation may provide ordering evidence when their provenance, affected paths, completion, and relation to other actions are proven. Preserve the distinction between a whole shell call and its constituent operations: a zero final exit code alone does not prove every earlier operation succeeded. Snapshots before/after a call cannot prove ordering inside that call. Polling is not an evidence source. Keep ambiguous or uncovered operations inconclusive.

The existing absence assertions currently treat an empty normalized stream as no edits. Add an explicit coverage/completeness check before relying on absence or order, for every adapter including Kiro. Final-state violations remain failures even when action evidence is incomplete.

### 4. Strengthen the existing install selector, not a new generic runtime

In disposable default and custom layouts, check all seven metadata files and their owner templates through `.agents` links and Claude mirrors. Resolve the existing sibling references from installed skill directories. Run init twice through installed locations, generate an index for a valid fixture, and exercise both successful completion and rejection of an open/unapproved track through the installed gate. Reuse existing valid track fixture conventions. Validate output artifacts, not only exit status or link counts.

Retain deterministic independence from authenticated CLIs. Missing-executable checks cover each harness without launching a real model. Behavioral event-normalization regression fixtures cover incomplete streams, batched edits, failed tool calls, shell mutation gaps, and resumed identity only where they can expose consumer-visible false verdicts; do not add source-text or forwarding tests.

### 5. Readiness is a recorded matrix, not the optional runner exit code

Run the full deterministic suite and the six real-agent selectors on each executable harness. The `compat` check runs once per harness invocation. Preserve non-pass classifications and the existing optional runner exit behavior; do not silently turn `inconclusive` into success. Record the generic installation result and each harness/scenario cell in `evals/evals.md` with the evaluated package state, versions, settings, date, and evidence location. Historical Kiro runs remain history; rerun Kiro after shared-runner changes.

This checks the existing continuous-flow scenarios, not every behavior of every skill or implicit activation phrasing. Model updates can invalidate behavioral confidence; the permanent suite makes revalidation possible.

### 6. Apply the resume rule when selecting project checks

The recorded Claude resume run initially skipped checked Task 1, then ran its Validate as a final project check under step 5's broad instruction. Keep the checked-task rule authoritative in step 1 and reference it at the check-selection point in step 5. A task-scoped script remains task-scoped even when it is the project's only check script. Acceptance checks against the final state still run. Do not change the scenario prompt or relax its assertion, and retain the failing baseline as evidence.

### 7. Complete approval before product mutation

The Codex high-effort run approved both artifacts and wrote the product in one native patch. Keep such batches inconclusive; do not infer file order from patch text. Clarify the spec skill's existing transition as an approval-only completed action before invoking implement or issuing a product mutation. Both approval statuses may still be written together, with any supported tool. This is a workflow boundary, not a requirement to choose a particular tool.

### 8. Use native producer records, not script-name matches

Kiro's native `disclose_context` completion provides the source skill id/URI, scope, and origin; normalize that structured source rather than requiring an explicit file-read call. Native `rawInput.text` carries new file bytes and must be preserved. Unclassified calls make coverage incomplete.

The old resume oracle mistook `cat scripts/validate-alpha.sh` for invocation. The fixture script now emits an explicit execution record into native command output, in addition to its file marker. Preserve native tool-result output and use that record as positive invocation evidence even if the file marker is later deleted. Reading the unchanged script source is not invocation; opaque, missing, filtered, or suppressed referenced output stays inconclusive.

The explored DEBUG/startup observer does not provide guaranteed coverage of opaque writers, pipelines, subshells, or overwritten hooks. No speculative observer is shipped. Proven native actions remain the ordering source; command-boundary instrumentation remains conditional on a trustworthy implementation and is not a prerequisite merely to make the code larger.

## Risks / Trade-offs

- Missing patch detail or shell-only mutations -> use native evidence where supported, otherwise report inconclusive and block readiness rather than manufacture ordering.
- Personal/global skills can override project skills, particularly Claude Code -> require evidence of the staged package location; document other inherited configuration without copying secrets.
- Disposable repositories do not sandbox the whole machine -> prefer native confinement, keep access restricted to disposable targets, document any required permission bypass and do not imply full isolation.
- CLI or model differences produce failures or variable behavior -> record actual versions/settings and retain diagnostics; fix evidenced package defects, never reword acceptance to obtain pass.
- Real-agent runs consume quota -> keep explicit, bounded, separate invocations and do not rerun passing scenarios without a changed evaluated surface.
- Existing repository-history edits share eval/documentation files -> preserve their content and keep their OpenSpec change independent.

## Migration Plan

1. Generalize harness dispatch, scenario staging, exclusions, and evidence coverage while keeping default Kiro behavior.
2. Implement and smoke the Claude and Codex adapters against native sessions in disposable targets.
3. Extend installed-resource validation and run deterministic checks after integration.
4. Run and document the full real-agent matrix. Do not claim readiness with any non-pass cell.

Rollback removes the new adapters and restores the Kiro-only runner and documentation; published skills and installer behavior are unchanged.

## Sources

- [Claude Code CLI reference](https://code.claude.com/docs/en/cli-reference), plus local `claude --help`.
- [Claude Code skill discovery and precedence](https://code.claude.com/docs/en/skills).
- [Codex non-interactive execution and native JSONL events](https://developers.openai.com/codex/noninteractive), plus local `codex exec --help` and `codex exec resume --help`.
- [Codex `.agents/skills` discovery and symlink support](https://developers.openai.com/codex/skills).
