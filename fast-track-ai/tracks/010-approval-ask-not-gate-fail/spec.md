---
status: approved
---

# Spec: 010-approval-ask-not-gate-fail

Thin product description owned by this package. Not a Spec Kit artifact.

## Outcome

After `fast-track-ai-spec` writes `spec.md` and `tasks.md`, the user-facing copy is: those files exist; do you approve so we can implement? It does not present the draft-state gate result as a failure.

The implement-time gate is unchanged. It still PASSes only with approved `spec.md` and `tasks.md` and closed tasks. A draft-status miss may stay as an internal smoke test. That miss is not user-facing copy.

The approval lock stays. The skill does not auto-approve. Tracks already `shipped` (`008`, `009`) are not rewritten.

## Phases

### Phase 1: Spec skill asks, does not report draft FAIL
Done: Spec skill and command tell the user that `spec.md` and `tasks.md` were written and ask for approval. They do not present `FAIL: spec.md status must be approved, got draft` (or the tasks equivalent) as a user-facing failure. Real structural breakage (missing Files/Accept/Validate, leftover `plan.md`, loose files) still surfaces.
Files: `skills/fast-track-ai-spec/SKILL.md`, `commands/fast-track-ai-spec.md`
Accept: Both name the written-files ask; neither tells the agent to report a draft-status gate miss as FAIL.

### Phase 2: Implement-time gate stays the lock
Done: The default gate still fails draft or open tasks. Spec skill may run that check as an internal smoke test. If it does, only non-draft breakage is user-facing. The gate script changes only if a draft-from-broken split is required.
Files: `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh` only if the split needs a script change
Accept: Default gate still exits 1 on draft spec/tasks; user-facing spec-skill copy still has no draft-status FAIL.

### Phase 3: Scratch validation
Done: In `/tmp`, a fresh draft spec+tasks run does not surface draft-status FAIL as the user-facing result. The same artifacts still fail the default implement-time gate. This repo is not the scratch target. Frozen `001` evals are not rewritten.
Files: none in this repo beyond reading the scripts above
Accept: Scratch user-facing copy is the approval ask; default gate on those drafts exits 1.

## Constraints

Keep user-facing package prose in English. Stay inside the six-skill package. Do not weaken the approval lock. Do not auto-approve. Do not close `008` or `009`. Do not rewrite frozen `001` prose. Validate method changes in `/tmp`.

## Out of scope

Unified spec (`008`, shipped). Track terminal states (`009`, shipped). Open questions moving onto spec and tasks (`006`, shipped). ADR standard (`004`, shipped). Adding a seventh skill.

## File rules
Auxiliary outputs (inventories, reports, exports, evidence) go under `assets/`, never loose at the track root. Track root holds only `intent.md`, `spec.md`, `tasks.md`, `decisions.md`, plus `assets/`. Live tracks must not keep `plan.md`. A leftover `spec/` directory is historical and does not select a cycle.
