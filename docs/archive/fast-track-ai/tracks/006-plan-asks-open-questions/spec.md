---
status: approved
---

# Spec: 006-plan-asks-open-questions

Thin product description owned by this package. Not a Spec Kit artifact.

## Outcome

An intent is a problem statement. Drafting it does not block `spec.md` or `tasks.md`. Those files may be written while the intent is still `draft`.

Unanswered items under the intent `Open questions` section are copied into `spec.md` and `tasks.md` as work to resolve. The spec and task writers do not invent answers.

If the request is too vague to draft an intent, the agent may ask the user. Prefer the host interactive ask pattern. Cap: three questions in that pass. Answers from that pass are written into the intent. Any further questions go on the spec and `tasks.md`, not into a second intent interview.

This replaces the earlier `006` outcome (the plan skill interviews the user, writes answers back into the intent, then writes `plan.md`). Matt Pocock `grilling` is not an unbounded interview at intent time.

If `008` has already shipped, leftover questions land in the unified `spec.md` phases and in `tasks.md`. If `008` has not shipped, leftover questions land in the current `spec.md` / `plan.md` pair and in `tasks.md`. The structural gate and the managed AGENTS block stop treating intent approval as the lock that blocks those files.

## Cycle

intent.md (draft allowed) → `fast-track-ai-spec` drafts `spec.md` and `tasks.md` → approval → implement.

## Phases

### Phase 1: Intent asks at most three questions
Done: A vague request gets at most three questions via the host interactive ask pattern. Answers from that pass go into the intent. Leftover items stay under `Open questions`. Matt Pocock `grilling` is not an unbounded interview. Drafting the intent does not block `spec.md`.
Files: `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-intent/assets/spec.md`
Accept: Intent skill names the three-question cap, the host interactive ask, and writing `spec.md` while intent may still be `draft`.

### Phase 2: Open questions become spec and task work
Done: The plan skill writes `plan.md` and `tasks.md` without requiring intent `status: active`. Unanswered `Open questions` are copied into `spec.md` (or `plan.md` if `008` has not shipped) and `tasks.md` as work to resolve. Writers do not invent answers.
Files: `skills/fast-track-ai-plan/SKILL.md`, `commands/fast-track-ai-plan.md`
Accept: Plan skill and command no longer stop on a draft intent; they name the copy-do-not-invent rule.

### Phase 3: Locks and gate drop intent approval
Done: AGENTS, implement, and the structural gate no longer treat intent approval as the lock that blocks spec, plan, tasks, or code. The gate still requires `intent.md`, approved `plan.md` and `tasks.md`, and closed tasks. A draft intent with those artifacts passes.
Files: `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`, `skills/fast-track-ai-implement/SKILL.md`, `commands/fast-track-ai-implement.md`, `skills/fast-track-ai-plan/scripts/fast-track-ai-gate.sh`, `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`, `fast-track-ai/tracks/001-skill-standards/spec/evals.md`
Accept: Gate with draft intent plus approved closed plan/tasks exits 0; AGENTS no longer says no approved intent means no spec.

### Phase 4: Scratch validation
Done: Init, index, and the changed approval fixture are green in `/tmp`. This repo is not the scratch target.
Files: none in this repo beyond reading the scripts above
Accept: Scratch approval eval exits 0; draft intent no longer fails the gate when plan and tasks are approved and closed.

## Constraints

Keep user-facing package prose in English. Stay inside the six-skill package. Do not invent answers to open questions. At intent time, ask at most three questions; prefer the host interactive ask pattern; do not run an unbounded grill. Do not close `004`, `007`, `008`, or `009`. Validate method changes in `/tmp`.

## Out of scope

The ADR standard (`004`). Unified spec and the plan-skill rename (`008`). Refs and owned review (`007`). Track terminal states (`009`). Adding a seventh skill.
