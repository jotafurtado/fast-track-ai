---
id: 007-refs-and-owned-review
status: shipped
research: []
assessments: []
refs: [code-review-skill]
decisions: []
---

# Intent: Refs and Owned Code Review

## Problem
`fast-track-ai/refs/` exists and the index requires `sha256` plus a 500 KB cap, but nothing says when a user-supplied source becomes a ref, what the file contains, or how an intent cites it. Track `004` only names an Obsidian clipping in Assumed state; the file was never stored. The implement skill then calls Matt Pocock `/code-review`, which expects `docs/agents/issue-tracker.md` and a user-supplied git fixed point. This package does not ship that layout, so the review step is skipped or faked.

## Proposed outcome
A user-supplied source is filed under `fast-track-ai/refs/<slug>.md` when it is the basis for a track. Two types:

- **inline**: the full durable text (for example an Obsidian Markdown note).
- **pointer**: a short Markdown file that says where to find the content (URL, pin, hash). Used for live online sources.

`refs/` stays immutable: source changed, new file. An intent cites those slugs in `refs:` so the later plan treats them as the review or design base. `research:` stays for investigation this package produced. `assessments:` stays for inward evaluations.

Implement stops calling Matt Pocock `code-review`. After the gate it runs a package-owned review step, adapted from `refs/code-review-skill` (principles, phases, severity labels). No seventh skill. The upstream language-guide tree is not vendored.

## Users and systems
Method maintainers hand over sources during intent. Coding agents file refs, cite them, and review implementations without Matt's tracker layout. Affected systems: `fast-track-ai/refs/`, intent template and skill, implement skill, index validation, managed AGENTS block, declared Matt dependencies.

## Constraints
Keep user-facing package prose in English. Stay inside the six-skill package. Do not vendor `awesome-skills/code-review-skill`. Do not require `docs/agents/issue-tracker.md`. Preserve `refs/` immutability and the 500 KB cap. Do not rewrite frozen `001` prose. Do not close `004` or `006`.

## Out of scope
The ADR standard (`004`). Plan asking open intent questions (`006`). Adding `fast-track-ai-review`. Installing or mirroring the upstream skill into the harness. Changing Matt Pocock `research`, `handoff`, or `grilling`.

## Assumed state
On 2026-09-19 the maintainer passed https://github.com/awesome-skills/code-review-skill as the review reference and decided: file such sources in `refs/`; an intent links them as the plan base; a ref is either the full note or a pointer Markdown; refs and owned review are one track; the GitHub skill is adapted into implement, not added as a seventh skill and not vendored. A pointer was filed at `fast-track-ai/refs/code-review-skill.md` (commit `4850184dfd7765ea7b3c5c4e9b6cf8e0815ee7cb`, sha256 of pinned `SKILL.md`). Catalog baseline from `005` still lists refs as index-validated `sha256` only. Implement step 6 still says `/code-review`.

## Open questions
None.
