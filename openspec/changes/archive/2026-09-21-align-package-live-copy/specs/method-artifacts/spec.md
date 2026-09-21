# Spec Delta

## MODIFIED Requirements

### Requirement: Package workflows are self-contained
The research, assessment, and handoff workflows SHALL execute using instructions and templates owned by the fast-track-ai package. They MUST NOT require a separately installed third-party skill at runtime. The package installer SHALL link every `skills/fast-track-ai-*` directory into the harness skills dirs and SHALL link every `commands/fast-track-ai-*.md` file into the harness commands directory.

#### Scenario: Base skills are absent
- **WHEN** fast-track-ai is installed on a machine that has no third-party research, assessment, or handoff skill
- **THEN** all three package workflows remain usable and produce conforming artifacts

#### Scenario: Seventh skill is installed
- **WHEN** the package installer discovers package skills
- **THEN** it installs `fast-track-ai-assess` alongside the existing six fast-track-ai skills and exposes its command

#### Scenario: Command wrappers are installed
- **WHEN** the package installer runs with default or custom directories
- **THEN** all seven `fast-track-ai-*.md` command files resolve in the harness commands directory, and the install eval asserts those links
