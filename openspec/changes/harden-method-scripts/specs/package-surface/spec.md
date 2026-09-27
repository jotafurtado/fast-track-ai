# Spec Delta

## ADDED Requirements

### Requirement: Init refreshes the managed AGENTS block
`fast-track-ai-init.sh` SHALL behave as follows:
- It creates `AGENTS.md` from the snippet when the file is absent.
- It appends the snippet when the file exists without managed-block markers.
- When the file contains exactly one `BEGIN MANAGED BLOCK: fast-track-ai` line followed later by exactly one `END MANAGED BLOCK: fast-track-ai` line, it replaces those lines and everything between them with the current snippet.
- It preserves every byte outside the block.
- It does not write the file when the result would be identical.
- It exits unsuccessfully without writing `AGENTS.md` or creating any other file when the markers are duplicated, unclosed, or out of order.

#### Scenario: Outdated block is refreshed
- **WHEN** `AGENTS.md` contains user text, then a managed block whose body differs from the current snippet, then more user text
- **THEN** init replaces only the block with the current snippet and both user sections remain byte-identical

#### Scenario: Current block is left alone
- **WHEN** init runs twice on a target whose block already matches the snippet
- **THEN** `AGENTS.md` is byte-identical after the second run and contains exactly one managed block

#### Scenario: Begin marker without end marker
- **WHEN** `AGENTS.md` contains a `BEGIN MANAGED BLOCK: fast-track-ai` line and no matching end line
- **THEN** init exits unsuccessfully, names the malformed markers, and `AGENTS.md` is unchanged

#### Scenario: Duplicated block
- **WHEN** `AGENTS.md` contains two managed blocks
- **THEN** init exits unsuccessfully, names the duplicated markers, and `AGENTS.md` is unchanged

#### Scenario: Symlinked AGENTS file
- **WHEN** `AGENTS.md` is a symlink to another file and its block is outdated
- **THEN** init updates the link target's content and `AGENTS.md` remains a symlink
