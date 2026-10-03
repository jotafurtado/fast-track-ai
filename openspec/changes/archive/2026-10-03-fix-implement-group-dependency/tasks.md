# Tasks

## 1. Skill Rule

- [x] 1.1 Add the dependent-group rule to `skills/fast-track-ai-implement/SKILL.md`: no task of a `(depends: ...)` group starts, and none of its Files is created, edited, or deleted (including to collect evidence), until every task of each prerequisite group has passed Validate and is checked; on a failed prerequisite Validate, stop before every dependent group and report; verify with `grep` that the skill contains the new rule text and `bash evals/run-evals.sh flow` still passes.
- [x] 1.2 Extend the `flow` selector in `evals/run-evals.sh` with `assert_contains` checks for the new rule and update the `flow` row in `evals/evals.md`; verify `bash evals/run-evals.sh all` passes and that removing the rule from a temporary copy of the skill makes `flow` fail.

## 2. Behavioral Acceptance

- [x] 2.1 Run `bash evals/run-agent-evals.sh failed-validation --keep-dir /tmp/ftai-fix` at least twice against a locally authenticated Kiro CLI; verify every run is `pass` (repeat an `inconclusive`, reopen task 1.1 on a `fail`) and record the runs, kiro-cli version, and credits in the "Recorded Agent Run" table in `evals/evals.md`.
