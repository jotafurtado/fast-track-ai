---
name: fast-track-ai-handoff
description: Capture portable working context directly under fast-track-ai/handoffs. Use when switching harness or model, ending a session, or the user says "handoff", "compact this", or "pick this up later".
---

1. Read `fast-track-ai/INDEX.md` and the current conversation. Identify the active objective, verified state, unresolved decisions, and relevant durable artifacts.
2. Preserve every active user instruction exactly under `Active user instructions, verbatim`. Omit only secrets or unnecessary personal data and disclose the omission. Do not paraphrase instructions whose wording constrains the next agent.
3. Separate verified completed work from P0 and P1 next actions. Record blockers, risks, relevant paths, and observed command results without presenting inference as observation.
4. Reference specs, research, refs, decisions, assessments, diffs, and other durable documents by path instead of duplicating their contents. Name one concrete first next action.
5. Write the final document directly to `fast-track-ai/handoffs/YYYY-MM-DD-HHmmssZ-<slug>.md` from `./assets/handoff.md`. Set `captured: YYYY-MM-DDTHH:MM:SSZ` to the same UTC instant as the filename. The final path must not already exist in either the active directory or archive; stop and report a collision instead of overwriting. Do not use a lifecycle `status`.
6. Order active handoffs by their `captured` instant, not filename text. Keep the three newest in `fast-track-ai/handoffs/`. Move each older handoff to `fast-track-ai/handoffs/archive/` only when its destination does not already exist; stop and report any collision without overwriting.
7. After archiving, run `../fast-track-ai-init/scripts/fast-track-ai-index.sh <target>` using the owner copy and report any validation error.
