---
name: dot-ai-plan
description: Generate plan.md and tasks.md for a track with approved intent and stop at approval. Use when the intent is active and the user says "make a plan", "plan this track", or asks how to implement, before any implementation.
---

1. Read `dot-ai/tracks/NNN-slug/intent.md` in the target repo. If `status` is not `active`, stop and ask for intent approval. No approved intent, no plan.
2. If `spec/` exists, stop. The track runs the full cycle, track-level plan does not apply.
3. Write `plan.md` from `./assets/plan.md` bundled in this skill. Numbered phases with observable Done, explicit Files, one-line Accept per phase, Out of scope repeated from the intent without widening. Auxiliary outputs go under `assets/`, never loose at the track root.
4. Write `tasks.md` from `./assets/tasks.md` bundled in this skill: 1 item per step, each with Files and Validate. File outputs point under `assets/`.
5. Run `./scripts/sdd-gate.sh --track NNN-slug --root <target>` from this skill and report. FAIL on open tasks is expected before execution. Structure must pass.
6. Stop and ask for approval. No approved plan, no implementation.
