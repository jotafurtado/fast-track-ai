---
id: 004-drop-vendored-speckit
status: accepted
date: 2026-09-18
owner: maintainer
---

# ADR: 004-drop-vendored-speckit

## Context
This repo vendors Spec Kit under `.specify/` and exposes `specs -> dot-ai/specs`.

## Decision
Remove the Spec Kit integration and the vendored `.specify/` tree from this repo. Move any still-live constitution rules into the managed AGENTS block. Drop the constitution eval that reads `.specify/memory/constitution.md`.

## Rationale
None

## Alternatives considered
None

## Consequences
Init and evals no longer mention `.specify` or `specs/`.
