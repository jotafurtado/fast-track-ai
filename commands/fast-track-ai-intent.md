---
description: Draft the intent of a new request with interactive questions and autonomous artifacts, then offer spec continuation.
---

Run the `fast-track-ai-intent` skill. Demand comes from the conversation. Research-only and assessment-only requests are routed without a track. For change requests, output goes to `fast-track-ai/tracks/NNN-slug/intent.md`. Intent `status` may stay `draft`. Do not write `spec.md`. Unanswered `Open questions` stay on the intent for the spec skill to resolve or convert into tasks. The skill presents a four-bullet summary and ends with `. para continuar com a spec`; on `.` it chains to the spec skill.
