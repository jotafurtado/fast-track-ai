---
id: 002-assessment-standard
status: shipped
research: []
decisions: []
---

# Intent: Assessment Standard

## Problem
The method creates `fast-track-ai/assessments/` and ships a thin template (`captured`, `status`, `owner`, `scope`, Conclusion, Findings), but it does not define what an assessment is. There is no rule that distinguishes it from research or track `assets/`, no index presence, and no skill procedure that writes one. The only existing file, `fast-track-ai/assessments/2026-09-15-project-completeness.md`, therefore uses a location and frontmatter that were inferred rather than governed. The shipped template also carries a `status` field that the maintainer does not want.

## Proposed outcome
An assessment is research pointed inward: an evaluation of this method or of a target repository, stored at `fast-track-ai/assessments/<date>-<slug>.md`. External factual investigation stays in `fast-track-ai/research/`. Track-specific auxiliary output stays under the track `assets/`.

An assessment has no lifecycle `status`. It is raw input for a later intent. It is repository-wide and may optionally name one or more tracks.

The package has a written standard for when a write is an assessment, required English frontmatter without `status`, and how assessments relate to tracks and intents. `fast-track-ai/INDEX.md` lists assessments in a second table. No seventh skill is added: `fast-track-ai-init` owns the template; any skill or the agent files from that template when the work is an internal evaluation.

The existing completeness report is an input example, not the normative template. This track does not close its findings. It may drop `status` from that file so the example matches the standard.

## Users and systems
Method maintainers create assessments as inward research. Coding agents classify, store, discover, and cite them when drafting intents. Affected systems: `fast-track-ai/assessments/`, the init-owned template, `fast-track-ai-index.sh`, `INDEX.md`, the managed AGENTS block, the intent template's `research` field or an equivalent citation, and the six existing skills.

## Constraints
Do not give assessments a `status` field. Do not treat an assessment as a track or as an executable plan. Do not legitimize the completeness report format merely because it already exists. Keep user-facing package prose in English. Stay inside the six-skill package. Do not recreate `.specify/` or any Spec Kit view.

## Out of scope
Resolving findings inside `2026-09-15-project-completeness.md`. The ADR standard (`004`). Adding `fast-track-ai-assess`. Changing Matt Pocock skills. Rewriting frozen `001` prose. Changing how `fast-track-ai-plan` asks open intent questions (that is a separate track).

## Assumed state
On 2026-09-18 track `005` shipped `fast-track-ai/assessments/` and the thin template at `skills/fast-track-ai-init/assets/assessment.md` with frontmatter `captured`, `status`, `owner`, `scope`. The index lists tracks only and does not validate assessment files. On 2026-09-19 the maintainer decided: assessments are repository-wide with optional track links; no new skill; INDEX gets a second table; an assessment is inward research with no status and exists as input for an intent.

## Open questions
None.
