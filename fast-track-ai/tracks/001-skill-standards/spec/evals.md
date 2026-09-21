# Evals: Skill Standards Compliance

**Date**: 2026-09-18

## Executable Runner

Run every deterministic check from the repository root:

```bash
bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all
```

Run one selector by replacing `all` with its name. Every selector uses a fresh temporary fixture and removes it on exit.

| Selector | Observable Contract | Expected Exit | Result |
|----------|---------------------|---------------|--------|
| `self` | Runner and every published shell script pass `bash -n`; repository validation does not mask gate failures | 0 | PASS |
| `init` | Empty target receives the canonical `fast-track-ai/` tree and one managed block; second run is idempotent; no `specs/` or `.specify/` is created | 0 | PASS |
| `index` | Active track is indexed without a `via` column; invalid status is rejected | 0 | PASS |
| `approval` | Draft intent with approved closed spec/tasks passes; leftover `plan.md`, unapproved spec/tasks, and open tasks fail | 0 | PASS |
| `install` | Default and custom agents/Claude directories contain six resolving `fast-track-ai-*` skill links and no `shared` link | 0 | PASS |
| `audit` | Exactly 36 unique skill-rule verdicts contain evidence quotes | 0 | PASS |
| `resources` | Every owned script and asset has explicit skill guidance | 0 | PASS |
| `spec` | Required track-root `spec.md` is enforced; `spec/` without `spec.md` fails; approved closed tracks with `spec.md` pass | 0 | PASS |
| `contract` | Package path contract permits sibling owner paths and rejects machine-fixed paths | 0 | PASS |

## Behavioral Fixtures

### Init

- Prompt: "Setup fast-track-ai here."
- Expected files: `fast-track-ai/{research,refs,handoffs/archive,assessments,decisions,tracks}/`, `fast-track-ai/INDEX.md`, and one managed block in `AGENTS.md`.
- Expected exit: 0, twice in a row (idempotent).
- A pre-existing `specs/` directory is left untouched and does not block init.

### Index

- Prompt: "Regenerate the index."
- Expected row: `| 001-example | active |`.
- Failure fixture: unsupported intent status exits 1 with an objective error.

### Approval Gate

- Prompt: "Check if the track is done."
- Approval selector: draft intent with approved closed spec+tasks and no `plan.md` exits 0; leftover `plan.md`, draft spec, draft tasks, and open tasks each exit 1.

### Spec Cycle

- Prompt: "Approve this spec."
- Required file: track-root `spec.md` with Files and Accept.
- Failure fixtures: approved tasks without `spec.md` exit 1; a leftover `spec/` directory without root `spec.md` exits 1; leftover root `plan.md` exits 1.

## Recorded Run

`run-evals.sh all` completed with all nine selectors passing on 2026-09-18.
