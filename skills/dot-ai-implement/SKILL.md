---
name: dot-ai-implement
description: Implement a track task by task with validation, review, and final gate. Use when plan and tasks are approved and the user says "implement this", "build the track", or "execute the plan". Never run before plan approval.
---

1. Read `dot-ai/tracks/NNN-slug/intent.md`, `plan.md`, and `tasks.md` in the target repo. Require intent `status: active` plus approved `plan.md` and `tasks.md`. If `spec/` exists, execute `spec/tasks.md` as source and mirror status to track `tasks.md`.
2. Respect boundaries. Touch ONLY files listed in the plan Files and each task's Files. Auxiliary outputs go under `assets/`, never loose at the track root. Never implement items in `out_of_scope`. Never question `assumed_state`. If a task needs an unlisted file or an out-of-scope item becomes necessary, stop and ask before touching anything.
3. Create ALL tasks upfront in TodoWrite from the task list, with phase tags.
4. Use subagents when possible. Independent tasks go to parallel subagents, one task per agent. Dependent tasks run in sequence. Never parallelize edits to the same file. The main agent owns integration, shared files, and final validation.
5. Validate before marking complete. Run each task's Validate command. Run typechecking regularly, single test files regularly, full suite once at the end. Never mark a task complete on an untested change.
6. After all tasks, run `../dot-ai-plan/scripts/sdd-gate.sh --track NNN-slug --root <target>` (owner copy, referenced by package-relative path), then `/code-review`. Report diff stat, deviations from the plan, and new patterns found.
7. Update task checkboxes, regenerate `dot-ai/INDEX.md` with `../dot-ai-init/scripts/dot-ai-index.sh <target>` (owner copy), and stop for user review. Never mark shipped without explicit approval.
