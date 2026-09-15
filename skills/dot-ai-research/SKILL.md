---
name: dot-ai-research
description: Research with the base research skill and file under dot-ai/research with valid frontmatter.
---

1. Run the base `research` skill on the topic, using primary sources with citations.
2. Save the result to `dot-ai/research/<slug>.md` in the target repo, nowhere else.
3. Ensure the frontmatter: `source`, `captured`, `status: raw`, `owner`.
4. Run the bundled `../shared/scripts/dot-ai-index.sh <target>` from this skill package and report validation errors.
