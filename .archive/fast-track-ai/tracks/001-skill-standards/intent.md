---
id: 001-skill-standards
status: shipped
research: []
decisions: []
---

# Intent: Skill Standards Compliance

## Problem
The six dot-ai skills need consistent triggering, portable resource ownership, and reproducible validation. Gaps in these contracts can bypass the intent-before-plan lock or break an installed package.

## Proposed outcome
Every dot-ai skill follows the adopted skill-creator standards, package-relative resources resolve after installation, and deterministic flows expose regressions before a live target is changed.

## Users and systems
Method maintainers and coding agents use the package. The affected systems are the `skills/` package, its command wrappers, scratch validation repositories, and target repositories initialized with dot-ai.

## Constraints
Keep user-facing package prose in English. Preserve the frozen `via: rapida | completa` identifiers and all intent, plan, and implementation locks. Validate method changes only in `/tmp`. Do not vendor scripts or templates into target repositories.

## Out of scope
Third-party base skills and the full skill-creator benchmark viewer remain outside this track.

## Assumed state
The skill-creator guide read on 2026-09-15 is the reference standard. The six existing `dot-ai-*` skills are the complete audit scope.

## Open questions
None.
