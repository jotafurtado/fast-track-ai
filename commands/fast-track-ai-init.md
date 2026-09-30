---
description: Installs the fast-track-ai tree into a target repo.
---

Run the `fast-track-ai-init` skill. It executes `skills/fast-track-ai-init/scripts/fast-track-ai-init.sh` on the target directory, verifies the created tree, regenerates the index, and reports. Installation is idempotent.

When the target already has tracks, the skill checks each one with the owner gate, lists any non-conforming track with its first gate message, and asks one yes-or-no question before normalizing them. It changes no track until the user answers, moves gate-rejected files into the track's `assets/legacy/`, and never invents a Done, Files, Accept, Validate, or approval value.
