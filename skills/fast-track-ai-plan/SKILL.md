---
name: fast-track-ai-plan
description: Generate plan.md and tasks.md for a track with approved intent and a required spec.md, then stop at approval. Use when the intent is active and the user says "make a plan", "plan this track", or asks how to implement, before any implementation.
---

1. Read `fast-track-ai/tracks/NNN-slug/intent.md` in the target repo. If `status` is not `active`, stop and ask for intent approval. No approved intent, no plan.
2. Require `fast-track-ai/tracks/NNN-slug/spec.md`. If it is missing, stop and ask the intent skill to draft it. A leftover `spec/` directory does not select a cycle and is not a substitute for `spec.md`.
3. Write `plan.md` from `./assets/plan.md` bundled in this skill. Numbered phases with observable Done, explicit Files, one-line Accept per phase, Out of scope repeated from the intent without widening. Auxiliary outputs go under `assets/`, never loose at the track root.
4. Write `tasks.md` from `./assets/tasks.md` bundled in this skill: 1 item per step, each with Files and Validate. When the user makes a qualifying decision (durable, costly to reverse, surprising without context, or a meaningful trade-off), file `fast-track-ai/decisions/<NNN-slug>.md` from `./assets/decisions.md` without a separate request. Status is `accepted | superseded` only. File outputs point under `assets/`.
5. Run `./scripts/fast-track-ai-gate.sh --track NNN-slug --root <target>` from this skill and report. Failure on draft approval or open tasks is expected before execution; all structural checks must otherwise pass.
6. Stop and ask for approval. No approved plan, no implementation. After explicit approval, set frontmatter `status: approved` in both `plan.md` and `tasks.md`.
