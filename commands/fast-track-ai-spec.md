---
description: Generate unified spec.md and tasks.md with parallelism groups, then offer implement continuation.
---

Run the `fast-track-ai-spec` skill. Track comes from the arguments. Requires `intent.md`. Intent status may stay `draft`. Copy unanswered `Open questions` into spec Phases and `tasks.md` as work. Do not invent answers. Output goes to `fast-track-ai/tracks/NNN-slug/spec.md` and `tasks.md`. The skill presents a four-bullet summary and ends with `. para implementar`; on `.` it sets both files to `status: approved` and chains to the implement skill. Do not present a draft-status gate miss as FAIL. Do not auto-approve. Do not write `plan.md`.
