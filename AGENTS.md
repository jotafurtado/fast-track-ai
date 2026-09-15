# AGENTS.md - dot-ai repo

Method `dot-ai`, agent-driven SDLC. Binding norm lives in Obsidian, `10 - Projetos/Code/dot-ai/dot-ai - Fundamentos v1.2.md`. Obsidian holds only the norm. This repo holds the executable: skills, commands, scripts, and templates, all inside `skills/`.

## Map

- `commands/` - slash commands, 1 file per command (`dot-ai-init`, `dot-ai-intent`, `dot-ai-plan`, `dot-ai-implement`, `dot-ai-research`, `dot-ai-handoff`)
- `skills/dot-ai-*/SKILL.md` - procedure each command runs
- `skills/dot-ai-init/scripts/` - `dot-ai-init.sh`, installs the tree into the target, nothing vendored
- `skills/shared/scripts/` - `dot-ai-index.sh`, `dot-ai-specify.sh`, `sdd-gate.sh`, POSIX bash, no dependencies beyond `grep`, `sed`, `awk`
- `skills/shared/templates/` - `intent.md`, `plan.md`, `tasks.md`, `decisions.md`, `AGENTS-snippet.md`

Skills run against the target repo `dot-ai/` tree using scripts and templates bundled in this package. No machine-fixed paths. Only `dot-ai-init` installs anything, through its own script path.

## Rules

- Code in English: folders, files, functions, variables, frontmatter fields.
- User-facing prose in English: commands, skills, error messages.
- Surgical changes: 1 behavior per change, validated in `/tmp` before commit.
- No stubs: a published script must actually run in the test below.
- A live target project is never edited from here. Method changes validate in `/tmp`.

## Install

`install.sh` links every `skills/dot-ai-*` plus `skills/shared` into the harness skills dirs. The `shared` link is load-bearing: skills resolve `../shared` relative to their installed location. Same link set on any machine:

```bash
rm -rf /tmp/dot-ai-test && mkdir -p /tmp/dot-ai-test
./skills/dot-ai-init/scripts/dot-ai-init.sh /tmp/dot-ai-test
./skills/shared/scripts/dot-ai-index.sh /tmp/dot-ai-test
./skills/shared/scripts/sdd-gate.sh --track 001-exemplo --root /tmp/dot-ai-test || true
```

`init` must be idempotent: run twice with no error and no duplicated blocks in `AGENTS.md`.
