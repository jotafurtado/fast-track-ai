# AGENTS.md - dot-ai repo

Method `dot-ai`, agent-driven SDLC. Binding norm lives in Obsidian, `10 - Projetos/Code/dot-ai/dot-ai - Fundamentos v1.2.md`. Obsidian holds only the norm. This repo holds the executable: skills, commands, scripts, and templates, all inside `skills/`.

## Map

- `commands/` - slash commands, 1 file per command (`dot-ai-init`, `dot-ai-intent`, `dot-ai-plan`, `dot-ai-implement`, `dot-ai-research`, `dot-ai-handoff`)
- `skills/dot-ai-*/SKILL.md` - procedure each command runs
- `skills/dot-ai-init/` - SKILL.md plus `scripts/` (`dot-ai-init.sh`, `dot-ai-index.sh`) plus `assets/` (`AGENTS-snippet.md`)
- `skills/dot-ai-intent/` - SKILL.md plus `scripts/` (`dot-ai-specify.sh`) plus `assets/` (`intent.md`)
- `skills/dot-ai-plan/` - SKILL.md plus `scripts/` (`sdd-gate.sh`) plus `assets/` (`plan.md`, `tasks.md`, `decisions.md`)
- `skills/dot-ai-implement/`, `dot-ai-research/`, `dot-ai-handoff/` - SKILL.md only, referencing owner copies

Skills run against the target repo `dot-ai/` tree using scripts and templates bundled in this package. No machine-fixed paths. Only `dot-ai-init` installs anything, through its own script path.

## Rules

- Code in English: folders, files, functions, variables, frontmatter fields.
- User-facing prose in English: commands, skills, error messages.
- Surgical changes: 1 behavior per change, validated in `/tmp` before commit.
- No stubs: a published script must actually run in the test below.
- A live target project is never edited from here. Method changes validate in `/tmp`.

## Install

`install.sh` links every `skills/dot-ai-*` into the harness skills dirs. No `shared` link exists: each skill owns its resources and cross-skill references point at owner copies. Same link set on any machine:

```bash
./dot-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all
```

`init` must be idempotent: run twice with no error and no duplicated blocks in `AGENTS.md`.

<!-- BEGIN MANAGED BLOCK: dot-ai. Installed by dot-ai-init, idempotent block. -->

## dot-ai

Active memory in `dot-ai/`. Read `dot-ai/INDEX.md` first, never scan the whole tree.

Mandatory flow, no exceptions: a new request becomes `intent.md` first. No approved intent means no `plan.md`, no `spec/`, no code. No `plan.md` and `tasks.md` with `status: approved` means no implementation. Intents live in `dot-ai/tracks/NNN-slug/intent.md`, drafted by the `dot-ai-intent` skill.

- Valid handoff: only the 3 most recent in `dot-ai/handoffs/`. Ignore `archive/`.
- A track with `plan.md` and no `spec/` has no spec. Do not look for one.
- Track root holds only `intent.md`, `plan.md`, `tasks.md`, `decisions.md`, plus `spec/` and `assets/`. Loose files are forbidden. Auxiliary outputs go under `assets/`.
- `refs/` is immutable. Source changed, new file.
- A recorded decision is never relitigated.
- Full cycle: the `dot-ai-specify` wrapper from the skill package, run with the target repo as working directory. Never the Spec Kit script directly.

<!-- END MANAGED BLOCK: dot-ai -->
