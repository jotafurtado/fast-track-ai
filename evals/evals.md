# Evals: Skill Standards Compliance

**Date**: 2026-09-27

## Executable Runner

Run every deterministic check from the repository root:

```bash
bash evals/run-evals.sh all
```

Run one selector by replacing `all` with its name. Every selector uses a fresh temporary fixture and removes it on exit. No selector reads the repository's own `fast-track-ai/` tree.

| Selector | Observable Contract | Expected Exit | Result |
|----------|---------------------|---------------|--------|
| `self` | Runner and every published shell script, including the agent-eval runner and Kiro adapter, pass `bash -n`; repository validation does not mask gate failures; the agent-eval runner without a Kiro CLI reports `prerequisite-unavailable` for all six selectors and exits 0 without invoking Kiro | 0 | PASS |
| `init` | Empty target receives the canonical tree; reruns are byte-identical; outdated managed blocks refresh without changing surrounding bytes; malformed markers fail before tree creation; symlink targets remain symlinked; the managed snippet states only the global contract and names neither `decisions.md`, `plan.md`, nor `spec/`; the init skill and command carry no conformance or normalization text and no track-migration directory | 0 | PASS |
| `index` | Valid artifacts and citation links appear in deterministic tables; the default intent fixture is `draft`; handoffs sort by captured instant; a handoff with `## Next actions` is accepted; `status: active`, offset or minute-precision handoff names, offset `captured` values, and P0/P1/First-next-action headings each fail with an objective message and leave `INDEX.md` unchanged; a handoff without `## Next actions` is rejected; orphan tracks, dangling citations/replacements, a loose `tracks/<id>.md` as intent replacement, malformed flow lists, invalid handoff timestamps, and more than three active handoffs fail without changing INDEX.md | 0 | PASS |
| `approval` | Completion remains the default and requires approved artifacts and closed tasks; structure mode accepts draft/open tracks; unknown modes fail; a root `plan.md` and ungrouped tasks fail with their objective messages | 0 | PASS |
| `install` | Default and custom agents/Claude directories contain seven resolving `fast-track-ai-*` skill links, seven command files, and no `shared` link | 0 | PASS |
| `resources` | Every owned script and template has exactly one owner guidance reference; removed init templates are absent; every skill states the skill-relative path resolution rule | 0 | PASS |
| `workflows` | Research, assessment, and handoff are self-contained, status-free where required, and conform to their schemas; research and assessment carry the slug/same-day collision and inconclusive rules; assessment findings state problem, evidence, consequence, and recommendation | 0 | PASS |
| `refs` | Ref instructions cover inline, pinned pointer, mutable pointer replacement, candidate-hash reuse, persisted duplicate rejection, locator hashes, and unavailable sources; the ref template carries only its type section and no `## Contract` | 0 | PASS |
| `decisions` | Intent distinguishes qualifying from local choices; evidence lives only in the `## Evidence` body; material planning-drift approval rules, immutable original ADR content, and `superseded_by` replacement are covered | 0 | PASS |
| `handoff` | Four UTC-seconds handoffs are ordered by captured instant; the oldest is archived, the newest three remain active, and the archive is absent from INDEX; the handoff skill orders its collision check, write, validation, archive, and index steps in that sequence | 0 | PASS |
| `spec` | Structure checks require phases, non-empty phase fields, tasks, per-task fields, and valid unique acyclic groups; intent IDs must match track directories; ungrouped tasks fail with `tasks.md has no group header`; hidden root entries, a root `plan.md`, `decisions.md`, or `spec` (file or directory) fail as entries outside the allowed set, and a directory `spec.md` or file `assets` fails on its type; the spec template names neither `decisions.md` nor `plan.md` | 0 | PASS |
| `flow` | Intent, spec, and implement skills plus the tasks template contain continuous-flow next-step lines, `## Group`, and `(depends:`, and the intent skill does not contain the retired exit line; the implement skill states proportional delegation, resume from the first open task, the divergence stop, and that a dependent group's Files are not created, edited, or deleted before every prerequisite task has passed Validate and is checked, with a stop on a failed prerequisite, and names the code-review ref as provenance that the consuming project does not need | 0 | PASS |
| `active` | No live skill, template, or command file contains `status: active`, and an intent with `status: active` fails the index with `invalid status: active` and leaves `INDEX.md` unchanged | 0 | PASS |
| `frontmatter` | Index and gate reject the same malformed fixtures (unclosed block, duplicate key, indented list line) with the same rule text, a `---` pair below line 1 yields no fields, every index rejection leaves `INDEX.md` byte-identical, and every frontmatter template fits the canonical subset | 0 | PASS |
| `isolation` | A copy of `skills/`, `commands/`, `install.sh`, `AGENTS.md`, and `evals/` without the `fast-track-ai/` tree passes `run-evals.sh all` | 0 | PASS |

