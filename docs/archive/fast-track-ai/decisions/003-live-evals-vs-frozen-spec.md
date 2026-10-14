---
id: 003-live-evals-vs-frozen-spec
status: accepted
date: 2026-09-18
owner: maintainer
---

# ADR: 003-live-evals-vs-frozen-spec

## Context
The only executable package suite lives under `001-skill-standards/spec/assets/run-evals.sh` and `spec/evals.md`. The intent freezes that spec as historical.

## Decision
Leave `spec.md`, `audit.md`, `plan.md`, `tasks.md`, `research.md`, `data-model.md`, and related 001 prose frozen. Update `run-evals.sh` and the `evals.md` selector table because they are live package tests, not historical narrative. Replace the `specify` selector with a `spec.md` cycle selector.

## Rationale
None

## Alternatives considered
None

## Consequences
001 prose and the live runner may disagree. The runner is the package contract.
