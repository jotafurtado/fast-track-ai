---
name: dot-ai-init
description: Installs the dot-ai tree into a target repo, idempotently. Use whenever starting dot-ai in a new or existing repo, the user says "setup dot-ai", "install dot-ai", "init the method here", or the dot-ai/ tree is missing.
---

1. Run `scripts/dot-ai-init.sh [target-dir]` bundled in this skill package, from the sibling `scripts/` directory of this SKILL.md. It creates `dot-ai/`, the `specs` symlink, the `dot-ai/INDEX.md` seed, and the managed block in the target `AGENTS.md`. Nothing is vendored into the target. Scripts and templates stay inside the skill package.
2. Verify the tree: `dot-ai/{research,refs,handoffs/archive,assessments,decisions,tracks,specs}`, `specs` symlink, `dot-ai/INDEX.md`.
3. Run `./scripts/dot-ai-index.sh [target-dir]` from this skill and report the result.
