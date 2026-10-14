---
status: approved
---

# Tasks: 010-approval-ask-not-gate-fail

- [x] T001 Teach the spec skill and command to say `spec.md` and `tasks.md` were written and ask for approval. Do not tell the agent to report a draft-status gate miss as FAIL. Files: `skills/fast-track-ai-spec/SKILL.md`, `commands/fast-track-ai-spec.md`. Validate: both name the written-files ask; neither contains a user-facing draft-status FAIL instruction.
- [x] T002 Keep the default implement-time gate failing draft or open tasks. Change `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh` only if a draft-from-broken split is required. Files: `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh` or none. Validate: default gate exits 1 on draft spec/tasks.
- [x] T003 In `/tmp`, write draft spec+tasks and confirm the user-facing copy is the approval ask, not draft-status FAIL; the default gate on those drafts still exits 1. Files: none in this repo. Validate: ask copy present; default gate exit 1.

Auxiliary output files go under `assets/`, never loose at the track root.
