---
name: fast-track-ai-assess
description: Produce an evidence-backed internal assessment of a project, feature, or idea. Use when the user asks to assess, evaluate, audit, or review project completeness or fitness before creating an intent.
---

1. Read `fast-track-ai/INDEX.md` first. Freeze the requested target and scope. Assessment is read-only toward the assessed subject: inspect files, history, commands, and observed behavior, but do not modify the subject while gathering evidence.
2. State concrete criteria before reaching a conclusion. Do not require a generic numeric scorecard.
3. Gather evidence for and against the likely conclusion. Cite repository paths, durable artifacts, and observed command results precisely. Separate observed facts from inference.
4. Record material counterevidence under `Evidence against conclusion`. State unavailable evidence, uncertainty, evaluator limitations, and scope limits under `Limitations`.
5. Produce a defensible conclusion and concrete recommendations. Recommendations are inputs for later work, not implementation performed by this skill.
6. Record the evaluator as the provider and model when known, or the available stable agent identity otherwise. If assessment is delegated, record the delegated evaluator rather than the coordinating agent.
7. Write exactly one file to `fast-track-ai/assessments/<YYYY-MM-DD>-<slug>.md` from `./assets/assessment.md`. Use the local calendar date, a descriptive kebab-case slug, and no lifecycle `status` field.
8. Run `../fast-track-ai-init/scripts/fast-track-ai-index.sh <target>` using the owner copy and report any validation error.
9. When invoked by another skill as an auxiliary step, write the artifact, regenerate the index, return conclusion, limitations, and artifact path to the caller, and present nothing to the user. A direct call reports the result, path, and index outcome without a `.` line.
