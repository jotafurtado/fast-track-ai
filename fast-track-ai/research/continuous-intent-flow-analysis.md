---
captured: 2026-09-21
owner: jotafurtado
---

# Research: Continuous Intent Flow Design Analysis

## Question
What changes are needed to transform the current three-command fast-track-ai flow (intent, spec, implement) into a continuous interactive flow with autonomous artifact generation, and what are the risks and design constraints?

## Conclusion
The current flow has four structural problems: excessive ceremony between phases, manual artifact invocation, no post-phase summary, and gate messages that confuse draft status with failure. A continuous flow using `.` as continuation shorthand, interactive questioning during intent, autonomous artifact triggers, and parallelism annotations in tasks addresses all four. Six design decisions emerged from analysis and are captured in the OpenSpec change `continuous-intent-flow`.

## Findings

### Current state analysis (source: codebase inspection)

- Three skills (`intent`, `spec`, `implement`) are fully independent. Each has its own SKILL.md, command file, and assets. No skill references the next in the chain. Transitions are manual.
- The intent skill (SKILL.md step 3) already supports up to three questions via "host interactive ask pattern", but does not present a summary or suggest next steps.
- The spec skill (SKILL.md step 5) asks for approval and runs a gate that reports draft status as failure. Track 010 (`approval-ask-not-gate-fail`) was created specifically to fix this message problem.
- The implement skill (SKILL.md step 4) already says "Use subagents when possible. Independent tasks go to parallel subagents." But tasks.md has no parallelism metadata. The model guesses from file overlap.
- Supporting artifacts (research, refs, ADRs, assessments) are only produced when the user explicitly invokes dedicated commands (`fast-track-ai-research`, `fast-track-ai-assess`). The intent skill captures refs and ADRs automatically during drafting (steps 4-5), but does not invoke research or assessment.

### Problems identified

1. **Ceremony between phases.** User must know three command names and invoke them in order. Each transition is a full stop.
2. **Manual artifact invocation.** Research and assessment require separate commands even when the model has sufficient context to determine they are needed.
3. **No post-phase summary.** Skills dump artifacts without summarizing what was captured or suggesting next steps.
4. **Gate message confusion.** Track 010 identified that the spec-time gate reports `FAIL: plan.md status must be approved, got draft` as if something broke, when draft is the expected state.

### Design constraints discovered

- **Intent approval not required.** The norm explicitly says "Intent approval is not required before spec.md." Any `.` continuation must not introduce a hidden approval gate on intent. (Source: AGENTS.md managed block, line 41)
- **ADR qualification criteria exist.** The existing filter (durable, costly to reverse, surprising without context, meaningful trade-off) is well-defined and should not be weakened. (Source: SKILL.md step 5, method-artifacts spec requirement)
- **No plan.md.** ADR 006-no-live-plan-md killed the separate plan artifact. Parallelism metadata must live in tasks.md, not a new file. (Source: decisions/006-no-live-plan-md)
- **Harness-agnostic agents.** Model names and provider identifiers must not be hardcoded. The skill instructs the harness to select an efficient agent; the harness decides which one. (Source: cross-harness compatibility requirement)
- **Skills are self-contained.** Each skill owns its resources. Cross-skill consumers reference by package-relative path. No shared state file between skills. (Source: AGENTS.md rules)

### Recommendations

1. **`.` means "understood, proceed", not "approve".** Intent stays `draft`. Only spec/tasks get `approved` (on `.` after spec). Only implement sets `shipped` (on `.` after ship confirmation).
2. **Autonomous artifact triggers must be explicit and enumerated.** Four triggers: research (unknown tech), ref (user URL), ADR (qualifying answer), assessment (evaluation request). Negative trigger: known technology does not fire research.
3. **Parallelism annotations use Markdown group headers.** `## Group <name>` with `(depends: <group>)` parenthetical. Parseable, readable, no new format.
4. **Chaining lives in skill instructions, not a new orchestrator.** Each SKILL.md tells the model what to do on `.`. No new command or script.
5. **Post-phase summary is four fixed bullets.** Consistent structure across skills. ADHD-friendly: scannable, brief, always in the same place.
6. **Non-implementation exits are first-class.** Research-only and assessment-only requests produce their artifact and stop without suggesting spec/implement.

### Risks

1. Model compliance with `.` protocol is instruction-based, not code-enforced. Simple/unambiguous instruction mitigates.
2. Autonomous artifact generation may over-fire. Negative triggers ("known fact does not trigger research") and inform-before-action pattern mitigate.
3. Parallelism grouping is harder than sequential listing. Conservative grouping (sequential when unsure) is the safe default.
4. `.` after implement means ship, which is permanent. The summary must make this explicit with a parenthetical warning.

## Conflicts
None found. Track 010 (`approval-ask-not-gate-fail`) is complementary, not conflicting. It fixes the gate message; this change replaces the gate pattern entirely with summaries.

## Limitations
- Analysis is based on codebase inspection only. No user testing of the `.` continuation protocol has been performed.
- The "ADHD-friendly four-bullet" pattern is referenced from the `/skill:i-have-adhd` skill, which was not available for direct inspection. The design is based on the user's description of its behavior.
- Parallelism grouping effectiveness depends on model capability to analyze file overlap. No empirical data on how well current models perform this task.

## Sources
- `skills/fast-track-ai-intent/SKILL.md`, inspected 2026-09-21. Primary; current version.
- `skills/fast-track-ai-spec/SKILL.md`, inspected 2026-09-21. Primary; current version.
- `skills/fast-track-ai-implement/SKILL.md`, inspected 2026-09-21. Primary; current version.
- `AGENTS.md` managed block, inspected 2026-09-21. Primary; normative rules.
- `openspec/specs/method-artifacts/spec.md`, inspected 2026-09-21. Primary; existing behavioral spec.
- `fast-track-ai/tracks/010-approval-ask-not-gate-fail/intent.md`, inspected 2026-09-21. Primary; related track.
- `fast-track-ai/INDEX.md`, inspected 2026-09-21. Primary; current track inventory.
- User description of `/skill:i-have-adhd` behavior pattern, 2026-09-21 conversation. Secondary; not directly verified.
