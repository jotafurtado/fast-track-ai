---
status: approved
---

# Spec: 004-adr-standard

Thin product description owned by this package. Not a Spec Kit artifact.

## Outcome

A qualifying decision is durable, costly to reverse, surprising without context, or the result of a meaningful trade-off. Once the maintainer decides such a matter, the agent files an ADR without a separate request. Trivial wording, formatting, and easily reversible operational choices are not ADRs.

Location: `fast-track-ai/decisions/<NNN-slug>.md`. Repository-wide. An intent cites zero or more slugs in `decisions:`. There is no required track-owned `decisions.md`. The directory name stays `decisions`.

A file exists only after the decision is made. Allowed `status` values: `accepted`, `superseded`. Required English frontmatter: `id` (equals filename stem), `status`, `date`, `owner`. Optional: `superseded_by` (required when `status: superseded`). Forbidden: `proposed`.

Required English body sections: Context, Decision, Rationale, Alternatives considered, Consequences. Rationale and Alternatives may be the single word `None` when they were never recorded. They must not be invented on promotion.

Accepted Decision text is immutable. A change is a new ADR; the old file becomes `superseded` with `superseded_by`. Typos outside the Decision section may be fixed.

`fast-track-ai/INDEX.md` has three tables: tracks (`track`, `status`), assessments (`assessment`, `captured`), decisions (`decision`, `status`). The index validates every ADR file: required fields, allowed statuses, `id` equals stem, and `superseded_by` when superseded.

The plan-owned template at `skills/fast-track-ai-plan/assets/decisions.md` is the per-file ADR template, not a track log. `fast-track-ai-intent` cites existing ADRs in `decisions:`. The managed AGENTS block says a recorded Decision is never relitigated and names the path.

The four complete records in `fast-track-ai/tracks/005-lightweight-sdlc/decisions.md` are promoted to `fast-track-ai/decisions/` with their existing Context, Decision, and Consequence. Missing rationale and alternatives are `None`. Conversation-only choices stay unfiled. The 005 track file may remain as a historical list; it is not the source of truth after promotion.

## Cycle

intent (`status: active`) → this `spec.md` → approved `plan.md` and `tasks.md` → implement.

## Constraints

Keep user-facing package prose in English. Stay inside the six-skill package. Do not create an `adrs/` directory. Do not give ADRs a `proposed` status. Do not edit accepted Decision text. Do not invent alternatives or rationale on promotion. Do not rewrite frozen `001` prose. Do not close `006`, `007`, `008`, or `009`. Validate method changes in `/tmp`.

## Out of scope

Writing ADRs for trivial preferences. Resolving findings in `2026-09-15-project-completeness.md` other than the missing decision standard. Changing third-party ADR tools. Unified spec (`008`). Track terminal states (`009`). Refs standard (`007`) beyond citing existing slugs. Filing the Obsidian ADR clipping as a ref.
