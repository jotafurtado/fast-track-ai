---
id: 006-no-live-plan-md
status: accepted
date: 2026-09-20
owner: maintainer
---

# ADR: 006-no-live-plan-md

## Context
`002-historical-spec-dir` named track-root `plan.md` as authority with `spec.md` and `tasks.md`. Track `008` removes `plan.md` from the live cycle.

## Decision
`spec/` stays a historical leftover and never selects a cycle. Authority for a live track is track-root `spec.md` and `tasks.md`. A live track must not keep `plan.md`. Frozen `001` prose under `spec/` is not rewritten.

## Rationale
Phases live in `spec.md`. A leftover `plan.md` would split approval again.

## Alternatives considered
Keep `plan.md` as an alias of Phases. Rejected: two files with one approval.

## Consequences
The structural gate fails if `plan.md` is present on a live track. Historical `spec/plan.md` under `001` is still not executed.
