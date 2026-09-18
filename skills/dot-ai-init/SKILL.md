---
name: dot-ai-init
description: Installs the dot-ai tree into a target repo, idempotently. Use whenever starting dot-ai in a new or existing repo, the user says "setup dot-ai", "install dot-ai", "init the method here", or the dot-ai/ tree is missing.
---

1. Read `./assets/AGENTS-snippet.md`, then run `./scripts/dot-ai-init.sh [target-dir]` from this skill. Before writing, the script refuses an existing `specs` path unless that path is the canonical `specs -> dot-ai/specs` symlink. Move conflicting specs into `dot-ai/tracks/<track>/spec` before retrying. It creates `dot-ai/`, the specs view, the `dot-ai/INDEX.md` seed, and the managed block from the bundled snippet in the target `AGENTS.md`. Nothing is vendored into the target.
2. Verify the tree: `dot-ai/{research,refs,handoffs/archive,assessments,decisions,tracks,specs}`, `specs -> dot-ai/specs`, `dot-ai/INDEX.md`.
3. Run `./scripts/dot-ai-index.sh [target-dir]` from this skill and report the result.
