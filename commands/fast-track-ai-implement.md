---
description: Implement a track task by task using parallelism groups, with validation, review, and ship continuation.
---

Run the `fast-track-ai-implement` skill. Track comes from the arguments. Requires track-root `spec.md` and `tasks.md` with `status: approved`. Intent `status: active` is not required. No approved spec means no implementation. Do not require `plan.md`. The skill resolves `## Group` headers and `(depends:)` annotations in `tasks.md`, uses execution-class agents for task subagents, and presents a four-bullet summary ending with `. para ship`. The `fast-track-ai-spec` skill owns the gate. After the gate and review, ask for an explicit ship, then set intent `status: shipped` and regenerate the index. Checkboxes alone never ship.
