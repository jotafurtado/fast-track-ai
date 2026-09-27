---
captured: 2026-09-21
owner: maintainer
scope: delivery-quality guarantees across the fast-track-ai intent, spec, implementation, validation, review, and ship flow
evaluator: openai-codex/gpt-6-astra
tracks: []
---

# Assessment: Delivery quality

## Conclusion

The method provides a sound structure for organizing work, but assurance that the delivered result satisfies the original objective still depends heavily on agent judgment. The highest-impact improvement is to connect the promised outcome to observable evidence before offering ship.

Approval, per-task validation, review, and explicit ship confirmation already exist. The gap is their connection: completed tasks and structurally valid artifacts do not by themselves demonstrate that the final outcome was achieved. This is an assessment of documented guarantees, not an observed failure in a delivered application.

## Scope and basis

This captures the assessment presented in the preceding exploration, against the repository state following commit `daa9040` (`feat: align package live copy with continuous flow and command links`). Saving this document does not authorize any recommendation or implementation.

Inspected evidence:

- `fast-track-ai/INDEX.md` and `fast-track-ai/assessments/2026-09-21-method-flow-fitness.md`.
- Full OpenSpec capabilities: `openspec/specs/continuous-flow/spec.md`, `openspec/specs/method-artifacts/spec.md`, and `openspec/specs/package-surface/spec.md`.
- `openspec/config.yaml`.
- Intent, spec, implement, assess, and handoff skill instructions.
- Intent, spec, and tasks templates, plus the structural gate.
- The flow selector in `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`.
- Track `010` spec and tasks, and ADR `003-live-evals-vs-frozen-spec`.

Commands observed during exploration:

- `openspec list --json`: resolved the local root and returned no active changes.
- `openspec list --specs --json`: listed the three capabilities above.
- `openspec show <capability> --type spec`: read each capability including its scenarios.
- `bash skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh --track 010-approval-ask-not-gate-fail --root .`: returned `PASS: 010-approval-ask-not-gate-fail cycle intact`.
- `bash -n skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`: exited successfully.

The full eval runner had passed all fourteen selectors earlier in this conversation, before the commit. It was not rerun during exploration. No method implementation or OpenSpec planning artifacts were created by the exploration.

## Criteria

- The method connects the user's intended outcome to observable acceptance evidence.
- Approval, implementation, validation, review, and ship transitions prevent premature completion.
- Evaluations distinguish written protocol from actual agent behavior.
- Structural validation checks deterministic invariants without pretending to establish product quality.
- Unresolved decisions block dependent implementation when they materially affect behavior.
- Improvements strengthen existing guarantees without unnecessary artifacts, skills, or approval steps.

## Findings

### 1. High priority: Demonstrate the outcome, not only task completion

**Observed:** `skills/fast-track-ai-spec/assets/spec.md:9-22` requires Outcome, Done, and Accept. `skills/fast-track-ai-implement/SKILL.md:10-16` requires task Validate commands and the final suite, but does not explicitly require demonstrating the Outcome or recording evidence for every Accept criterion.

**Risk [INFERENCE]:** individually passing tasks may coexist with an incomplete integrated user flow.

**Recommendation:** before the final summary, map each acceptance criterion to an executed scenario, its observed evidence, and an explicit met/pending result. Keep this in existing tasks or under `assets/` when substantial; no new artifact type is necessary.

**Verification of a future improvement:** a delivery with passing tasks but an unmet acceptance criterion must not offer ship.

### 2. High priority: Evaluate agent behavior as well as skill text

**Observed:** `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh:779-790` implements the flow selector with six `assert_contains` checks. It proves that required strings exist, not that the agent performs the transitions correctly.

This matches the current requirement in `openspec/specs/package-surface/spec.md` under `Live evals cover the continuous-flow protocol`. It is a limitation of the specified coverage, not a violation of that spec.

**Recommendation:** complement structural checks with a small set of real agent scenarios in a disposable project:

- A user requests a spec revision; implementation does not start.
- A user confirms the spec; both planning artifacts become approved before implementation.
- Validation fails; the agent does not declare completion.
- A decision materially changes the plan; the agent pauses for renewed approval.
- A session resumes; the agent identifies the correct stage and outstanding work.

**Verification of a future improvement:** evaluate actions, resulting artifacts, and transitions rather than prompt wording alone.

### 3. High priority: Close the correction loop after review

