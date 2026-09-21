---
description: Generate unified spec.md and tasks.md for a track with intent.md, then stop at approval. Copy unanswered Open questions into spec Phases and tasks.md. Do not invent answers. Intent status: active is not required. Do not write plan.md.
---

Run the `fast-track-ai-spec` skill. Track comes from the arguments. Requires `intent.md`. Intent `status: active` is not required. Copy unanswered `Open questions` into spec Phases and `tasks.md` as work. Do not invent answers. Output goes to `fast-track-ai/tracks/NNN-slug/spec.md` and `tasks.md`. Tell the user those files were written and ask for approval to implement. Do not present a draft-status gate miss as FAIL. Do not auto-approve. Do not write `plan.md`.
