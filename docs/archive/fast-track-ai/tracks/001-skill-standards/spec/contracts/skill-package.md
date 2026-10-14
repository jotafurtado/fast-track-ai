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

## Installed skill contract

The package contains seven package skills: init, intent, spec, implement, research, assess, and handoff. `install.sh` discovers all `skills/fast-track-ai-*` directories and links the same seven-skill set for every supported harness. No `shared` skill link exists.

## Template ownership

Each script and template has exactly one owner skill:

| Resource | Owner |
|---|---|
| init script, index script, managed AGENTS snippet | `fast-track-ai-init` |
| intent and ref templates | `fast-track-ai-intent` |
| spec, tasks, decision templates, and structural gate | `fast-track-ai-spec` |
| assessment template | `fast-track-ai-assess` |
| research template | `fast-track-ai-research` |
| handoff template | `fast-track-ai-handoff` |

Cross-skill consumers reference the owner copy through a sibling owner path. Init does not own supporting-artifact templates.

## Self-contained workflows

Research, assessment, and handoff execute from their package skill and package-owned template. They MUST NOT invoke or require a separately installed base research, assessment, or handoff skill.

## Artifact schema contract

Refs record immutable content identity and license. Research is status-free and multi-source. Assessments are status-free and record evaluator identity, evidence, counterevidence, limitations, and recommendations. Decisions contain only accepted or superseded durable choices and may cite evidence. Handoffs preserve exact active instructions and maintain a three-file active window.

The generated index validates and lists tracks, refs, research, assessments, decisions, and active handoffs in deterministic order. Archived handoffs are excluded.
