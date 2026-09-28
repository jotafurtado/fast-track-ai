# Proposal

## Why

The cycle skills contradict themselves at their transitions. The 2026-09-21 assessments `skills-simplification` (items 2.1-2.3, 3.3, 3.4, 4.1-4.4, 8.3, 8.4) and `delivery-quality` (findings 1, 3, 5) found this, and a re-check confirmed it against the tree after `harden-method-scripts`:

- Implement runs the completion gate before it marks checkboxes.
- It allows edits only to listed files, yet requires index and intent edits.
- It offers ship without tying spec `Accept:` lines to evidence or re-validating after review fixes.
- Intent allocates a track before it knows whether the request changes anything.
- Spec turns every open question into a task, including questions that decide scope.

Now that the gate and index check what they claim, the procedure text can rely on them.

## What Changes

- **Intent classifies before creating a track.** Research-only and assessment-only requests go directly to `fast-track-ai-research` or `fast-track-ai-assess`, with no track number, no `intent.md`, and no exit line. **BREAKING** (protocol copy): the line `Track concluida. Nenhuma implementacao necessaria.` is removed from the intent skill, the continuous-flow capability, the AGENTS house-rule exception, and the `flow` eval.
- **Intent and spec regenerate `INDEX.md`** after their own writes: a new or revised intent, a terminal status change, and spec or tasks drafts together with any ADRs they file.
- **Spec separates blocking questions from deferrable ones.** Blocking questions change scope, security, persistence, external integration, architecture, or acceptance. They are asked before the spec summary is presented, and the summary is withheld while any stays open. Deferrable questions become bounded tasks that dependent groups wait on.
- **Approval covers the presented version.** `.` after the spec summary approves exactly the `spec.md` and `tasks.md` that were presented. A later material change in spec or implement returns both files to `draft` and requires a new summary.
- **Implement persists each task's `[x]` as soon as its Validate passes**, so the completion gate checks durable state.
- **Implement separates product files from method-administration files.** Product files are limited to the listed Files. Method-administration files (`tasks.md` checkboxes, the track `assets/`, `INDEX.md`, intent status, ADRs) change only through named transitions.
- **Implement records acceptance evidence** in `assets/acceptance.md`, one row per phase `Accept:` plus the Outcome, and offers ship only when every row is met.
- **Implement loops review, fix, and revalidation.** A `[blocking]` finding triggers the fix, then the affected Validate commands, acceptance checks, gate, and review run again. The reported evidence comes from the state after the last fix.
- **Implement is harness-neutral.** It uses whatever task tracker the harness provides (no `TodoWrite` name) and runs groups sequentially when subagents are unavailable.
- **Auxiliary calls return to the caller.** When intent triggers research or an assessment during a change request, that skill returns its conclusion, limitations, and artifact path to the intent skill, without its own summary or next-step line. A direct call answers the user.
- **Continuation summaries are scoped to the cycle skills.** The four-bullet summary and `.` next-step line apply to intent, spec, and implement only. Init, research, assess, and handoff end with their result and pending items. The implement bullets become: completed tasks, acceptance, review outcome, gate result.

## Capabilities

### New Capabilities
- `implement-workflow`: The implement skill's execution contract: durable task completion, file categories, harness neutrality, acceptance evidence before ship, and the review-fix-revalidate loop.

### Modified Capabilities
- `continuous-flow`:
  - Summaries and `.` apply only to intent, spec, and implement.
  - Non-implementation requests create no track, and the exit line is removed from the Portuguese copy requirement.
  - New requirements: spec approval scope, blocking-question handling, the auxiliary return contract, and cycle-skill index regeneration.
- `package-surface`: The `flow` eval no longer requires the removed exit line and fails if it reappears in the intent skill.

## Impact

- **Skills:** `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-spec/SKILL.md`, `skills/fast-track-ai-implement/SKILL.md`, `skills/fast-track-ai-research/SKILL.md`, `skills/fast-track-ai-assess/SKILL.md`.
- **Commands:** `commands/fast-track-ai-intent.md`, `commands/fast-track-ai-spec.md`, `commands/fast-track-ai-implement.md`, `commands/fast-track-ai-research.md`, `commands/fast-track-ai-assess.md`.
- **AGENTS:** `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, plus this repository's `AGENTS.md` house rule and managed block. The block is refreshed with the owner init script.
- **Evals:** `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh` (the `flow` selector) and `spec/evals.md`.
- **Not in scope:**
  - Assessment items 4.5 (selective parallelism), 4.6, 4.7 (resume), 4.8, 2.4, 2.5, and 1.5.
  - Template slimming (3.5, 7.4, 8.1).
  - Research and assess collision rules (5.1, 6.3).
  - Agent-driven behavioral evals (delivery-quality 2).
  - Any gate or index script change.
