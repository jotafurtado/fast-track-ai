# Proposal

## Why

The fast-track-ai method today requires users to know three separate commands (`fast-track-ai-intent`, `fast-track-ai-spec`, `fast-track-ai-implement`), invoke them in the correct order, and navigate approval gates that report draft status as failure. Each phase transition is a full stop: the user must remember what to type next. Supporting artifacts (research, refs, ADRs, assessments) require manual invocation even when the model has enough context to produce them. The result is a ceremony-heavy flow that punishes users who think in continuous streams rather than discrete phases.

## What Changes

- **Intent skill becomes interactive and autonomous.** The model asks up to three clarifying questions using the host interactive pattern instead of dumping a vague intent. It autonomously invokes research, ref capture, ADR creation, and assessment when explicit triggers are met, informing (not asking) the user before each.
- **Post-phase summaries replace gates.** Each skill ends with a four-bullet summary of what was captured plus a concrete next-step prompt. The `.` shorthand means "understood, proceed" and chains the next skill automatically. Any other input is handled as a new instruction. No approval gate is reported as failure.
- **`tasks.md` gains parallelism annotations.** The spec skill annotates task groups and dependency edges so the implement skill can resolve parallelism from the artifact instead of guessing.
- **Implement skill reads parallelism metadata and selects efficient agents.** Subagent model selection defers to the harness; the skill instructs the harness to use an efficient execution-class agent for tasks and reserves the session model for planning.
- **Intent status stays `draft` until shipped.** The `.` continuation does not set `status: approved` on the intent. The spec skill already accepts `draft` intents. Only `spec.md` and `tasks.md` require `approved` status before implementation.
- **Non-implementation outcomes are first-class exits.** When the intent is a research question, assessment request, or exploration, the skill produces the appropriate artifact and offers a clean exit instead of forcing the intent-spec-implement pipeline.

## Capabilities

### New Capabilities

- `continuous-flow`: Defines the `.` continuation protocol, post-phase summary format, non-implementation exit paths, and the rules governing autonomous artifact generation during intent.

### Modified Capabilities

- `method-artifacts`: Tasks gain parallelism group annotations; the contract between spec and implement for dependency edges is a new behavioral requirement.

## Impact

- `skills/fast-track-ai-intent/SKILL.md` and its command: interactive questioning, autonomous artifact triggers, summary format, `.` continuation to spec.
- `skills/fast-track-ai-spec/SKILL.md` and its command: summary format, `.` continuation to implement, parallelism annotations in tasks.md.
- `skills/fast-track-ai-implement/SKILL.md` and its command: parallelism resolution from tasks.md metadata, agent efficiency instruction, `.` continuation for ship.
- `skills/fast-track-ai-spec/assets/tasks.md`: template gains parallel group convention.
- `skills/fast-track-ai-init/assets/AGENTS-snippet.md` and `AGENTS.md` managed block: document the `.` continuation protocol and autonomous artifact behavior.
- `commands/fast-track-ai-intent.md`, `commands/fast-track-ai-spec.md`, `commands/fast-track-ai-implement.md`: updated descriptions.
