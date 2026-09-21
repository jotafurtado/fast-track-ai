---
status: approved
---

# Tasks: 008-unified-spec

- [x] T001 Rename `skills/fast-track-ai-plan/` to `skills/fast-track-ai-spec/`, set skill `name: fast-track-ai-spec`, drop the `plan.md` asset, and rewrite the skill to write unified `spec.md` plus `tasks.md`. Files: `skills/fast-track-ai-spec/SKILL.md`, `skills/fast-track-ai-spec/assets/plan.md` (removed). Validate: directory exists; `name: fast-track-ai-spec`; no `assets/plan.md`.
- [x] T002 Rename `commands/fast-track-ai-plan.md` to `commands/fast-track-ai-spec.md` and point it at the spec skill. Files: `commands/fast-track-ai-spec.md`, `commands/fast-track-ai-plan.md` (removed). Validate: command names `fast-track-ai-spec`; `test ! -e commands/fast-track-ai-plan.md`.
- [x] T003 Add the unified spec template (Outcome, Phases with Done/Files/Accept, Constraints, Out of scope) owned by the spec skill. Files: `skills/fast-track-ai-spec/assets/spec.md`. Validate: file has `## Phases`, `Files:`, and `Accept:`.
- [x] T004 Stop the intent skill from writing `spec.md`; remove the intent-owned spec template; align the intent command. Files: `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-intent/assets/spec.md` (removed), `commands/fast-track-ai-intent.md`. Validate: intent skill has no `spec.md` write; `test ! -e skills/fast-track-ai-intent/assets/spec.md`.
- [x] T005 Teach the spec skill to copy unanswered intent `Open questions` into spec Phases and `tasks.md` and forbid invented answers. Files: `skills/fast-track-ai-spec/SKILL.md`, `commands/fast-track-ai-spec.md`. Validate: both name `Open questions` and `Do not invent answers`.
- [x] T006 Move gate ownership with the rename: require approved `spec.md` and `tasks.md` together, Files/Accept on spec, fail if `plan.md` exists or statuses diverge. Files: `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`. Validate: `bash -n`; fixture with `plan.md` exits 1; spec approved + tasks draft exits 1; approved closed spec+tasks with no `plan.md` exits 0.
- [x] T007 Point implement and its command at approved `spec.md` and `tasks.md` and `../fast-track-ai-spec/`. Files: `skills/fast-track-ai-implement/SKILL.md`, `commands/fast-track-ai-implement.md`. Validate: neither names `plan.md` as required; both name `fast-track-ai-spec`.
- [x] T008 Drop `plan.md` from AGENTS map, managed snippet, and this repo's managed block; cycle is intent → spec + tasks → implement. Files: `AGENTS.md`, `skills/fast-track-ai-init/assets/AGENTS-snippet.md`. Validate: neither requires `plan.md` for approval; both name `fast-track-ai-spec`; `AGENTS.md` still has one managed block.
- [x] T009 Rewrite live evals so approval/spec fixtures use approved spec+tasks and treat root `plan.md` as a fail. Files: `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`, `fast-track-ai/tracks/001-skill-standards/spec/evals.md`. Validate: `bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh approval` exits 0; resources eval names `./assets/spec.md` on the spec skill.
- [x] T010 Fold `002`, `004`, `005`, `006`, `007` `plan.md` phases into each `spec.md` and delete those `plan.md` files. Files: those five `spec.md` and five `plan.md` (removed). Validate: each spec has `## Phases`; `test ! -e` each `plan.md`.
- [x] T011 Fold this track's phases into `008` `spec.md` and delete `008` `plan.md`. Files: `fast-track-ai/tracks/008-unified-spec/spec.md`, `fast-track-ai/tracks/008-unified-spec/plan.md` (removed). Validate: spec has `## Phases`; `test ! -e fast-track-ai/tracks/008-unified-spec/plan.md`.
- [x] T012 Run init, install, index, approval, spec, and resources on a scratch copy in `/tmp`; inject `plan.md` and confirm gate fails. Files: none in this repo. Validate: scratch `run-evals.sh all` exits 0; injected `plan.md` makes gate exit 1.

Auxiliary output files go under `assets/`, never loose at the track root.
