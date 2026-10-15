---
status: approved
---

# Tasks: 006-plan-asks-open-questions

- [x] T001 Cap vague-intent questions at three, prefer the host interactive ask, write answers into the intent, leave leftovers under `Open questions`, and allow `spec.md` while intent is `draft`. Files: `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-intent/assets/spec.md`. Validate: skill text names the cap of three, interactive ask, and no approval lock before `spec.md`; spec template cycle does not require intent `status: active` before the spec exists.
- [x] T002 Teach the plan skill and slash command to write `plan.md` and `tasks.md` without intent `status: active`, copy unanswered `Open questions` into spec/plan and `tasks.md` as work, and forbid invented answers. Files: `skills/fast-track-ai-plan/SKILL.md`, `commands/fast-track-ai-plan.md`. Validate: neither file requires `status: active`; both name copy-into-spec-and-tasks and do-not-invent.
- [x] T003 Drop the approved-intent lock from AGENTS, implement, and the implement command. Files: `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`, `skills/fast-track-ai-implement/SKILL.md`, `commands/fast-track-ai-implement.md`. Validate: none contain `No approved intent`; implement still requires approved `plan.md` and `tasks.md`; `AGENTS.md` still has one managed block.
- [x] T004 Stop the gate from requiring intent `status: active`; keep `intent.md` present plus approved closed plan/tasks. Files: `skills/fast-track-ai-plan/scripts/fast-track-ai-gate.sh`. Validate: `bash -n`; fixture with draft intent, approved plan/tasks, and closed tasks exits 0; missing `intent.md` still exits 1.
- [x] T005 Update the live approval eval so draft intent is not a gate failure when plan and tasks are approved and closed. Files: `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`, `fast-track-ai/tracks/001-skill-standards/spec/evals.md`. Validate: `bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh approval` exits 0.
- [x] T006 Run init, index, and approval on a scratch copy in `/tmp`. Files: none in this repo. Validate: approval eval exits 0 in `/tmp`; this repo is not the scratch target.

Auxiliary output files go under `assets/`, never loose at the track root.
