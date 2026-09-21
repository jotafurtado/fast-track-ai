---
id: 007-dedicated-assessment-skill
status: accepted
date: 2026-09-20
owner: maintainer
evidence:
  - fast-track-ai/tracks/002-assessment-standard/intent.md
  - fast-track-ai/research/artifact-standards.md
  - openspec/changes/standardize-method-artifacts/design.md
---

# ADR: 007-dedicated-assessment-skill

## Context

Track 002 established assessments as status-free, repository-wide inward evaluations and intentionally kept them inside the six-skill package. That track also recorded a dedicated `fast-track-ai-assess` action as out of scope. The later artifact-standardization research found that the init-owned thin template had no callable workflow and could not consistently require criteria, counterevidence, evaluator identity, limitations, or recommendations across models and harnesses.

## Decision

Add `fast-track-ai-assess` as the seventh package skill with its own command and assessment template. Keep assessment explicitly invoked and read-only toward the assessed subject. The workflow writes one evidence-backed artifact under `fast-track-ai/assessments/` and does not automatically create an intent.

## Rationale

A dedicated package workflow makes invocation portable and enforces the evidence contract without relying on unrelated machine state. The additional skill entry is smaller and more reliable than distributing assessment rules across init or expecting each host agent to infer them.

## Alternatives considered

- Keep the Track 002 approach and let init own a thin template. Rejected because init does not perform assessments and the template alone does not define an evaluation procedure.
- Depend on an externally installed assessment or review skill. Rejected because package behavior would vary by machine and harness.
- Make assessment mandatory before every intent. Rejected because assessment is useful input, not a universal lifecycle gate.

## Consequences

The package installs seven skills. `fast-track-ai-assess` owns the assessment procedure and template; init only creates directories, manages the AGENTS block, and generates the index. Existing assessments must satisfy the richer metadata contract, while later intents continue citing them through `assessments:`.

## Evidence

- `fast-track-ai/tracks/002-assessment-standard/intent.md` records the earlier rationale and six-skill constraint; it is historical context, not a superseded ADR.
- `fast-track-ai/research/artifact-standards.md` documents the evaluator, evidence, counterevidence, limitations, recommendation, portability, and ownership findings.
- `openspec/changes/standardize-method-artifacts/design.md` records the accepted owner model and explicit assessment action.
