---
name: fast-track-ai-handoff
description: Compact the conversation with the base handoff skill and file under fast-track-ai/handoffs. Use when switching harness or model, ending a session, or the user says "handoff", "compact this", or "pick this up later".
---

1. Run the base `handoff` skill with the given focus. It saves to the OS temporary directory.
2. Copy the generated file to `fast-track-ai/handoffs/<timestamp>-<slug>.md` in the target repo, timestamp `AAAA-MM-DD-HHmm-OFFSET`.
3. Reference specs, plans, and diffs by path, never duplicate content.
4. Keep only the 3 most recent in the root. Move the rest to `fast-track-ai/handoffs/archive/`.
5. Run `../fast-track-ai-init/scripts/fast-track-ai-index.sh <target>` (owner copy) and report.
