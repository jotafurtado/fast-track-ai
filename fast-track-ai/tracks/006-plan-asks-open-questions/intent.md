---
id: 006-plan-asks-open-questions
status: shipped
research: []
assessments: []
refs: []
decisions: []
---

# Intent: Open Questions Move With The Spec

## Problem
The current lock pauses on intent approval. An intent can also ship with unanswered `Open questions`. Track `006` previously proposed that the plan skill ask those questions, write answers back into the intent, and only then write `plan.md`. The maintainer now wants a later cycle where the intent is not an approval gate, and leftover questions become work on the spec and the tasks instead of a second interview on the intent.

A vague request is a different case. Today the intent skill can grill without a cap. A long interview on the intent delays the spec. The spec writer (plan lives in the spec after `008`) is the place for remaining questions.

## Proposed outcome
Drafting an intent does not require approval before spec and tasks may be written. Unanswered items under `Open questions` are copied into `spec.md` and `tasks.md` as work to resolve. The spec and task writers do not invent answers. The intent stays a problem statement; it is not a second approval ceremony.

If the request is too vague to draft an intent, the agent may ask the user. Prefer the host interactive ask pattern. Cap: three questions in that pass. Any further questions go on the spec (and `tasks.md`), not into a second intent interview. Answers that arrive in that pass are written into the intent; unanswered leftovers stay as work on the spec.

This track replaces the earlier `006` outcome (plan asks, then clears the intent section). It does not implement until this intent is itself approved under the cycle that still applies today.

## Users and systems
Method maintainers and coding agents who draft and specify a track. Affected systems: `fast-track-ai-intent` (including the unbounded `grilling` step), the host interactive ask pattern, the current plan skill (or `fast-track-ai-spec` after `008`), `spec.md`, `tasks.md`, the managed AGENTS block, and the structural gate only if it must stop treating intent approval as a lock.

## Constraints
Keep user-facing package prose in English. Stay inside the six-skill package. Do not invent answers to open questions. At intent time, ask at most three questions; prefer the host interactive ask pattern; do not run an unbounded grill. Do not implement this track under the current lock until this intent is approved. Do not close `004`, `007`, `008`, or `009` here.

## Out of scope
The ADR standard (`004`). Unified spec and the plan-skill rename (`008`) — if `008` ships first, the questions land in the unified `spec.md` phases and in `tasks.md`. Refs and owned review (`007`). Track terminal states (`009`). Adding a seventh skill.

## Assumed state
On 2026-09-19 the maintainer approved `004` and said the future flow is: the intent does not have to be approved; open questions must enter the spec and the tasks. Later the same day they added: if the intent is too vague, the agent may question the user, prefer the interactive ask pattern, stop at three questions, and leave the rest for the spec because plan and spec become one document. The live lock still is: no approved intent means no spec, plan, or code. `008` is still draft and still names `fast-track-ai-spec`. Intent skill step 3 still says to grill shallow ideas with Matt Pocock `grilling` and has no question cap.

## Open questions
None.
