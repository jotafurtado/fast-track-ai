---
id: 005-spec-skill-owns-spec
status: accepted
date: 2026-09-20
owner: maintainer
---

# ADR: 005-spec-skill-owns-spec

## Context
`001-spec-md-owner` gave `fast-track-ai-intent` the spec template and had intent write `spec.md`. Track `008` unifies outcome and phases in one `spec.md` written by one skill.

## Decision
`fast-track-ai-spec` owns `assets/spec.md` and writes track-root `spec.md` plus `tasks.md`. `fast-track-ai-intent` drafts `intent.md` only and does not write `spec.md`.

## Rationale
Two files with one approval produced a draft spec after an approved plan. One writer and one approval close that gap.

## Alternatives considered
Keep two files and sync `status`. Rejected: the cause is two files, not the missing sync.

## Consequences
The intent-owned spec template is gone. Cross-skill paths that named `fast-track-ai-plan` now name `fast-track-ai-spec`.