## Behavioral Fixtures

### Init

- Prompt: "Setup fast-track-ai here."
- Expected files: `fast-track-ai/{research,refs,handoffs/archive,assessments,decisions,tracks}/`, `fast-track-ai/INDEX.md`, and one managed block in `AGENTS.md`.
- Expected exit: 0, twice in a row (idempotent).
- An outdated managed block between user text is replaced while the surrounding bytes remain unchanged. Begin-without-end, duplicated, or out-of-order markers exit 1 without writing or creating the tree; a symlinked `AGENTS.md` remains a symlink. A pre-existing `specs/` directory is left untouched.

### Index

- Prompt: "Regenerate the index."
- Expected tables: tracks, refs, research, assessments, decisions, and active handoffs; active handoffs are ordered by `captured` instant.
- Valid fixtures: inline refs with and without a blank separator, pinned pointer, mutable pointer and replacement, multi-source research, assessment, accepted decision, superseded decision with replacement, superseded intent pointing at `tracks/<id>/intent.md`, and active handoff. UTC-seconds handoffs with `## Next actions` are accepted; a handoff without that heading is rejected without changing `INDEX.md`. Two unchanged runs are byte-identical; archived handoffs are absent.
- Failure fixtures include an invalid research artifact after a valid index: the command exits 1, preserves `INDEX.md` byte-for-byte, reports that the index was not updated, and removes its temporary file. Cross-link and handoff integrity failures name the affected artifact and rule. A loose `tracks/<id>.md` does not satisfy an intent `superseded_by`.

### Approval Gate

- Prompt: "Check if the track is done."
- Approval selector: draft intent with approved closed spec+tasks exits 0; a root `plan.md`, ungrouped tasks, unapproved spec/tasks, and open tasks each exit 1. Structure mode accepts the same draft status and open task state; unknown mode and mismatched intent id fail.

### Spec Cycle

- Prompt: "Approve this spec."
- Required file: track-root `spec.md` with at least one `### Phase` and non-empty `Done:`, `Files:`, and `Accept:` in each phase.
- Failure fixtures: approved tasks without `spec.md`, `spec/` without root `spec.md`, no phase, empty phase `Accept:`, no tasks, a task missing `Validate:`, unknown/self/duplicate group dependencies, dependency cycles, task before first group, tasks with no group header, mismatched intent ID, root `plan.md`, root `decisions.md`, a `spec` file or directory, hidden root entries `.notes` and `.DS_Store`, a regular file `assets`, and a directory `spec.md`.

## Recorded Run

`run-evals.sh all` completed with all fifteen selectors passing.

## Agent Behavior Evals (Optional)

`evals/run-agent-evals.sh` runs real Kiro agent sessions against disposable target repositories to check the continuous-flow protocol. It is maintainer-only, local, and explicit: `run-evals.sh all` never calls it, and none of its results affect the deterministic suite. Each run consumes Kiro credits.

```bash
bash evals/run-agent-evals.sh <selector> [--model MODEL] [--effort EFFORT] [--timeout SECONDS] [--keep-dir DIR]
```

