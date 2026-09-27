# Evals: Skill Standards Compliance

**Date**: 2026-09-27

## Executable Runner

Run every deterministic check from the repository root:

```bash
bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all
```

Run one selector by replacing `all` with its name. Every selector uses a fresh temporary fixture and removes it on exit.

| Selector | Observable Contract | Expected Exit | Result |
|----------|---------------------|---------------|--------|
| `self` | Runner and every published shell script pass `bash -n`; repository validation does not mask gate failures | 0 | PASS |
| `init` | Empty target receives the canonical tree; reruns are byte-identical; outdated managed blocks refresh without changing surrounding bytes; malformed markers fail before tree creation; symlink targets remain symlinked | 0 | PASS |
| `index` | Valid artifacts and citation links appear in deterministic tables; handoffs sort by captured instant; orphan tracks, dangling citations/replacements, a loose `tracks/<id>.md` as intent replacement, malformed flow lists, invalid handoff timestamps, and more than three active handoffs fail without changing INDEX.md | 0 | PASS |
| `approval` | Completion remains the default and requires approved artifacts and closed tasks; structure mode accepts draft/open tracks; unknown modes fail; shipped tracks 008-010 pass completion | 0 | PASS |
| `install` | Default and custom agents/Claude directories contain seven resolving `fast-track-ai-*` skill links, seven command files, and no `shared` link | 0 | PASS |
| `audit` | The frozen six-skill historical audit still contains exactly 36 evidence-backed skill-rule verdicts | 0 | PASS |
| `resources` | Every owned script and template has exactly one owner guidance reference; removed init templates are absent | 0 | PASS |
| `workflows` | Research, assessment, and handoff are self-contained, status-free where required, conform to their schemas, and respect source-license boundaries | 0 | PASS |
| `refs` | Ref instructions cover inline, pinned pointer, mutable pointer replacement, candidate-hash reuse, persisted duplicate rejection, locator hashes, and unavailable sources | 0 | PASS |
| `decisions` | Intent distinguishes qualifying from local choices; evidence citations, material planning-drift approval rules, immutable original ADR content, and `superseded_by` replacement are covered | 0 | PASS |
| `handoff` | Four mixed legacy/new-format handoffs are ordered by captured instant; the oldest is archived, the newest three remain active, and the archive is absent from INDEX | 0 | PASS |
| `spec` | Structure checks require phases, non-empty phase fields, tasks, per-task fields, and valid unique acyclic groups; intent IDs must match track directories; ungrouped legacy tasks pass | 0 | PASS |
| `contract` | Package contract records seven skills, owner paths, single template ownership, self-contained workflows, and deterministic artifact schemas | 0 | PASS |
| `flow` | Intent, spec, and implement skills plus the tasks template contain continuous-flow next-step lines, the non-implementation exit, `## Group`, and `(depends:` | 0 | PASS |

## Behavioral Fixtures

### Init

- Prompt: "Setup fast-track-ai here."
- Expected files: `fast-track-ai/{research,refs,handoffs/archive,assessments,decisions,tracks}/`, `fast-track-ai/INDEX.md`, and one managed block in `AGENTS.md`.
- Expected exit: 0, twice in a row (idempotent).
- An outdated managed block between user text is replaced while the surrounding bytes remain unchanged. Begin-without-end, duplicated, or out-of-order markers exit 1 without writing or creating the tree; a symlinked `AGENTS.md` remains a symlink. A pre-existing `specs/` directory is left untouched.

### Index

- Prompt: "Regenerate the index."
- Expected tables: tracks, refs, research, assessments, decisions, and active handoffs; active handoffs are ordered by `captured` instant.
- Valid fixtures: inline refs with and without a blank separator, pinned pointer, mutable pointer and replacement, multi-source research, assessment, accepted decision, superseded decision with replacement, superseded intent pointing at `tracks/<id>/intent.md`, and active handoff. Two unchanged runs are byte-identical; archived handoffs are absent.
- Failure fixtures include an invalid research artifact after a valid index: the command exits 1, preserves `INDEX.md` byte-for-byte, reports that the index was not updated, and removes its temporary file. Cross-link and handoff integrity failures name the affected artifact and rule. A loose `tracks/<id>.md` does not satisfy an intent `superseded_by`.

### Approval Gate

- Prompt: "Check if the track is done."
- Approval selector: draft intent with approved closed spec+tasks and no `plan.md` exits 0; leftover `plan.md`, unapproved spec/tasks, and open tasks each exit 1. Structure mode accepts the same draft status and open task state; unknown mode and mismatched intent id fail.

### Spec Cycle

- Prompt: "Approve this spec."
- Required file: track-root `spec.md` with at least one `### Phase` and non-empty `Done:`, `Files:`, and `Accept:` in each phase.
- Failure fixtures: approved tasks without `spec.md`, `spec/` without root `spec.md`, no phase, empty phase `Accept:`, no tasks, a task missing `Validate:`, unknown/self/duplicate group dependencies, dependency cycles, task before first group, mismatched intent ID, and leftover root `plan.md`.

## Recorded Run

`run-evals.sh all` completed with all fourteen selectors passing on 2026-09-27.
