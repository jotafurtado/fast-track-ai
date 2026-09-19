---
id: 002-historical-spec-dir
status: accepted
date: 2026-09-18
owner: maintainer
---

# ADR: 002-historical-spec-dir

## Context
`001-skill-standards` already has a Spec Kit `spec/` tree. The new gate must not treat `spec/` as a second cycle.

## Decision
`spec/` is allowed as a historical leftover and never selects a cycle. Authority is always track-root `spec.md`, `plan.md`, and `tasks.md`. Track `001` receives a thin root `spec.md` that points at the frozen `spec/` directory.

## Rationale
None

## Alternatives considered
None

## Consequences
Existing `spec/plan.md` and `spec/tasks.md` are not executed.
