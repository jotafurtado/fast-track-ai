---
id: 004-adr-standard
status: shipped
research: []
assessments: []
refs: []
decisions: []
---

# Intent: ADR Standard

## Problem
The method exposes `fast-track-ai/decisions/` and a thin track-level `decisions.md` template (`id`, `status`, `date`, `owner`, Context, Decision, Consequence), but it does not define what qualifies as an Architecture Decision Record, how records are identified, when an agent must capture a user decision, or how an intent cites one. Durable choices therefore live in conversation or as an unstructured track note. The directory `fast-track-ai/decisions/` is empty. Track `005` already has four complete records in `decisions.md`.

## Proposed outcome
A qualifying decision is durable, costly to reverse, surprising without context, or the result of a meaningful trade-off. Capture is mandatory once the maintainer decides such a matter. Trivial wording, formatting, and easily reversible operational choices are not ADRs.

An ADR is repository-wide, stored at `fast-track-ai/decisions/<NNN-slug>.md`. An intent may cite zero or more slugs in `decisions:`. There is no required track-owned `decisions.md`. The directory name stays `decisions`; ADR is the document standard.

A file exists only after the decision is made. Allowed `status` values are `accepted` and `superseded`. Accepted Decision text is immutable. A change is a new ADR that supersedes the old one (`superseded_by` on the old file). Typos outside the Decision section may be fixed; the Decision section is not rewritten.

Each ADR keeps English frontmatter and sections: context, decision, rationale, alternatives considered, consequences, status, owner, date, and references when they exist.

`fast-track-ai/INDEX.md` lists ADRs in a third table (`decision`, `status`). The index validates required fields and the two statuses.

Existing complete records (context, decision, consequence already present) may be promoted into `fast-track-ai/decisions/` without inventing missing alternatives or rationale. Conversation-only choices stay unfiled unless the maintainer restates them. `005`'s four records qualify for promotion.

When the user makes a qualifying decision during a later track, the agent files the ADR without a separate request.

## Users and systems
Project maintainers make and review decisions. Coding agents detect qualifying decisions, file them, cite them on intents, and refuse to relitigate an accepted ADR. Affected systems: `fast-track-ai/decisions/`, the plan-owned decisions template, intent `decisions:` field, `fast-track-ai-index.sh`, `INDEX.md`, the managed AGENTS block, and live track `decisions.md` files that already have complete records.

## Constraints
Keep user-facing package prose in English. Stay inside the six-skill package. Do not create an `adrs/` directory. Do not give ADRs a `proposed` status. Do not edit accepted Decision text. Do not invent alternatives or rationale on promotion. Do not rewrite frozen `001` prose. Do not close `006`, `007`, `008`, or `009`. The AGENTS rule "a recorded decision is never relitigated" stays.

## Out of scope
Writing ADRs for trivial preferences. Resolving findings in `2026-09-15-project-completeness.md` other than the missing decision standard. Changing third-party ADR tools. Unified spec (`008`). Track terminal states (`009`). Refs standard (`007`) beyond citing existing slugs. Filing the Obsidian ADR clipping as a ref (no file was handed over).

## Assumed state
On 2026-09-18 track `005` shipped the empty directory `fast-track-ai/decisions/` and the thin template at `skills/fast-track-ai-plan/assets/decisions.md`. On 2026-09-19 the maintainer decided: ADRs are repository-wide with optional track cites; statuses are `accepted | superseded` only; accepted Decision text is immutable and a change is a new ADR; INDEX gets a third table; promote only records that already have context, decision, and consequence. The Obsidian clipping `Guia Completo sobre Architecture Decision Records (ADR): Definição e Melhores Práticas`, by Jhony Walker, remains a named input in this intent and is not yet a file under `fast-track-ai/refs/`.

## Open questions
None.
