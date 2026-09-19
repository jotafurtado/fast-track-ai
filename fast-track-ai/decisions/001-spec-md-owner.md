---
id: 001-spec-md-owner
status: accepted
date: 2026-09-18
owner: maintainer
---

# ADR: 001-spec-md-owner

## Context
The catalog adds a required thin `spec.md` without adding a seventh skill.

## Decision
`fast-track-ai-intent` owns `assets/spec.md`. After intent approval it drafts `spec.md` and stops. `fast-track-ai-plan` requires that file and does not write it.

## Rationale
None

## Alternatives considered
None

## Consequences
The specify wrapper is replaced by a spec draft inside the intent skill, not by a new command.
