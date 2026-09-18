---
id: 005-lightweight-sdlc
status: active
research: []
decisions: [001-spec-md-owner, 002-historical-spec-dir, 003-live-evals-vs-frozen-spec, 004-drop-vendored-speckit]
---

# Intent: Adopt fast-track-ai as a Lightweight SDLC

## Problem
The repository is named `fast-track-ai`, but the executable method is still `dot-ai`. Skills, commands, scripts, the knowledge tree, the managed AGENTS block, and `via` values all publish the old name. The same package also carries a Spec Kit full cycle: `dot-ai-specify.sh`, `spec/` as a Spec Kit feature directory, root `specs/` and `.specify/` compatibility views, and a `via: rapida | completa` (later `speckit | dot-ai`) fork. That second cycle is heavier than the maintainer wants. Document types already exist (intent, plan, tasks, decisions, research, assessment, handoff, index, refs), but their templates and frontmatter are inconsistent, and two of them (`002`, `004`) were opened as separate standards instead of sitting in one lightweight catalog.

## Proposed outcome
The method identity is `fast-track-ai` everywhere: tree, skills, commands, scripts, managed AGENTS block, installer globs, package contract, and evals. Spec Kit is removed. There is one lightweight cycle owned by this package:

1. Draft `intent.md`, then explicit approval (`status: active`).
2. Required thin `spec.md` at the track root, owned by this package.
3. Draft `plan.md` and `tasks.md`; no plan approval unless `spec.md` exists.
4. Implement only after plan and tasks are `status: approved`.

No `spec/` Spec Kit directory, no specify wrapper, no root `specs/` view, no `.specify/` feature file. The intent `via` field is removed; the index lists track and status only.

The document catalog stays the current set. This track ships baseline location, English frontmatter, and thin templates for every type, including minimal assessment and decisions templates so the catalog is usable on day one. Tracks `002` and `004` later deepen those two standards. `research`, `handoff`, `grilling`, and `code-review` remain Matt Pocock base skills; this package calls them and files `research` and `handoff` outputs under the method tree.

After install, a target repository is initialized with `fast-track-ai/` and the six `fast-track-ai-*` skills. Method memory created under `dot-ai/` in this repo is migrated with the rebrand. Track `003-full-cycle-contract` is dropped. The shipped `001-skill-standards` spec remains historical evidence and is not rewritten into the new cycle.

## Users and systems
Method maintainers and coding agents use the package in this repo and in initialized targets. Affected systems: `skills/`, `commands/`, `install.sh`, init/index/gate scripts, AGENTS map and managed block, skill-package contract, 001 evals that assert `dot-ai-*`, the method tree, and the draft tracks that still name Spec Kit or `dot-ai`.

## Constraints
Keep user-facing package prose in English. Validate method changes only in `/tmp`. Do not vendor scripts or templates into target repositories. Do not vendor Matt Pocock skills; depend on the installed base `research`, `handoff`, `grilling`, and `code-review` skills. Preserve the intent-before-plan and plan-before-implementation locks. Cross-skill references stay package-relative sibling owner paths. `install.sh` stays portable and idempotent. A live third-party target is never edited from this repo.

## Out of scope
Rewriting the Obsidian binding norm in this track. Changing the internals of Matt Pocock skills. Closing the full assessment standard (`002`) or ADR standard (`004`) beyond the thin baselines shipped here. Rewriting the contents of the frozen `001-skill-standards` spec. Shipping a second, heavier specification cycle under another name.

## Assumed state
On 2026-09-18 the maintainer decided:
- Forget `dot-ai` and adopt `fast-track-ai` for the package, the method tree, scripts, commands, and the managed block.
- Drop Spec Kit. This package is a lightweight SDLC whose purpose is to standardize document types.
- Keep the current document catalog: intent, plan, tasks, decisions, research, assessment, handoff, index, refs. Do not add or drop types here.
- One execution cycle. Every active track has a required thin `spec.md` at the track root before plan approval. `spec.md` is not a Spec Kit artifact.
- Remove the intent `via` field. It no longer routes a cycle.
- Declared Matt Pocock dependencies: `research`, `handoff`, `grilling`, and `code-review`.
- This track ships thin baseline templates and frontmatter for assessment and decisions; `002` and `004` deepen them later.
- Drop `003-full-cycle-contract`. Freeze the `001` spec as historical. Rewrite `002` and `004` later under `fast-track-ai`.

The six skills are still `dot-ai-init`, `dot-ai-intent`, `dot-ai-plan`, `dot-ai-implement`, `dot-ai-research`, and `dot-ai-handoff`. `dot-ai-specify.sh` still prepares `spec/` and emits `/speckit.specify`. Init still creates `dot-ai/specs`, the root `specs` symlink, and an optional `.specify/assessments` link. Intent, plan, and implement still branch on `spec/` and `via: completa`. Existing draft intents, including this one, still carry `via` until the track is implemented.

## Open questions
None.
