---
status: approved
---

# Tasks: 009-track-terminal-states

- [x] T001 Teach implement to ask for an explicit ship after the gate and review, then set intent `status: shipped` and regenerate `INDEX.md`. Files: `skills/fast-track-ai-implement/SKILL.md`, `commands/fast-track-ai-implement.md`. Validate: both name the ship ask and `status: shipped`; both still forbid shipping from checkboxes alone.
- [x] T002 Teach the intent skill how a maintainer sets `dropped` (abandon, no implementation) and `superseded` (requires `superseded_by`). Files: `skills/fast-track-ai-intent/SKILL.md`. Validate: skill names `dropped`, `superseded`, and `superseded_by`.
- [x] T003 Add the same `dropped` / `superseded` rule to the managed AGENTS snippet and this repo's managed block. Files: `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`. Validate: both name `dropped` and `superseded_by`; `AGENTS.md` still has one managed block.
- [x] T004 Run init and index on a scratch copy in `/tmp`; inject `status: superseded` without `superseded_by` and confirm index fails. Files: none in this repo. Validate: first index exits 0; after injection, index exits 1.

Auxiliary output files go under `assets/`, never loose at the track root.
