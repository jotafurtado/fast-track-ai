# Skill Package Contract

This package is consumed by agent harnesses through skill directories. Any change MUST preserve this contract.

## Directory contract

`skills/<name>/SKILL.md` with YAML frontmatter containing `name` (equals directory name) and `description` (non-empty). Optional subdirectories: `scripts/` (executable, POSIX bash), `assets/` (files copied to output, never executed), `references/` (docs loaded as needed).

## Path contract

Skills reference bundled files by package-relative path from the skill directory (e.g., `../dot-ai-init/scripts/dot-ai-init.sh` is forbidden; the owner copy path from the referencing skill is required). No absolute paths, no `$HOME`, no machine names.

## Install contract

`install.sh` links every `skills/dot-ai-*` directory into the harness skills dir. After install, every package-relative reference MUST resolve. Verification: `test -f <installed-skill>/../<owner>/...` for each cross-skill reference.
