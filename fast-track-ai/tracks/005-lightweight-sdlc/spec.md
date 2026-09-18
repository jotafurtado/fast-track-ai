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
