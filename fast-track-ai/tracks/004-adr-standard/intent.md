---
id: 004-adr-standard
status: draft
research: []
decisions: []
---

# Intent: ADR Standard

## Problem
The method exposes `dot-ai/decisions/` and a track-level `decisions.md` template, but it does not define what qualifies as a decision record, how decisions are identified, which context and alternatives must be preserved, or when an agent must capture a user decision. As a result, durable architectural knowledge can remain only in conversation history or be recorded as an unstructured note.

## Proposed outcome
All durable architectural and method-governance decisions are represented as Architecture Decision Records stored under the existing `dot-ai/decisions/` directory. The directory name remains `decisions`; ADR defines the document standard, not a replacement directory name. Each ADR preserves the context, decision, rationale, alternatives considered, consequences, status, ownership, date, and references needed for future maintainers to understand why the choice was made. When the user makes an architecturally significant decision, the agent creates or updates the corresponding ADR without requiring a separate request.

## Users and systems
Project maintainers make and review decisions. Coding agents detect qualifying decisions, capture them, link them to tracks, and consult existing ADRs before reopening settled questions. The affected systems are the dot-ai domain model, decision storage, track references, templates, index, installed AGENTS rules, and implementation workflow.

## Constraints
Use ADR as the canonical decision artifact while retaining `dot-ai/decisions/` as the canonical directory. Do not introduce an `adrs/` directory. A qualifying decision must be durable, costly to reverse, surprising without context, or the result of a meaningful trade-off; trivial wording, formatting, and easily reversible operational choices must not generate ADR noise. Once the user explicitly decides a qualifying matter, capture is mandatory rather than optional. Preserve a unique identifier and traceable lifecycle for every ADR. Frontmatter keys and structural values remain in English, and the Markdown template structure remains in English even when the user chooses another language for document content.

## Out of scope
Writing ADRs for trivial preferences, resolving the findings of existing assessments, changing third-party ADR tools, and deciding unrelated architecture questions are outside this track.

## Assumed state
The Obsidian clipping `Guia Completo sobre Architecture Decision Records (ADR): Definição e Melhores Práticas`, by Jhony Walker, is an input source. It defines ADRs as structured records of architectural decisions and recommends consistent sections, unique numbering, traceability, versioning, rationale, alternatives, consequences, maintenance, and accessible sharing. `dot-ai/decisions/` is the retained canonical directory. Its document format and the track-level `decisions.md` structure are provisional and require migration into the approved ADR model.

## Open questions
- Are ADRs repository-wide, track-owned, or repository-wide records referenced by tracks? Owner: maintainer.
- Which statuses and transition rules govern an ADR? Owner: maintainer.
- Are accepted ADRs immutable and superseded by new records, or may their decision text be edited? Owner: maintainer.
- Should `dot-ai/INDEX.md` include an Architecture Decision Log? Owner: maintainer.
- How should existing decisions and conversation-derived decisions be migrated without fabricating alternatives or rationale? Owner: maintainer.
