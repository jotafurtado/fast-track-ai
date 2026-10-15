---
status: approved
---

# Spec: 008-unified-spec

Thin product description owned by this package. Not a Spec Kit artifact.

## Outcome

There is no `plan.md` on a live track. One `spec.md` has two sections and one approval:

1. Outcome — what is true when the track closes.
2. Phases — Done, Files, Accept.

`tasks.md` stays: one item per step, each with Files and Validate. Implement still touches only listed Files.

`fast-track-ai-plan` (skill directory, `name`, and `commands/fast-track-ai-plan.md`) is renamed to `fast-track-ai-spec`. That skill writes the unified `spec.md` and `tasks.md`. The structural gate moves with it. After explicit approval, `spec.md` and `tasks.md` are both `status: approved`. The gate fails if one is approved and the other is not, or if `plan.md` is present on a live track.

`fast-track-ai-intent` drafts `intent.md` only. It does not write `spec.md`.

Still six skills: `init`, `intent`, `spec`, `implement`, `research`, `handoff`.

Live track roots that still hold a separate `plan.md` (`002`, `004`, `005`, `006`, `007`) fold phases into `spec.md` and drop `plan.md`. Frozen `001` prose under `spec/` is not rewritten.

Unanswered intent `Open questions` land in the unified `spec.md` phases and in `tasks.md`. Writers do not invent answers.

## Cycle

intent.md (draft allowed) → `fast-track-ai-spec` drafts `spec.md` and `tasks.md` → approval → implement.

## Phases

### Phase 1: Rename plan skill to spec
Done: `skills/fast-track-ai-plan/` is `skills/fast-track-ai-spec/`. Skill `name` is `fast-track-ai-spec`. `commands/fast-track-ai-plan.md` is `commands/fast-track-ai-spec.md`. The skill writes unified `spec.md` and `tasks.md`. Gate script and `tasks.md` / `decisions.md` assets move with it. `plan.md` asset is gone. Cross-skill sibling paths point at `fast-track-ai-spec`.
Files: `skills/fast-track-ai-plan/` (renamed), `skills/fast-track-ai-spec/SKILL.md`, `commands/fast-track-ai-plan.md` (renamed), `commands/fast-track-ai-spec.md`, `install.sh`, `AGENTS.md`
Accept: Six skills remain; `install.sh` links `fast-track-ai-spec` and zero `fast-track-ai-plan`; command file names `fast-track-ai-spec`.

### Phase 2: Unified spec template and intent stops writing spec
Done: Spec skill owns `assets/spec.md` with Outcome plus Phases (Done, Files, Accept), Constraints, Out of scope. Intent skill and command draft `intent.md` only. Intent no longer owns a spec template. Unanswered intent `Open questions` are copied into spec Phases and `tasks.md`. Writers do not invent answers.
Files: `skills/fast-track-ai-spec/assets/spec.md`, `skills/fast-track-ai-spec/SKILL.md`, `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-intent/assets/spec.md` (removed), `commands/fast-track-ai-intent.md`
Accept: Intent skill greps find no write of `spec.md`; spec template has `## Phases` plus `Files:` and `Accept:`; resources eval names `./assets/spec.md` on the spec skill.

### Phase 3: Gate, AGENTS, implement, live evals
Done: Gate requires approved `spec.md` and `tasks.md` together, Files/Accept on the spec, Files/Validate on tasks, closed tasks. Gate fails if `plan.md` is present on a live track or if one of spec/tasks is approved and the other is not. Allowed track-root names drop `plan.md`. AGENTS map and managed block say intent → spec + tasks → implement. Implement reads spec and tasks, not `plan.md`, and references `../fast-track-ai-spec/`. Live eval fixtures stop requiring `plan.md`.
Files: `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`, `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`, `skills/fast-track-ai-implement/SKILL.md`, `commands/fast-track-ai-implement.md`, `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`, `fast-track-ai/tracks/001-skill-standards/spec/evals.md`
Accept: Fixture with approved closed spec+tasks and no `plan.md` exits 0; same fixture with `plan.md` exits 1; spec approved and tasks draft exits 1.

### Phase 4: Fold live `plan.md` into `spec.md`
Done: Live track roots that still hold `plan.md` (`002`, `004`, `005`, `006`, `007`) have those phases under `spec.md` Phases and no `plan.md`. This track folds its own phases the same way after the other folds, so 008 ships without `plan.md`. Frozen `001` prose under `spec/` is not rewritten. `001` has no root `plan.md`.
Files: `fast-track-ai/tracks/002-assessment-standard/spec.md`, `fast-track-ai/tracks/002-assessment-standard/plan.md` (removed), `fast-track-ai/tracks/004-adr-standard/spec.md`, `fast-track-ai/tracks/004-adr-standard/plan.md` (removed), `fast-track-ai/tracks/005-lightweight-sdlc/spec.md`, `fast-track-ai/tracks/005-lightweight-sdlc/plan.md` (removed), `fast-track-ai/tracks/006-plan-asks-open-questions/spec.md`, `fast-track-ai/tracks/006-plan-asks-open-questions/plan.md` (removed), `fast-track-ai/tracks/007-refs-and-owned-review/spec.md`, `fast-track-ai/tracks/007-refs-and-owned-review/plan.md` (removed), `fast-track-ai/tracks/008-unified-spec/spec.md`, `fast-track-ai/tracks/008-unified-spec/plan.md` (removed)
Accept: Those six track roots have `## Phases` and no `plan.md`; `test ! -e` each removed `plan.md`; frozen `001` `spec/` files are unchanged.

### Phase 5: Scratch validation
Done: Init, install, index, approval, spec, and resources selectors are green in `/tmp`. A scratch live track with `plan.md` fails the new gate. This repo is not the scratch target.
Files: none in this repo beyond reading the scripts above
Accept: Scratch `run-evals.sh all` exits 0; injecting `plan.md` on an otherwise closed track makes the gate exit 1.

## Constraints

Keep user-facing package prose in English. Stay inside six skills. Do not add a spec-approval pause separate from phase approval. Do not merge outcome and phases into one unstructured blob. Do not delete `tasks.md`. Do not rewrite frozen `001` prose. Do not close `004`, `009`, or `010`. Validate method changes in `/tmp`.

## Out of scope

The ADR standard (`004`, shipped). Open questions moving with the spec (`006`, shipped). Refs and owned review (`007`, shipped). Track terminal states (`009`). Approval ask vs draft-gate FAIL (`010`). Adding a seventh skill. Vendoring Matt Pocock `code-review`.
