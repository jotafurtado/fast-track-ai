---
id: 009-track-terminal-states
status: draft
research: []
assessments: [2026-09-15-project-completeness]
refs: []
decisions: []
---

# Intent: Track Terminal States

## Problem
The catalog already allows intent `status: draft | active | shipped | dropped | superseded`, and `superseded_by` when superseded. Implement step 7 closes tasks, regenerates `INDEX.md`, and stops: it never marks shipped without explicit approval. There is no written procedure for that approval, or for `dropped` and `superseded`. The 2026-09-15 completeness assessment recorded this as a medium-priority finding. Tracks `001`, `002`, and `005` were moved to `shipped` by hand on 2026-09-19 after the user noticed the INDEX still said `active`.

Closed tasks plus a green gate do not mean `active`. Leaving them `active` makes the INDEX lie.

## Proposed outcome
A track leaves `active` only through an explicit maintainer command, recorded on the intent and then in `INDEX.md`.

- **`shipped`**: tasks have no open items, the structural gate passes, and the maintainer approves the ship. Implement asks for that approval at the end and, only then, sets intent `status: shipped` and regenerates the index. Checkboxes alone never ship.
- **`dropped`**: the maintainer abandons the work. Implementation is not required. The intent stays the record; `003` is the existing example.
- **`superseded`**: the maintainer names the replacement in `superseded_by`. The index already fails a superseded track that lacks that field.

No seventh skill. Implement owns `shipped`. Intent (or the agent following the managed AGENTS rule) owns `dropped` and `superseded`. The three already-shipped tracks are not rewritten.

## Users and systems
Method maintainers close or abandon tracks. Coding agents set intent status and regenerate the index. Affected systems: `fast-track-ai-implement`, the intent document, `fast-track-ai-index.sh`, `INDEX.md`, the managed AGENTS block.

## Constraints
Keep user-facing package prose in English. Stay inside the six-skill package. Do not auto-ship. Do not invent `superseded_by`. Do not rewrite frozen `001` prose. Do not close `004`, `006`, `007`, or `008`. Validate method changes in `/tmp`.

## Out of scope
Unified spec and the plan-skill rename (`008`). Plan asking open intent questions (`006`). Refs and owned review (`007`). ADR standard (`004`). Resolving other findings in `2026-09-15-project-completeness.md`. Adding `fast-track-ai-assess`.

## Assumed state
On 2026-09-19 the maintainer shipped `001`, `002`, and `005` by hand and asked to open this track rather than fold it into `008`. Catalog from `005` already lists the five intent statuses. Index already validates those statuses and requires `superseded_by` when superseded. Implement already says never mark shipped without explicit approval, but does not say how to ask or which files to write.

## Open questions
None.
