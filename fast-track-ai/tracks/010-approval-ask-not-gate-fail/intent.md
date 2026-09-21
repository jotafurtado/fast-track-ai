---
id: 010-approval-ask-not-gate-fail
status: shipped
research: []
assessments: []
refs: []
decisions: []
---

# Intent: Ask Approval, Do Not Report Draft Gate Fail

## Problem
After `fast-track-ai-plan` writes `spec.md` / `plan.md` and `tasks.md`, it runs the structural gate and reports `FAIL: plan.md status must be approved, got draft` as if something broke. That result is the draft state the skill itself just wrote. The user is asked to approve in the same breath as a failure. The useful sentence is missing: the spec and tasks exist; do you approve so we can implement?

## Proposed outcome
The plan (or later `fast-track-ai-spec`) skill tells the user that `spec.md` and `tasks.md` were written and asks for approval to continue. It does not present the draft-state gate result as a failure. The gate still runs after implementation, when approved artifacts and closed tasks are the pass condition.

A draft-state check may stay as an internal structural smoke test. Its draft-status miss is not user-facing copy.

## Users and systems
Method maintainers who approve a spec. Coding agents running the plan/spec skill. Affected systems: `fast-track-ai-plan` (or `fast-track-ai-spec` after `008`), the gate script only if its messages must split draft-from-broken, and the managed AGENTS block if it currently tells agents to report that FAIL.

## Constraints
Keep user-facing package prose in English. Stay inside the six-skill package. Do not weaken the approval lock. Do not auto-approve. Do not close `008` or `009` here.

## Out of scope
Unified spec (`008`). Track terminal states (`009`). Open questions moving onto spec and tasks (`006`). ADR standard (`004`). Adding a seventh skill.

## Assumed state
On 2026-09-19 the maintainer approved the `004` plan and said the draft-gate FAIL line is a bad message. They want: spec and tasks were written; ask if they approve so we can continue. Plan skill step 5 still says to run the gate and that failure on draft approval is expected.

## Open questions
None.
