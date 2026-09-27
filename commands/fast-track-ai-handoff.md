---
description: Capture portable working context directly in fast-track-ai/handoffs/.
---

Run the `fast-track-ai-handoff` skill. The focus comes from the arguments. The skill writes directly to `fast-track-ai/handoffs/YYYY-MM-DD-HHmmssZ-<slug>.md`, with `captured` set to the same UTC instant, preserves active user instructions verbatim, orders by `captured`, and archives older handoffs before running the index. It stops on active or archive path collisions without overwriting.