Selectors: `compat`, `revision`, `approval`, `failed-validation`, `material-change`, `resume`, `all`.

### Prerequisites

- A Kiro CLI on `PATH` (or at `KIRO_CLI`) that is logged in: `kiro-cli whoami` must exit 0.
- `jq`, `rsync`, `shasum`, and `git`.
- Sessions run with `--trust-all-tools` inside the disposable workspace; run the suite only on a machine where that is acceptable.

### Configuration

| Input | Flag | Environment default | Default |
|-------|------|---------------------|---------|
| Model | `--model` | `FAST_TRACK_AI_AGENT_MODEL` | Kiro default |
| Effort | `--effort` | `FAST_TRACK_AI_AGENT_EFFORT` | Kiro default |
| Per-turn timeout in seconds; a scenario is bounded by turns times this value | `--timeout` | `FAST_TRACK_AI_AGENT_TIMEOUT` | 900 |
| Kiro executable | none | `KIRO_CLI` | `kiro-cli` |
| Diagnostic directory | `--keep-dir` | none | temporary directory |

### Isolation

Each scenario gets a fresh workspace: `fast-track-ai-init.sh`, the fixture overlay from `evals/agent/fixtures/<scenario>/workspace/`, `fast-track-ai-index.sh`, a copy of `skills/fast-track-ai-*` under `.kiro/skills/`, and a baseline git commit. No installed skill or command is required and the repository's `fast-track-ai/` tree is never read. The `compat` workspace is an empty git repository.

The workspace is disposable, but Kiro still loads the maintainer's global configuration (for example steering and skills under `~/.kiro/`). That configuration can influence agent behavior and is not controlled by the runner; record it when comparing runs across machines.

### Kiro Adapter

`evals/agent/kiro-adapter.sh --workspace DIR --turns-dir DIR --out DIR [--model MODEL] [--effort EFFORT] [--timeout SECONDS]` runs `turn-NN.txt` files in order with `kiro-cli chat --output-format stream-json`. Turn 1 starts a session; each later turn uses `--resume-id` with the previous turn's session id. A turn that does not succeed stops the sequence. Evidence under `--out`:

- `turns.jsonl`: one record per turn with `outcome` (`success`, `error`, `timeout`, `auth-failure`, `not-run`), `exitCode`, `sessionId`, `checkpoint`, `ordered` (stream had both `runStarted` and `runFinished`), `eventCount`, `actionCount`, and `credits`.
- `turn-NN.events.jsonl` and `turn-NN.stderr`: raw Kiro output.
- `turn-NN.actions.jsonl`: ordered tool calls with `seq`, `kind`, `tool`, workspace-relative `paths`, shell `command`, raw `input`, and final `status`.
- `checkpoints/turn-NN/` and `checkpoints/turn-NN.manifest`: workspace snapshot and sha256 manifest after each turn, excluding `.git` and `.kiro`; `turn-00` is the baseline.

Agent response text stays only in the raw events. No assertion reads it.

### Scenarios

Verdicts use only checkpoints, frontmatter, task checkboxes, command results, and recorded actions. A product path is any path outside `fast-track-ai/`, `.kiro/`, and `.git/`.

