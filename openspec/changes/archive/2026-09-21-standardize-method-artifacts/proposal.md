# Proposal

## Why

The method stores five supporting artifact types, but their procedures and discovery rules are inconsistent: handoff and research depend on externally installed skills, assessment has no callable workflow, refs do not define inaccessible or unversioned sources, and ADR capture starts too late. Standardizing these contracts makes the package self-contained while keeping the user-facing process limited to three explicit actions.

## What Changes

- Define distinct contracts for refs, research, assessments, decisions, and handoffs, including origin, purpose, mutability, lifecycle, citation, and ownership.
- Add the seventh package skill and command, `fast-track-ai-assess`, for evidence-backed internal evaluation of a project, feature, or idea, with the evaluator recorded so another model can perform the assessment.
- Make `fast-track-ai-research` and `fast-track-ai-handoff` self-contained; remove runtime calls to Matt Pocock base skills while retaining licensed sources as documented inspiration.
- Give handoff, research, assessment, ref, and decision templates to the package skill that writes each artifact.
- Define objective ref handling for URLs, files, pasted text, mutable pages, licensing, hashes, pins, partial captures, and inaccessible sources.
- Capture qualifying accepted decisions during intent as well as spec; require implementation to pause and reconcile approved planning artifacts when a new decision changes scope or design.
- Expand generated `INDEX.md` so all five supporting artifact types are discoverable and structurally validated.
- Document upstream inspirations and their verified MIT or Apache-2.0 licenses; treat incompatible or unlicensed content as pointer-only conceptual references.
- **BREAKING**: replace research frontmatter `source` and `status: raw` with a status-free multi-source research contract.
- **BREAKING**: expand the generated `INDEX.md` table layout and move ref and assessment template ownership to their actual writer skills.

## Capabilities

### New Capabilities

- `method-artifacts`: Defines the behavior, workflows, ownership, validation, discovery, provenance, and licensing boundaries for refs, research, assessments, decisions, and handoffs.

### Modified Capabilities

None. This project has no existing OpenSpec capability specs.

## Impact

- Affected package skills: init, intent, spec, implement, research, handoff, and new assess.
- Affected commands: research, handoff, intent, spec, implement, and new assess.
- Affected resources: templates, managed AGENTS block, index generator, installer discovery, eval fixtures, and source-attribution documentation.
- Affected target-repository artifacts: `fast-track-ai/INDEX.md`, `refs/`, `research/`, `assessments/`, `decisions/`, `handoffs/`, and intent citation fields.
- No third-party runtime dependency is added. The repository's own license remains outside this change.
