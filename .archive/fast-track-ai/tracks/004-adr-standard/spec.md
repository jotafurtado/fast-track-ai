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

The spec-owned template at `skills/fast-track-ai-spec/assets/decisions.md` is the per-file ADR template, not a track log. `fast-track-ai-intent` cites existing ADRs in `decisions:`. The managed AGENTS block says a recorded Decision is never relitigated and names the path.

The four complete records in `fast-track-ai/tracks/005-lightweight-sdlc/decisions.md` are promoted to `fast-track-ai/decisions/` with their existing Context, Decision, and Consequence. Missing rationale and alternatives are `None`. Conversation-only choices stay unfiled. The 005 track file may remain as a historical list; it is not the source of truth after promotion.

## Cycle

intent.md (draft allowed) → `fast-track-ai-spec` drafts `spec.md` and `tasks.md` → approval → implement.

## Phases

### Phase 1: ADR template and filing rule
Done: The plan-owned template is one file per ADR (`id`, `status`, `date`, `owner`, Context, Decision, Rationale, Alternatives considered, Consequences). Plan and implement tell the agent when a write is a qualifying decision and where to file it.
Files: `skills/fast-track-ai-plan/assets/decisions.md`, `skills/fast-track-ai-plan/SKILL.md`, `skills/fast-track-ai-implement/SKILL.md`
Accept: Template greps have no track-log heading; skill texts name `fast-track-ai/decisions/<NNN-slug>.md` and `accepted | superseded`.

### Phase 2: Index third table
Done: `fast-track-ai-index.sh` still writes tracks and assessments, then a decisions table (`decision`, `status`). It validates ADR files and fails on `proposed`, missing required fields, or `superseded` without `superseded_by`.
Files: `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`
Accept: A scratch tree with one valid ADR lists it; a file with `status: proposed` makes the index exit 1.

### Phase 3: Intent citation and AGENTS rule
Done: Intent skill cites ADRs in `decisions:`. Managed AGENTS block names `fast-track-ai/decisions/` and repeats that a recorded Decision is never relitigated.
Files: `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`
Accept: Skill text names `decisions:` and `fast-track-ai/decisions/`; both AGENTS files name that path; `AGENTS.md` still has one managed block.

### Phase 4: Promote complete 005 records
Done: Four ADR files exist under `fast-track-ai/decisions/` for the 005 records. Rationale and Alternatives are `None`. Decision text matches the 005 source. The 005 `decisions.md` is not rewritten as the source of truth. `005` intent `decisions:` lists the four slugs.
Files: `fast-track-ai/decisions/001-spec-md-owner.md`, `fast-track-ai/decisions/002-historical-spec-dir.md`, `fast-track-ai/decisions/003-live-evals-vs-frozen-spec.md`, `fast-track-ai/decisions/004-drop-vendored-speckit.md`, `fast-track-ai/tracks/005-lightweight-sdlc/intent.md`, `fast-track-ai/INDEX.md`
Accept: Index decisions table has those four rows at `accepted`; each Decision paragraph equals the 005 source; `grep` of those files finds `Rationale` and `Alternatives considered` as `None`.

### Phase 5: Scratch validation
Done: Init, index, and one accepted ADR are green in `/tmp`. A second init stays idempotent. Injecting `status: proposed` makes index exit 1. This repo is not the scratch target.
Files: none in this repo beyond reading the scripts above
Accept: Scratch index exits 0 with three tables; `status: proposed` then exits 1.

## Constraints

Keep user-facing package prose in English. Stay inside the six-skill package. Do not create an `adrs/` directory. Do not give ADRs a `proposed` status. Do not edit accepted Decision text. Do not invent alternatives or rationale on promotion. Do not rewrite frozen `001` prose. Do not close `006`, `007`, `008`, or `009`. Validate method changes in `/tmp`.

## Out of scope

Writing ADRs for trivial preferences. Resolving findings in `2026-09-15-project-completeness.md` other than the missing decision standard. Changing third-party ADR tools. Unified spec (`008`). Track terminal states (`009`). Refs standard (`007`) beyond citing existing slugs. Filing the Obsidian ADR clipping as a ref.
