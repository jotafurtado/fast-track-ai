# AGENTS.md - fast-track-ai repo

Method `fast-track-ai`, a lightweight agent-driven SDLC. Binding norm lives in Obsidian, `10 - Projetos/Code/dot-ai/dot-ai - Fundamentos v1.2.md`. Obsidian holds only the norm. This repo holds the executable: skills, commands, scripts, and templates, all inside `skills/`.

## Map

- `commands/` - slash commands, 1 file per command (`fast-track-ai-init`, `fast-track-ai-intent`, `fast-track-ai-plan`, `fast-track-ai-implement`, `fast-track-ai-research`, `fast-track-ai-handoff`)
- `skills/fast-track-ai-*/SKILL.md` - procedure each command runs
- `skills/fast-track-ai-init/` - SKILL.md plus `scripts/` (`fast-track-ai-init.sh`, `fast-track-ai-index.sh`) plus `assets/` (`AGENTS-snippet.md`, `assessment.md`)
- `skills/fast-track-ai-intent/` - SKILL.md plus `assets/` (`intent.md`, `spec.md`)
- `skills/fast-track-ai-plan/` - SKILL.md plus `scripts/` (`fast-track-ai-gate.sh`) plus `assets/` (`plan.md`, `tasks.md`, `decisions.md`)
- `skills/fast-track-ai-implement/`, `fast-track-ai-research/`, `fast-track-ai-handoff/` - SKILL.md only, referencing owner copies

Skills run against the target repo `fast-track-ai/` tree using scripts and templates bundled in this package. No machine-fixed paths. Only `fast-track-ai-init` installs anything, through its own script path.

## Rules

- Code in English: folders, files, functions, variables, frontmatter fields.
- User-facing prose in English: commands, skills, error messages.
- Surgical changes: 1 behavior per change, validated in `/tmp` before commit.
- No stubs: a published script must actually run in the test below.
- A live target project is never edited from here. Method changes validate in `/tmp`.
- Each script and template has one owner skill. Cross-skill consumers reference the owner copy via package-relative sibling paths. No `shared` link.

## Install

`install.sh` links every `skills/fast-track-ai-*` into the harness skills dirs. No `shared` link exists: each skill owns its resources and cross-skill references point at owner copies. Same link set on any machine:

```bash
./fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all
```

`init` must be idempotent: run twice with no error and no duplicated blocks in `AGENTS.md`.

<!-- BEGIN MANAGED BLOCK: fast-track-ai. Installed by fast-track-ai-init, idempotent block. -->

## fast-track-ai

Active memory in `fast-track-ai/`. Read `fast-track-ai/INDEX.md` first, never scan the whole tree.

Mandatory flow, no exceptions: a new request becomes `intent.md` first. No approved intent means no `spec.md`, no `plan.md`, no code. No `spec.md` means no plan approval. No `plan.md` and `tasks.md` with `status: approved` means no implementation. Intents live in `fast-track-ai/tracks/NNN-slug/intent.md`, drafted by the `fast-track-ai-intent` skill.

- Assessments live in `fast-track-ai/assessments/<YYYY-MM-DD>-<slug>.md`. They are inward research with no status and are input for a later intent. Cite them on an intent in `assessments:`, not in `research:`. External research stays in `fast-track-ai/research/`.
- Valid handoff: only the 3 most recent in `fast-track-ai/handoffs/`. Ignore `archive/`.
- Track root holds only `intent.md`, `spec.md`, `plan.md`, `tasks.md`, `decisions.md`, plus `assets/`. A leftover `spec/` directory is historical and does not select a cycle. Loose files are forbidden. Auxiliary outputs go under `assets/`.
- `refs/` is immutable. Source changed, new file.
- Architecture Decision Records live in `fast-track-ai/decisions/<NNN-slug>.md`. Cite them on an intent in `decisions:`. A recorded Decision is never relitigated.
- Each script and template has one owner skill. Cross-skill consumers reference the owner copy via package-relative sibling paths. No `shared` link.

<!-- END MANAGED BLOCK: fast-track-ai -->
