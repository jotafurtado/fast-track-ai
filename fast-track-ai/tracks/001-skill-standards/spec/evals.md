# Evals: Skill Standards Compliance

**Date**: 2026-09-20

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
| `index` | Valid fixtures appear in track, ref, research, assessment, decision, and active-handoff tables; archived handoffs are absent; invalid type-specific invariants fail; unchanged output is byte-identical | 0 | PASS |
| `approval` | Draft intent with approved closed spec/tasks passes; leftover `plan.md`, unapproved spec/tasks, and open tasks fail | 0 | PASS |
| `install` | Default and custom agents/Claude directories contain seven resolving `fast-track-ai-*` skill links and no `shared` link | 0 | PASS |
| `audit` | The frozen six-skill historical audit still contains exactly 36 evidence-backed skill-rule verdicts | 0 | PASS |
| `resources` | Every owned script and template has exactly one owner guidance reference; removed init templates are absent | 0 | PASS |
| `workflows` | Research, assessment, and handoff are self-contained, status-free where required, conform to their schemas, and respect source-license boundaries | 0 | PASS |
| `refs` | Ref instructions cover inline, pinned pointer, mutable pointer replacement, candidate-hash reuse, persisted duplicate rejection, locator hashes, and unavailable sources | 0 | PASS |
| `decisions` | Intent distinguishes qualifying from local choices; evidence citations, material planning-drift approval rules, immutable original ADR content, and `superseded_by` replacement are covered | 0 | PASS |
| `handoff` | A four-file fixture keeps the newest three active, archives the oldest, preserves exact instructions, and excludes archive from INDEX | 0 | PASS |
| `spec` | Required track-root `spec.md` is enforced; `spec/` without `spec.md` fails; approved closed tracks with `spec.md` pass | 0 | PASS |
| `contract` | Package contract records seven skills, owner paths, single template ownership, self-contained workflows, and deterministic artifact schemas | 0 | PASS |

## Behavioral Fixtures

### Init

- Prompt: "Setup fast-track-ai here."
- Expected files: `fast-track-ai/{research,refs,handoffs/archive,assessments,decisions,tracks}/`, `fast-track-ai/INDEX.md`, and one managed block in `AGENTS.md`.
- Expected exit: 0, twice in a row (idempotent).
- A pre-existing `specs/` directory is left untouched and does not block init.

### Index

- Prompt: "Regenerate the index."
- Expected tables: tracks, refs, research, assessments, decisions, and active handoffs.
- Valid fixtures: inline ref, pinned pointer, mutable pointer and replacement, candidate hash matching an existing slug without a duplicate file, multi-source research, assessment, accepted decision, superseded decision with replacement, and active handoff.
- Determinism: two unchanged runs produce byte-identical `INDEX.md`; archived handoffs are absent.

### Approval Gate

- Prompt: "Check if the track is done."
- Approval selector: draft intent with approved closed spec+tasks and no `plan.md` exits 0; leftover `plan.md`, draft spec, draft tasks, and open tasks each exit 1.

### Spec Cycle

- Prompt: "Approve this spec."
- Required file: track-root `spec.md` with Files and Accept.
- Failure fixtures: approved tasks without `spec.md` exit 1; a leftover `spec/` directory without root `spec.md` exits 1; leftover root `plan.md` exits 1.

## Recorded Run

`run-evals.sh all` completed with all thirteen selectors passing on 2026-09-20.
