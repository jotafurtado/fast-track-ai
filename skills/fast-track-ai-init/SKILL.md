---
name: fast-track-ai-init
description: Installs the fast-track-ai tree into a target repo, idempotently. Use whenever starting fast-track-ai in a new or existing repo, the user says "setup fast-track-ai", "install fast-track-ai", "init the method here", or the fast-track-ai/ tree is missing.
---

1. Read `./assets/AGENTS-snippet.md`, then run `./scripts/fast-track-ai-init.sh [target-dir]` from this skill. It creates `fast-track-ai/`, the `fast-track-ai/INDEX.md` seed, and the managed block from the bundled snippet in the target `AGENTS.md`. Nothing is vendored into the target. It does not create `specs/` or anything under `.specify/`. When a write is inward research, file `fast-track-ai/assessments/<YYYY-MM-DD>-<slug>.md` from `./assets/assessment.md`. Assessments have no `status` field. When a user-supplied source is the basis for a track, file `fast-track-ai/refs/<slug>.md` from `./assets/refs.md`. `type` is `inline` (full durable text) or `pointer` (URL, pin, hash). Max 500 KB. `sha256` is required. `refs/` is immutable: source changed, new file.
2. Verify the tree: `fast-track-ai/{research,refs,handoffs/archive,assessments,decisions,tracks}`, `fast-track-ai/INDEX.md`. Confirm `specs/` and `.specify/` were not created.
3. Run `./scripts/fast-track-ai-index.sh [target-dir]` from this skill and report the result.
