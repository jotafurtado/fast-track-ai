---
name: fast-track-ai-research
description: Research with the base research skill and file under fast-track-ai/research with valid frontmatter. Use when the user says "research X", "investigate", "gather docs", or needs facts before deciding.
---

1. Run the base `research` skill on the topic, using primary sources with citations.
2. Save the result to `fast-track-ai/research/<slug>.md` in the target repo, nowhere else.
3. Ensure the frontmatter: `source`, `captured`, `status: raw`, `owner`.
4. Run `../fast-track-ai-init/scripts/fast-track-ai-index.sh <target>` (owner copy) and report validation errors.
