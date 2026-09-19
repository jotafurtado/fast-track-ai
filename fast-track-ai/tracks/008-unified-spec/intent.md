---
id: 008-unified-spec
status: draft
research: []
assessments: []
refs: []
decisions: []
---

# Intent: Unified Spec

## Problem
The cycle splits *what* and *how* across `spec.md` and `plan.md`, then asks one approval for the plan. The plan skill only marks `plan.md` and `tasks.md`. The gate only requires that `spec.md` exists. Track `002` shipped with an approved plan and a spec still on `status: draft`. Syncing those two statuses (the previous 008 draft) treats the symptom. Two files with one approval is the cause.

The skill that writes the how is still named `fast-track-ai-plan` and still emits `plan.md`.

## Proposed outcome
There is no `plan.md`. One `spec.md` has two sections and one approval:

1. Outcome — what is true when the track closes (today's spec).
2. Phases — Done, Files, Accept (today's plan).

`tasks.md` stays: one item per step. Implement still touches only listed Files.

`fast-track-ai-plan` (skill directory, `name`, and `commands/fast-track-ai-plan.md`) is renamed to `fast-track-ai-spec`. That skill writes the unified `spec.md` and `tasks.md`. The structural gate moves with it. After explicit approval, `spec.md` and `tasks.md` are both `status: approved`. The gate fails if one is approved and the other is not, or if `plan.md` is present on a live track.

Cycle: intent (`status: active`) → this skill drafts `spec.md` and `tasks.md` → approval → implement. `fast-track-ai-intent` no longer writes `spec.md` after intent approval.

Still six skills: `init`, `intent`, `spec`, `implement`, `research`, `handoff`.

Live tracks that already have a separate `plan.md` (`002`, `005`) fold phases into `spec.md` and drop `plan.md`. Frozen `001` prose under `spec/` is not rewritten.

## Users and systems
Method maintainers who approve a spec. Coding agents running intent, spec, implement, and the gate. Affected systems: `skills/fast-track-ai-plan/` (renamed), `commands/fast-track-ai-plan.md` (renamed), gate script, intent skill and spec template, implement skill, AGENTS map and managed block, `install.sh` globs, live track roots that still hold `plan.md`.

## Constraints
Keep user-facing package prose in English. Stay inside six skills. Do not add a spec-approval pause separate from phase approval. Do not merge outcome and phases into one unstructured blob. Do not delete `tasks.md`. Do not rewrite frozen `001` prose. Do not close `004`, `006`, or `007`. Validate method changes in `/tmp`.

## Out of scope
Plan asking open intent questions (`006`) — it still names the plan skill and is rewritten after this track. Refs and owned review (`007`). ADR standard (`004`). Adding a seventh skill. Vendoring Matt Pocock `code-review`.

## Assumed state
On 2026-09-19 the maintainer rejected keeping two files and only syncing `status`. They chose one `spec.md` (outcome + phases), no `plan.md`, `tasks.md` kept. They also chose to rename the plan skill and slash command to `fast-track-ai-spec`. Catalog from `005` still lists a separate plan type. Intent skill still drafts a thin `spec.md` after approval. Gate still ignores spec `status` and requires `plan.md` approved.

## Open questions
None.
