# Proposal

## Why

The `failed-validation` agent-eval scenario failed on 2026-10-02 (kiro-cli 2.27.0). The agent kept both tasks open and recorded the divergence, but it created `farewell.txt` for Task 2 (Group B, `depends: A`) before Task 1's Validate passed, starting dependent work while its prerequisite group was failing. The implement skill orders groups by dependency but does not explicitly forbid editing a dependent group's Files before its prerequisites pass Validate. Evidence: `evidence/failed-validation-2026-10-02/` (events 135 and 136 in `turn-01.actions.jsonl`).

## What Changes

- The `fast-track-ai-implement` skill states that no task of a dependent group starts, and none of its Files is created or edited, until every task of each group it depends on has passed Validate and is checked.
- On a failed prerequisite Validate, the skill stops before every dependent group; it does not pre-create dependent files, including to collect evidence.
- The deterministic `flow` selector in `evals/run-evals.sh` requires the rule in the skill text.
- The `failed-validation` agent-eval scenario is the behavioral acceptance criterion; its result is recorded in `evals/evals.md`.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `implement-workflow`: new requirement governing when dependent groups may start.

## Impact

- `skills/fast-track-ai-implement/SKILL.md` (steps 4 or 5).
- `evals/run-evals.sh` (`flow` selector) and `evals/evals.md` (`flow` row and recorded agent run).
- No script, template, installer, or agent-eval interface change.
