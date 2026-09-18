---
description: Generate plan.md and tasks.md for a track with approved intent and required spec.md, then stop at approval.
---

Run the `fast-track-ai-plan` skill. Track comes from the arguments. Requires an intent with `status: active` and a track-root `spec.md`. Output goes to `fast-track-ai/tracks/NNN-slug/plan.md` and `tasks.md`, stopping for approval before any implementation.
