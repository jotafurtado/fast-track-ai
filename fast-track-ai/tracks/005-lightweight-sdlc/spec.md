---
status: draft
---

# Spec: 005-lightweight-sdlc

Thin product description for the lightweight `fast-track-ai` method. Not a Spec Kit artifact.

## Cycle

One cycle, no fork:

1. `intent.md` at `fast-track-ai/tracks/NNN-slug/intent.md`, `status: draft` until explicit approval, then `status: active`.
2. Required `spec.md` at the same track root, owned by this package. No plan approval without it.
3. `plan.md` and `tasks.md` at the track root. Implementation only after both have `status: approved`.
4. Implementation follows those two files, then the structural gate and `/code-review`.

Locks: no approved intent means no spec, plan, or code. No `spec.md` means no plan approval. No approved plan and tasks means no implementation.

Removed: `via` and `via_reason` / `via_motivo`; `dot-ai-specify.sh`; track `spec/` as a cycle directory; root `specs/` view; `.specify/feature.json` and `.specify/assessments`.

## Identity

| Current | After |
|---|---|
| `dot-ai/` | `fast-track-ai/` |
| `skills/dot-ai-*`, `name: dot-ai-*` | `skills/fast-track-ai-*`, `name: fast-track-ai-*` |
| `commands/dot-ai-*.md` | `commands/fast-track-ai-*.md` |
| `dot-ai-init.sh`, `dot-ai-index.sh` | `fast-track-ai-init.sh`, `fast-track-ai-index.sh` |
| `sdd-gate.sh` | `fast-track-ai-gate.sh` |
| `BEGIN MANAGED BLOCK: dot-ai` | `BEGIN MANAGED BLOCK: fast-track-ai` |
| `install.sh` glob `skills/dot-ai-*` | `skills/fast-track-ai-*` |

`dot-ai-specify.sh` is deleted, not renamed.

## Document catalog

| Type | Location | Owner | Baseline frontmatter |
|---|---|---|---|
| intent | `fast-track-ai/tracks/NNN-slug/intent.md` | `fast-track-ai-intent` | `id`, `status` (`draft\|active\|shipped\|dropped\|superseded`), `research`, `decisions`; `superseded_by` when superseded |
| spec | `fast-track-ai/tracks/NNN-slug/spec.md` | `fast-track-ai-intent` | `status` (`draft\|approved`) |
| plan | `fast-track-ai/tracks/NNN-slug/plan.md` | `fast-track-ai-plan` | `status` (`draft\|approved`) |
| tasks | `fast-track-ai/tracks/NNN-slug/tasks.md` | `fast-track-ai-plan` | `status` (`draft\|approved`) |
| decisions | `fast-track-ai/tracks/NNN-slug/decisions.md` and `fast-track-ai/decisions/` | `fast-track-ai-plan` (thin) | `id`, `status`, `date`, `owner` |
| research | `fast-track-ai/research/<slug>.md` | `fast-track-ai-research` files Matt Pocock `research` | `source`, `captured`, `status: raw`, `owner` |
| assessment | `fast-track-ai/assessments/<date>-<slug>.md` | template owned by `fast-track-ai-init` | `captured`, `status`, `owner`, `scope` |
| handoff | `fast-track-ai/handoffs/<timestamp>-<slug>.md` | `fast-track-ai-handoff` files Matt Pocock `handoff` | none beyond the base skill output |
| index | `fast-track-ai/INDEX.md` | `fast-track-ai-init` (`fast-track-ai-index.sh`) | generated; columns `track`, `status` |
| refs | `fast-track-ai/refs/` | index validates | `sha256`; max 500 KB |

## Init tree

`fast-track-ai-init.sh` creates `fast-track-ai/{research,refs,handoffs/archive,assessments,decisions,tracks}` and `INDEX.md`, and installs the managed AGENTS block. It does not create `specs/`, a root `specs` symlink, or anything under `.specify/`.

## Skills

Six package skills: `init`, `intent`, `plan`, `implement`, `research`, `handoff`, all prefixed `fast-track-ai-`. Declared Matt Pocock dependencies, not vendored: `research`, `handoff`, `grilling`, `code-review`.

## Historical tracks in this repo

- `001-skill-standards/spec/` stays as frozen historical evidence. It does not select a cycle. That track gets a thin root `spec.md` that points at the frozen directory.
- `002` and `004` stay draft and are rewritten later. Only identity and `via` cleanup happen here.
- `003-full-cycle-contract` is set to `status: dropped`.

