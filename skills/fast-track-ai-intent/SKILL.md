---
name: fast-track-ai-intent
description: Draft the intent of a new request from the conversation and stop at approval. After approval, draft the thin spec.md and stop. Use when the user says what they want done ("I want to build X", "start a feature", "we need to fix Y"), before any plan. Never plan or implement without an approved intent first.
---

1. Listen to the request in the user's own words. Do not plan, do not implement.
2. Find the next free number under `fast-track-ai/tracks/` in the target repo. Format `NNN-slug`, kebab-case slug of what was asked.
3. If the idea is shallow, grill first with the Matt Pocock `grilling` skill. If already decided, skip.
4. Draft `fast-track-ai/tracks/NNN-slug/intent.md` from `./assets/intent.md` bundled in this skill. Reference external research by slug in `research:` when it exists. Cite inward evaluations from `fast-track-ai/assessments/` in `assessments:`, never in `research:`. Cite Architecture Decision Records from `fast-track-ai/decisions/` in `decisions:`.
5. Stop and ask for correction and approval. No approved intent means no `spec.md`, no `plan.md`, no code. This lock has no exceptions. After explicit approval, set intent `status: active`, then draft `fast-track-ai/tracks/NNN-slug/spec.md` from `./assets/spec.md` bundled in this skill, and stop. Do not write `plan.md`.
