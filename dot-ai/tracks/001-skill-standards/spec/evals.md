# Evals: Skill Standards Compliance

**Date**: 2026-09-16

## Executable Runner

Run every deterministic check from the repository root:

```bash
bash dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all
```

Run one selector by replacing `all` with its name. Every selector uses a fresh temporary fixture and removes it on exit.

| Selector | Observable Contract | Expected Exit | Result |
|----------|---------------------|---------------|--------|
| `self` | Runner and every published shell script pass `bash -n`; repository validation does not mask gate failures | 0 | PASS |
| `init` | Empty target receives the canonical tree and one managed block; second run is idempotent; conflicting `specs/` fails before writes | 0 | PASS |
| `index` | Active track is indexed; invalid status is rejected | 0 | PASS |
| `constitution` | Principle III requires owner copies and no load-bearing `shared` link | 0 | PASS |
| `approval` | Draft intent, unapproved plan/tasks, and open short/full-cycle tasks fail; approved closed tracks pass | 0 | PASS |
| `install` | Default and custom agents/Claude directories contain six resolving skill links and no `shared` link | 0 | PASS |
| `audit` | Exactly 36 unique skill-rule verdicts contain evidence quotes | 0 | PASS |
| `resources` | Every owned script and asset has explicit skill guidance | 0 | PASS |
| `specify` | Active complete intent routes `/speckit.specify` to the canonical track spec; draft and malformed tracks fail | 0 | PASS |
| `contract` | Package path contract permits sibling owner paths and rejects machine-fixed paths | 0 | PASS |

## Behavioral Fixtures

### Init

- Prompt: "Setup dot-ai here."
- Expected files: `dot-ai/{research,refs,handoffs/archive,assessments,decisions,tracks,specs}/`, `specs` symlink, `dot-ai/INDEX.md`, and one managed block in `AGENTS.md`.
- Expected exit: 0, twice in a row (idempotent).
- Failure fixture: an existing non-canonical `specs/` directory exits 1 without creating `dot-ai/`.

### Index

- Prompt: "Regenerate the index."
- Expected row: `| 001-example | active | rapida |`.
- Failure fixture: unsupported intent status exits 1 with an objective error.

### Approval Gate

- Prompt: "Check if the track is done."
- Approval selector: draft intent, draft plan, draft tasks, open short-cycle tasks, and open full-cycle tasks each exit 1; approved closed short and full cycles each exit 0.

### Spec Kit Bridge

- Prompt: "Start the full Spec Kit cycle for this approved intent."
- Expected command: `/speckit.specify --number 1 --short-name example --allow-existing-branch`.
- Expected files: canonical `spec/`, `dot-ai/specs/<track>` view, and `.specify/feature.json`.
- Failure fixtures: draft intent and malformed track id exit 1 before creating `spec/`.

## Recorded Run

`run-evals.sh all` completed with all ten selectors passing on 2026-09-16.