| Selector | Fixture | Assertions |
|----------|---------|------------|
| `compat` | Turn 1 gives the token in `fixtures/compat/expected-token` and forbids file changes; turn 2 resumes and asks for `token.txt` with that token | Records `capability.json` as `supported` (same session id and the token written in turn 2), `unsupported`, `timeout`, or `auth-failure` |
| `revision` | Intent for `greeting.txt`; turn 1 runs the spec skill, turn 2 is a revision | `spec.md` and `tasks.md` are `draft` after both turns, no product change at either checkpoint, no product edit action in turn 2, no checked task, intent not `shipped` |
| `approval` | Same intent; turn 1 runs the spec skill, turn 2 is `.` | Both artifacts `draft` with no product change after turn 1 and `approved` after turn 2; the edit actions that write `status: approved` to both precede the first product edit action |
| `failed-validation` | Approved track whose Task 1 Validate, `scripts/check-greeting.sh`, always exits 1; Task 2 in a dependent group | The Validate command ran; both tasks stay open; `farewell.txt` is absent and no edit action targets it; the script is unchanged; intent not `shipped`; `assets/acceptance.md` is absent or keeps a `pending` row, so ship was not offered; the completion gate rejects the track |
| `material-change` | Approved `greeting.txt` track; the implement turn carries a final decision to deliver `greeting.json` instead | Both artifacts return to `draft`, no product change or product edit action, no checked task, intent not `shipped` |
| `resume` | Approved track with Task 1 checked and Tasks 2 and 3 open in dependent groups; `scripts/validate-alpha.sh` leaves a marker when run | The marker is absent and no shell action runs `validate-alpha.sh`; `alpha.txt` is unchanged; Task 1 stays checked; the first product edit action targets `beta.txt` |

`material-change` delivers the decision in the same turn that starts implementation, before any task begins. It approximates a decision made mid-implementation with one turn, which keeps cost and model variance low; a decision arriving after a task has started is not exercised.

`revision`, `approval`, and `material-change` run only after `compat` reports `supported` in the same invocation; otherwise they report `inconclusive` (or `prerequisite-unavailable` on `auth-failure`) with the compat reason.

### Results

Each scenario prints `RESULT: <scenario> <classification>: <reason>`, followed by `SUMMARY:` with counts.

- `pass`: every assertion held.
- `fail`: at least one durable-state or recorded-action assertion did not hold.
- `inconclusive`: unsupported continuation, timeout, a turn error, the model not reaching the state under test, or an order assertion without reliable evidence (incomplete event stream, product change made outside an edit action, approval written outside an edit action).
- `prerequisite-unavailable`: missing Kiro CLI, failed `whoami`, or missing tool, checked before any scenario so none runs; or a Kiro auth failure during a turn, which classifies only that scenario.

Exit code: 0 when no scenario failed, 1 when any scenario failed, 2 on a usage error. All classifications are non-blocking for `run-evals.sh all`.

### Diagnostics

Without `--keep-dir`, passing scenario directories are removed and non-passing ones are kept under a temporary root printed as `DIAGNOSTICS ROOT:`; the root is removed when everything passed. With `--keep-dir DIR`, every scenario directory is kept under `DIR/<scenario>/`. Each holds `workspace/`, `evidence/`, `adapter.log`, `assertions.log` (one `PASS`, `FAIL`, or `INCONCLUSIVE` line per assertion), and `result.json`.

### Recorded Agent Run

2026-10-02, kiro-cli 2.27.0, Kiro default model and effort, 900 s per turn, about 6.5 credits in total.

| Selector | Result | Note |
|----------|--------|------|
| `compat` | pass | Headless `--resume-id` continuation supported |
| `revision` | pass | 9 assertions |
| `approval` | pass | Approval writes at seq 10 and 11, first product edit at seq 26 |
| `failed-validation` | fail | The agent kept both tasks open and recorded the divergence, but created `farewell.txt` for Task 2 before Group A passed |
| `material-change` | pass | 6 assertions |
| `resume` | pass | First product edit targeted `beta.txt`; `validate-alpha.sh` not rerun |

2026-10-03, kiro-cli 2.27.1, Kiro default model and effort, 900 s per turn, after the implement skill gained the dependent-group rule (step 4). Two `failed-validation` runs, about 1.95 credits in total.

| Run | Selector | Result | Credits | Note |
|-----|----------|--------|---------|------|
| 1 | `failed-validation` | pass | 1.09 | 9 assertions; `farewell.txt` absent and no edit action targeted it; both tasks open |
| 2 | `failed-validation` | pass | 0.87 | 9 assertions; `farewell.txt` absent and no edit action targeted it; both tasks open |
