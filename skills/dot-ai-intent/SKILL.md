---
name: dot-ai-intent
description: Draft the intent of a new request from the conversation and stop at approval. Use when the user says what they want done, before any plan or spec.
---

1. Listen to the request in the user's own words. Do not plan, do not implement.
2. Find the next free number under `dot-ai/tracks/` in the target repo. Format `NNN-slug`, kebab-case slug of what was asked.
3. If the idea is shallow, grill first. If already decided, skip.
4. Draft `dot-ai/tracks/NNN-slug/intent.md` from the `intent.md` template bundled in this skill package (`../shared/templates/` relative to the `dot-ai-intent` skill directory). Fill `via` from the norm checklist and `via_motivo` in one line. Reference research by slug when it exists.
5. Stop and ask for correction and approval. No approved intent means no `plan.md`, no `spec/`, no code. This lock has no exceptions.
