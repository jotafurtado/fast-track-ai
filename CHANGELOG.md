# Changelog

Notable changes to fast-track-ai are recorded here. Entries describe user and maintainer impact; unreleased work is not assigned a release version.

## [Unreleased]

### Added

- Optional real-agent workflow evaluation through Claude Code and Codex, alongside Kiro, with native session continuation and shared behavioral assertions.
- Installed-resource validation through generic `.agents/skills` links and Claude mirrors, including bundled init, index, and gate execution in disposable projects.
- A readiness matrix recording package fingerprints, CLI versions, model settings, and native evidence for each evaluated harness.

### Changed

- Retained agent-eval diagnostics now use `<root>/<harness>/<scenario>` instead of `<root>/<scenario>`. Update scripts that consume diagnostic paths; invocations without `--harness` still select Kiro.
- The spec approval transition completes as an approval-only action before product edits. Both approval artifacts may be updated together, without prescribing an editing tool.
- Frozen package-building history lives under `docs/archive/fast-track-ai/`; the package repository does not run the method on itself.

### Fixed

- Apply the checked-task resume rule to task-scoped project checks during final validation, while still running the spec's final acceptance checks.
- Recognize structured Kiro skill-disclosure provenance and native text writes instead of treating staged skill loads as unobserved.
- Distinguish reading a Validate script from executing it. Native fixture execution records remain observable after a file marker is deleted; missing or suppressed evidence stays inconclusive.

Readiness applies to the package state and explicit model configurations recorded in [the evaluation results](evals/evals.md), not to every model or default setting.
