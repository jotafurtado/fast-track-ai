---
status: draft
---

# Spec: NNN-slug

Thin product description owned by this package. Not a Spec Kit artifact.

## Outcome
What is true when the track closes.

## Phases

### Phase 1: name
Done: what is ready and how to observe it.
Files: explicit list of touched files.
Accept: one acceptance line for the phase.

### Phase 2: name
Done:
Files:
Accept:

## Constraints
Limits that bind the work.

## Out of scope
Repeat the intent limit, never widen it.

## File rules
Auxiliary outputs (inventories, reports, exports, evidence) go under `assets/`, never loose at the track root. Track root holds only `intent.md`, `spec.md`, `tasks.md`, `decisions.md`, plus `assets/`. Live tracks must not keep `plan.md`. A leftover `spec/` directory is historical and does not select a cycle.
