---
name: fast-track-ai-research
description: Investigate external facts using multiple traceable sources and save status-free research under fast-track-ai/research. Use when the user says "research X", "investigate", "gather docs", or needs external facts before deciding.
---

1. Read `fast-track-ai/INDEX.md` first. State the research question and the acceptance boundary before gathering evidence.
2. Prefer primary sources. Retrieve and read the source itself rather than relying on search-result snippets. Use more than one independent source for a material conclusion when available.
3. Tie every material claim to a direct citation. Distinguish observed facts from inference. Label claims that depend on one source or potentially stale evidence.
4. Report credible disagreement under `Conflicts`. Report inaccessible material, freshness concerns, single-source dependence, inference, and other uncertainty under `Limitations`.
5. Write exactly one result to `fast-track-ai/research/<slug>.md` from `./assets/research.md`. Use a descriptive kebab-case slug. Frontmatter contains `captured` and `owner` only; source records belong in the body so the artifact can cite multiple sources. Do not add a lifecycle `status` or singular `source` field.
6. Run `../fast-track-ai-init/scripts/fast-track-ai-index.sh <target>` using the owner copy and report any validation error.
7. When invoked by another skill as an auxiliary step, write the artifact, regenerate the index, return conclusion, limitations, and artifact path to the caller, and present nothing to the user. A direct call reports the result, path, and index outcome without a `.` line.
