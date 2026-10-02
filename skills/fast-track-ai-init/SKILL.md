---
name: fast-track-ai-init
description: Installs the fast-track-ai tree into a target repo, idempotently. Use whenever starting fast-track-ai in a new or existing repo, the user says "setup fast-track-ai", "install fast-track-ai", "init the method here", or the fast-track-ai/ tree is missing.
---

1. Read `./assets/AGENTS-snippet.md`, then run `./scripts/fast-track-ai-init.sh [target-dir]` from this skill. It creates `fast-track-ai/`, the `fast-track-ai/INDEX.md` seed, and the managed block from the bundled snippet in the target `AGENTS.md`. Nothing is vendored into the target. Supporting artifacts are written by their workflow skills, not by init.
2. Verify the tree: `fast-track-ai/{research,refs,handoffs/archive,assessments,decisions,tracks}`, `fast-track-ai/INDEX.md`.
3. Run `./scripts/fast-track-ai-index.sh [target-dir]` from this skill and report the result.
4. Check existing tracks for conformance. Walk each `fast-track-ai/tracks/*/intent.md`, read its `status`, and run the owner gate `../fast-track-ai-spec/scripts/fast-track-ai-gate.sh --track <id> --root <target-dir> --mode <mode>` in the mode the status implies:
   - `completion` when the intent is `shipped`.
   - `structure` when the track root holds `spec.md` or `tasks.md` and the intent is not `shipped`, `dropped`, or `superseded`.
   - No check for a `dropped` or `superseded` track, or for a track that holds only `intent.md`.

   Collect every track whose gate fails. Independently of the gate, also collect every track whose root holds `decisions.md`, with the reason `legacy root decisions.md`, including `dropped` and `superseded` tracks and tracks the gate does not check. When none are collected, report that the tracks conform and ask nothing. When any are collected, list each such track with its first gate message or the legacy reason, then ask the user one yes-or-no question: whether to normalize the listed tracks. Change no track before the answer.

   On yes, normalize each listed track to the current contract:
   - Move each root entry the gate rejects, including hidden entries such as `.DS_Store`, into the track's `assets/legacy/<name>`, and stop with a reported collision if the destination already exists. When the rejected entry is a regular file named `assets`, stop for that track and report it instead of moving anything, because the file occupies the directory that would receive it.
   - Move a root `decisions.md` to `assets/legacy/decisions.md` without changing its content, with the same collision stop.
   - Rewrite `spec.md` and `tasks.md` in the current template shape from `../fast-track-ai-spec/assets/spec.md` and `../fast-track-ai-spec/assets/tasks.md`, using only content already present in the track. Keep the existing `status`.
   - Do not invent a Done, Files, Accept, Validate, or approval value. When a value or an approval cannot be derived from existing content, ask for it or leave that track failing and report it. On a status mismatch, such as a shipped intent with a draft spec, ask before approving.
   - Rerun the gate and report the result per track.

   On no, change no track and report the tracks as left non-conforming.

   This check does not depend on which package version produced a track and does not special-case any track ID.

Path resolution: `./` paths and `../fast-track-ai-*` sibling paths resolve from this skill's installed directory, and `fast-track-ai/` paths resolve from the target repository root.
