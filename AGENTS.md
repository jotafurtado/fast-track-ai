# AGENTS.md - fast-track-ai repo

Method `fast-track-ai`, a lightweight agent-driven SDLC. Binding norm lives in Obsidian, `10 - Projetos/Code/dot-ai/dot-ai - Fundamentos v1.2.md`. Obsidian holds only the norm. This repo holds the executable: skills, commands, scripts, and templates, all inside `skills/`.

## Map

- `commands/` - slash commands, 1 file per command (`fast-track-ai-init`, `fast-track-ai-intent`, `fast-track-ai-spec`, `fast-track-ai-implement`, `fast-track-ai-research`, `fast-track-ai-assess`, `fast-track-ai-handoff`)
- `skills/fast-track-ai-*/SKILL.md` - procedure each command runs
- `skills/fast-track-ai-init/` - SKILL.md plus `scripts/` (`fast-track-ai-init.sh`, `fast-track-ai-index.sh`) plus `assets/AGENTS-snippet.md`
- `skills/fast-track-ai-intent/` - SKILL.md plus `assets/` (`intent.md`, `ref.md`)
- `skills/fast-track-ai-spec/` - SKILL.md plus `scripts/fast-track-ai-gate.sh` plus `assets/` (`spec.md`, `tasks.md`, `decisions.md`)
- `skills/fast-track-ai-assess/`, `skills/fast-track-ai-research/`, and `skills/fast-track-ai-handoff/` - each owns its SKILL.md and artifact template; `skills/fast-track-ai-implement/` owns SKILL.md only
- `evals/` - the self-contained maintainer eval suite (`run-evals.sh`, `evals.md`); not shipped by `install.sh`

Skills run against the target repo `fast-track-ai/` tree using scripts and templates bundled in this package. No machine-fixed paths. Only `fast-track-ai-init` installs anything, through its own script path.

## Rules

- Code in English: folders, files, functions, variables, frontmatter fields.
- User-facing prose in English: commands, skills, error messages, except the continuous-flow next-step lines (`. para continuar com a spec`, `. para implementar`, `. para ship (marca a track como concluida)`).
- Surgical changes: 1 behavior per change, validated in `/tmp` before commit.
- No stubs: a published script must actually run in the test below.
- A live target project is never edited from here. Method changes validate in `/tmp`.
- Each script and template has one owner skill. Cross-skill consumers reference the owner copy via package-relative sibling paths. No `shared` link.
- This repository does not run the method on itself: never run `fast-track-ai-init` here, and treat the `fast-track-ai/` tree as a read-only archive.

## Install

`install.sh` links every `skills/fast-track-ai-*` into the harness skills dirs and links `commands/fast-track-ai-*.md` into the harness commands dir. No `shared` link exists: each skill owns its resources and cross-skill references point at owner copies. Run the eval suite on any machine:

```bash
./evals/run-evals.sh all
```

`init` must be idempotent: run twice with no error and no duplicated blocks in `AGENTS.md`.
