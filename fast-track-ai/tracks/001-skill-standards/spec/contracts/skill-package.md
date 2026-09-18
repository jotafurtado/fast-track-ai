# Skill Package Contract

This package is consumed by agent harnesses through skill directories. Any change MUST preserve this contract.

## Directory contract

`skills/<name>/SKILL.md` with YAML frontmatter containing `name` (equals directory name) and `description` (non-empty). Optional subdirectories: `scripts/` (executable, POSIX bash), `assets/` (files copied to output, never executed), `references/` (docs loaded as needed).

## Path contract

Skills reference bundled files by package-relative path from the skill directory.

**Sibling owner paths.** Cross-skill resources MAY use a package-relative sibling path that steps up one level into the harness skills directory and into the owner skill—for example, `../fast-track-ai-init/scripts/fast-track-ai-index.sh`. After `install.sh` links every `skills/fast-track-ai-*` directory as a sibling, these references MUST resolve; verification uses `test -f <installed-skill>/../<owner>/...` for each cross-skill reference (see Install contract).

Within a single skill, use paths relative to that skill directory (e.g., `scripts/foo.sh`, `references/bar.md`).

Forbidden: absolute paths; paths anchored to `$HOME`, `~`, or other machine-specific roots; and machine names or hostnames in path strings.

## Install contract

`install.sh` links every `skills/fast-track-ai-*` directory into the harness skills dir. After install, every package-relative reference MUST resolve. Verification: `test -f <installed-skill>/../<owner>/...` for each cross-skill reference.
