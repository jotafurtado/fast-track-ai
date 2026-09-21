# AGENTS.md - fast-track-ai repo

Method `fast-track-ai`, a lightweight agent-driven SDLC. Binding norm lives in Obsidian, `10 - Projetos/Code/dot-ai/dot-ai - Fundamentos v1.2.md`. Obsidian holds only the norm. This repo holds the executable: skills, commands, scripts, and templates, all inside `skills/`.

## Map

- `commands/` - slash commands, 1 file per command (`fast-track-ai-init`, `fast-track-ai-intent`, `fast-track-ai-spec`, `fast-track-ai-implement`, `fast-track-ai-research`, `fast-track-ai-assess`, `fast-track-ai-handoff`)
- `skills/fast-track-ai-*/SKILL.md` - procedure each command runs
- `skills/fast-track-ai-init/` - SKILL.md plus `scripts/` (`fast-track-ai-init.sh`, `fast-track-ai-index.sh`) plus `assets/AGENTS-snippet.md`
- `skills/fast-track-ai-intent/` - SKILL.md plus `assets/` (`intent.md`, `ref.md`)
- `skills/fast-track-ai-spec/` - SKILL.md plus `scripts/fast-track-ai-gate.sh` plus `assets/` (`spec.md`, `tasks.md`, `decisions.md`)
- `skills/fast-track-ai-assess/`, `skills/fast-track-ai-research/`, and `skills/fast-track-ai-handoff/` - each owns its SKILL.md and artifact template; `skills/fast-track-ai-implement/` owns SKILL.md only

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

Active memory lives in `fast-track-ai/`. Always read `fast-track-ai/INDEX.md` first; never scan the whole tree for discovery. The generated index lists tracks, refs, research, assessments, decisions, and active handoffs.

Mandatory flow, no exceptions: a new request becomes `intent.md` first. The `fast-track-ai-intent` skill drafts `intent.md` only. The `fast-track-ai-spec` skill drafts `spec.md` and `tasks.md`. Intent approval is not required before those files. No `spec.md` and `tasks.md` with `status: approved` means no implementation. Intents live in `fast-track-ai/tracks/NNN-slug/intent.md`.

Supporting artifact contracts:

- A ref preserves an immutable source input at `fast-track-ai/refs/<slug>.md`. It is `inline` or `pointer`, records content identity and license, and is cited on an intent in `refs:`. Changed source bytes require a new ref.
- Research investigates external facts at `fast-track-ai/research/<slug>.md`. It is status-free, multi-source, and cited on an intent in `research:`.
- An assessment evaluates the project, implementation, feature, or idea at `fast-track-ai/assessments/<YYYY-MM-DD>-<slug>.md`. It is status-free, records evaluator plus evidence and counterevidence, and is cited on an intent in `assessments:`, never `research:`.
- A decision preserves a qualifying accepted durable choice at `fast-track-ai/decisions/<NNN-slug>.md`. It uses only `accepted` or `superseded` and is cited on an intent in `decisions:`.
- A handoff transfers active working context at `fast-track-ai/handoffs/<timestamp>-<slug>.md`. Keep the three newest active files and move older files to `handoffs/archive/`; archived handoffs are not active index entries.

Explicit actions: use `fast-track-ai-research` for external investigation, `fast-track-ai-assess` for inward evaluation, and `fast-track-ai-handoff` for context transfer. Each action writes directly from its package-owned template without a third-party runtime skill.

Automatic captures: intent captures a material user-supplied basis as a ref; intent, spec, and implementation capture qualifying accepted decisions as ADRs. Do not add separate ref or ADR commands.

- Track root holds only `intent.md`, `spec.md`, `tasks.md`, `decisions.md`, plus `assets/`. Live tracks must not keep `plan.md`. A leftover `spec/` directory is historical and does not select a cycle. Loose files are forbidden. Auxiliary outputs go under `assets/`.
- A track leaves `active` only by explicit maintainer command. `dropped` abandons the work; implementation is not required. `superseded` requires `superseded_by`. Do not invent `superseded_by`. Implement owns `shipped` and asks before writing it.
- Each script and template has one owner skill. Cross-skill consumers reference the owner copy via package-relative sibling paths. No `shared` link.

<!-- END MANAGED BLOCK: fast-track-ai -->