## Phases

### Phase 1: Catalog templates
Done: Every catalog type has a thin English template and frontmatter. `via` is gone from the intent template. `spec.md` is owned by the intent skill.
Files: `skills/dot-ai-intent/assets/intent.md`, `skills/dot-ai-intent/assets/spec.md`, `skills/dot-ai-plan/assets/plan.md`, `skills/dot-ai-plan/assets/tasks.md`, `skills/dot-ai-plan/assets/decisions.md`, `skills/dot-ai-init/assets/assessment.md`
Accept: Each template file exists with the frontmatter listed in `spec.md`.

### Phase 2: Single cycle, no Spec Kit
Done: Skills, gate, init, and index implement one cycle. Specify is deleted. `spec/` does not select a cycle. Index columns are `track` and `status`.
Files: `skills/dot-ai-intent/SKILL.md`, `skills/dot-ai-intent/scripts/dot-ai-specify.sh`, `skills/dot-ai-plan/SKILL.md`, `skills/dot-ai-plan/scripts/sdd-gate.sh`, `skills/dot-ai-implement/SKILL.md`, `skills/dot-ai-init/SKILL.md`, `skills/dot-ai-init/scripts/dot-ai-init.sh`, `skills/dot-ai-init/scripts/dot-ai-index.sh`, `skills/dot-ai-init/assets/AGENTS-snippet.md`, `skills/dot-ai-research/SKILL.md`, `skills/dot-ai-handoff/SKILL.md`, `commands/dot-ai-init.md`, `commands/dot-ai-intent.md`, `commands/dot-ai-plan.md`, `commands/dot-ai-implement.md`, `commands/dot-ai-research.md`, `commands/dot-ai-handoff.md`
Accept: Gate requires track-root `spec.md` and ignores `spec/` as a cycle; init creates no `specs/` or `.specify/` paths; `dot-ai-specify.sh` is gone.

### Phase 3: Rebrand package surface
Done: Skill directories, `name` fields, commands, scripts, installer globs, and sibling owner paths use `fast-track-ai-*`. Gate script is `fast-track-ai-gate.sh`.
Files: `skills/dot-ai-*` (renamed), `commands/dot-ai-*.md` (renamed), `install.sh`, every SKILL.md and command after the rename, `skills/fast-track-ai-init/scripts/fast-track-ai-init.sh`, `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`, `skills/fast-track-ai-plan/scripts/fast-track-ai-gate.sh`
Accept: `install.sh` links six `fast-track-ai-*` skills and zero `dot-ai-*` skills.

### Phase 4: Rebrand this repo's method memory
Done: `dot-ai/` is `fast-track-ai/`. Live intents no longer have `via`. `003` is `dropped`. `001` has a thin root `spec.md` pointing at frozen `spec/`. Root `specs` and `.specify/` are gone. AGENTS map and managed block say `fast-track-ai`.
Files: `dot-ai/` (renamed to `fast-track-ai/`), `AGENTS.md`, `specs`, `.specify/`, `fast-track-ai/tracks/001-skill-standards/intent.md`, `fast-track-ai/tracks/001-skill-standards/spec.md`, `fast-track-ai/tracks/002-assessment-standard/intent.md`, `fast-track-ai/tracks/003-full-cycle-contract/intent.md`, `fast-track-ai/tracks/004-adr-standard/intent.md`, `fast-track-ai/tracks/005-lightweight-sdlc/intent.md`, `fast-track-ai/INDEX.md`
Accept: `test -d fast-track-ai/tracks` and `test ! -e dot-ai` and `test ! -e specs` and `test ! -e .specify`; index has no `via` column; `003` status is `dropped`.

### Phase 5: Live evals and package contract
Done: Live runner and evals table match the new prefix and cycle. Frozen 001 prose is untouched. Package contract uses `fast-track-ai-*` sibling paths.
Files: `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`, `fast-track-ai/tracks/001-skill-standards/spec/evals.md`, `fast-track-ai/tracks/001-skill-standards/spec/contracts/skill-package.md`
Accept: `specify` selector is gone; a `spec` selector asserts required track-root `spec.md` and rejects missing spec before plan approval.

### Phase 6: Scratch validation
Done: Init, index, gate, and install are green on a fresh `/tmp` target. A second init is idempotent. This repo is not used as the scratch target.
Files: none in this repo beyond reading the scripts above
Accept: `bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all` exits 0.
