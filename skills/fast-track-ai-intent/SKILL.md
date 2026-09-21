---
name: fast-track-ai-intent
description: Draft the intent of a new request from the conversation and stop. Do not write spec.md. Use when the user says what they want done ("I want to build X", "start a feature", "we need to fix Y"), before any spec. Intent approval is not required before spec.md. Never implement without approved spec.md and tasks.md.
---

1. Listen to the request in the user's own words. Do not write `spec.md`. Do not implement.
2. Find the next free number under `fast-track-ai/tracks/` in the target repo. Format `NNN-slug`, kebab-case slug of what was asked.
3. If the request is too vague to draft an intent, ask the user. Prefer the host interactive ask pattern. Cap: three questions in that pass. Write answers into the intent. Leave leftovers under `Open questions`. Do not run an unbounded grill. Matt Pocock `grilling` is not an unbounded interview. If already decided, skip the questions.
4. Draft `fast-track-ai/tracks/NNN-slug/intent.md` from `./assets/intent.md` bundled in this skill. Reference external research by slug in `research:` when it exists. Cite inward evaluations from `fast-track-ai/assessments/` in `assessments:`, never in `research:`. Cite Architecture Decision Records from `fast-track-ai/decisions/` in `decisions:`. When a user-supplied source is the basis for the track, file `fast-track-ai/refs/<slug>.md` from `../fast-track-ai-init/assets/refs.md` (owner copy) and cite the slug in `refs:`. `research:` stays for investigation this package produced. Intent `status` may stay `draft`.
5. Stop. Do not write `spec.md`. Do not write `plan.md`. Unanswered `Open questions` stay on the intent for the spec skill to copy. Do not invent answers.
6. When the maintainer abandons a track, set that intent `status: dropped`. Implementation is not required. When the maintainer replaces a track, set `status: superseded` only after they name `superseded_by`. Do not invent `superseded_by`.