**Observed:** `skills/fast-track-ai-implement/SKILL.md:10-16` orders validation, gate, and then review. It defines `[blocking]` as must-fix, but does not explicitly specify correction, revalidation, and renewed review before offering ship.

**Counterpoint:** fixing blockers is already mandatory. The gap concerns evidence after correction, not absence of review.

**Recommendation:** make the sequence explicit: implement, validate, review, correct, and repeat the affected validation and review until blockers are resolved. Final evidence must correspond to the state after the last correction.

**Verification of a future improvement:** when review causes a change, validation results from before that change are insufficient for closure.

### 4. Medium priority: Make the structural gate more precise

**Observed:** `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh:31-35,60-70` searches globally for Files, Accept, and Validate markers and counts open tasks matching `- [ ]`. It does not validate nonempty fields per phase/task, the presence of actual tasks, or group dependency integrity.

**Counterpoint:** the script explicitly describes itself as structural. It should not attempt to judge product quality semantically.

**Recommendation:** strengthen only deterministic invariants:

- Required fields are populated for each task and phase.
- Referenced groups exist and dependencies are acyclic.
- An implementation has at least one valid task.
- Structural success is distinguished from delivery acceptance.

**Verification of a future improvement:** incomplete fixtures and circular dependencies fail with objective messages. Outcome assessment remains the responsibility of execution and review.

### 5. Medium priority: Distinguish blocking questions from deferrable questions

**Observed:** `skills/fast-track-ai-spec/SKILL.md:6-8` carries unanswered questions into phases and tasks. `skills/fast-track-ai-spec/assets/tasks.md:7-14` provides dependency groups. The instructions do not explicitly classify which unanswered questions must be resolved before dependent implementation starts.

**Risk [INFERENCE]:** a question about authorization, persistence, or integration may be treated as an ordinary task while dependent work proceeds on an implicit assumption.

**Recommendation:** questions that materially change behavior, security, or architecture should block dependent groups. Local, reversible questions may remain during execution.

**Verification of a future improvement:** an unresolved decision about who can access a resource prevents implementation of behavior that depends on that decision.

## Evidence against conclusion

The package already has meaningful delivery protections:

- Approval is persisted in both spec and tasks, rather than existing only in conversation (`skills/fast-track-ai-spec/SKILL.md:15`; `skills/fast-track-ai-implement/SKILL.md:6`).
- Implementation is bounded by listed files and explicit scope; a materially conflicting decision requires reconciliation and renewed approval (`skills/fast-track-ai-implement/SKILL.md:7`).
- The main agent owns integration, shared files, review, and final validation (`skills/fast-track-ai-implement/SKILL.md:9`).
- Task validation, a final suite, and blocking review findings are already part of the procedure (`skills/fast-track-ai-implement/SKILL.md:10-11`).
- Checkboxes and a passing gate do not automatically ship a track; user confirmation is required (`skills/fast-track-ai-implement/SKILL.md:15-16`).
- Handoff instructions separate verified work from pending actions and preserve observed command results (`skills/fast-track-ai-handoff/SKILL.md:6-9`).
- Track `010` passed the structural gate during exploration, and the fourteen-selector suite passed earlier in the conversation.

These facts support improving the existing method rather than replacing it or declaring it unusable. Research, assessment, ref, decision, and handoff distinctions should also be preserved.

## Limitations

- The binding norm in Obsidian was not read.
- No end-to-end agent session was executed as part of this assessment.
- No defect in a delivered application was demonstrated; identified delivery risks are labeled as inference.
- The earlier fourteen-selector suite result is prior evidence, not a new run during this assessment.
- Existing historical track `010` was used to observe the gate, not as proof that the current continuous-flow protocol behaves correctly.
- Proposed verification scenarios are recommendations, not tests already implemented or executed.
- The evaluator was the coordinating agent `openai-codex/gpt-6-astra`; no delegated evaluator participated.

## Recommendations

1. First, require demonstrated final acceptance and explicit revalidation after review corrections. This addresses premature completion while preserving the lightweight flow.
2. Next, add agent-driven behavioral scenarios for approval, revisions, failed validation, material planning changes, and resumption. Retain useful structural checks, but do not present them as proof of agent behavior.
3. Then, strengthen deterministic gate invariants and make blocking questions explicit in dependency groups.

Do not begin by adding more skills, approval stages, or extensive documentation. Strengthen the evidence produced by the existing flow first. These recommendations are inputs for later planning, not accepted decisions or authorization to implement.
