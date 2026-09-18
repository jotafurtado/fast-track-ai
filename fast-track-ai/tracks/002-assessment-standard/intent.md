---
id: 002-assessment-standard
status: draft
research: []
decisions: []
---

# Intent: Assessment Standard

## Problem
The method creates `dot-ai/assessments/` and exposes it through `.specify/assessments`, but no norm, domain definition, metadata contract, lifecycle, or responsible skill explains what an assessment is. The existing project-completeness report therefore uses a location and frontmatter that were inferred rather than governed.

## Proposed outcome
The method has an explicit assessment standard that defines when an internal evaluation qualifies as an assessment, distinguishes it from research and track assets, gives it a canonical location and lifecycle, and makes its provenance and relationship to tracks unambiguous.

## Users and systems
Method maintainers create and review assessments. Coding agents must classify, store, discover, and update them consistently. The affected systems are the dot-ai knowledge tree, initialization, indexing, Spec Kit integration, skills, and the binding method norm.

## Constraints
Preserve the rule that external factual investigation belongs in `research/` and track-specific auxiliary output belongs under the track `assets/` unless the assessment standard establishes a stronger ownership rule. Do not legitimize the existing report format merely because it already exists. Keep the package portable and user-facing package prose in English.

## Out of scope
Resolving the findings inside the current completeness report, redesigning unrelated track states, and changing third-party Spec Kit behavior are outside this track.

## Assumed state
`dot-ai/assessments/` and `.specify/assessments` are provisional structures without an approved semantic contract. `dot-ai/assessments/2026-09-15-project-completeness.md` is an input example, not a normative template.

## Open questions
- Must every assessment belong to one track, or may repository-wide assessments exist? Owner: maintainer.
- Which metadata and lifecycle states are required? Owner: maintainer.
- Does assessment creation need a dedicated `dot-ai-assess` skill? Owner: maintainer.
- Should assessments appear in `dot-ai/INDEX.md`? Owner: maintainer.
- Should `.specify/assessments` remain a supported view? Owner: maintainer.
