---
description: Installs the dot-ai tree into a target repo.
---

Run the `dot-ai-init` skill. It executes `skills/dot-ai-init/scripts/dot-ai-init.sh` on the target directory, verifies the created tree, and reports. Installation is idempotent. A conflicting real directory, file, or unexpected symlink at `specs` is rejected before the target is changed.
