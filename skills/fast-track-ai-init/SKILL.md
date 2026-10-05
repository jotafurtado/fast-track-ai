---
name: fast-track-ai-init
description: Installs the fast-track-ai tree into a target repo, idempotently. Use whenever starting fast-track-ai in a new or existing repo, the user says "setup fast-track-ai", "install fast-track-ai", "init the method here", or the fast-track-ai/ tree is missing.
---

1. Read `./assets/AGENTS-snippet.md`, then run `./scripts/fast-track-ai-init.sh [target-dir]` from this skill. It creates `fast-track-ai/`, the `fast-track-ai/INDEX.md` seed, and the managed block from the bundled snippet in the target `AGENTS.md`. Nothing is vendored into the target. Supporting artifacts are written by their workflow skills, not by init.
2. Verify the tree: `fast-track-ai/{research,refs,handoffs/archive,assessments,decisions,tracks}`, `fast-track-ai/INDEX.md`.
3. Run `./scripts/fast-track-ai-index.sh [target-dir]` from this skill and report the result.

Path resolution: `./` paths and `../fast-track-ai-*` sibling paths resolve from this skill's installed directory, and `fast-track-ai/` paths resolve from the target repository root.
