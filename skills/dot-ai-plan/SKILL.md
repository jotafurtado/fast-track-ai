---
name: dot-ai-plan
description: Generate plan.md and tasks.md for a track with approved intent and stop at approval. Use when the intent is active and the user says "make a plan", "plan this track", or asks how to implement, before any implementation.
---

1. Read `dot-ai/tracks/NNN-slug/intent.md` in the target repo. If `status` is not `active`, stop and ask for intent approval. No approved intent, no plan.
2. If `spec/` exists, do not create track-level planning artifacts. Require `spec/plan.md` and `spec/tasks.md` from the full Spec Kit cycle; if either is missing, direct the user to `/speckit.plan` and `/speckit.tasks` and stop. When both exist, present them and stop for explicit approval. After approval, set frontmatter `status: approved` in both files and return without implementing.
3. Write `plan.md` from `./assets/plan.md` bundled in this skill. Numbered phases with observable Done, explicit Files, one-line Accept per phase, Out of scope repeated from the intent without widening. Auxiliary outputs go under `assets/`, never loose at the track root.
4. Write `tasks.md` from `./assets/tasks.md` bundled in this skill: 1 item per step, each with Files and Validate. When the plan needs a durable recorded decision, read `./assets/decisions.md` before writing `decisions.md`. File outputs point under `assets/`.
5. Run `./scripts/sdd-gate.sh --track NNN-slug --root <target>` from this skill and report. Failure on draft approval or open tasks is expected before execution; all structural checks must otherwise pass.
6. Stop and ask for approval. No approved plan, no implementation. After explicit approval, set frontmatter `status: approved` in both `plan.md` and `tasks.md`.
