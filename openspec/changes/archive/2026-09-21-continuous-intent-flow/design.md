# Design

## Context

See proposal.md for motivation. The method currently has three independent skills (`intent`, `spec`, `implement`) invoked by three separate slash commands. Each skill writes artifacts and stops. Phase transitions are manual. Supporting artifacts (research, refs, ADRs, assessments) are only produced when the user explicitly invokes a dedicated command.

Current skill chain and status rules:
- Intent: writes `intent.md` with `status: draft`. No approval required before spec.
- Spec: reads `intent.md` (any status), writes `spec.md` and `tasks.md` with `status: draft`, asks for approval, then sets both to `approved`.
- Implement: requires `spec.md` and `tasks.md` with `status: approved`. Runs tasks, review, gate. Asks for ship, sets intent `status: shipped`.

The gate script runs at two points: after spec (structural smoke test) and after implement (pass/fail). Track 010 already identified that the spec-time gate message is confusing.

## Goals / Non-Goals

**Goals:**
- Reduce the number of conscious commands from three to zero after the initial request.
- Make the intent phase interactive so vague requests produce well-scoped intents.
- Automate supporting artifact generation when explicit triggers are met.
- Annotate parallelism in `tasks.md` so implement does not guess.
- Provide clean exit paths for non-implementation work.

**Non-Goals:**
- Creating a new orchestrator command or a fourth skill. The chaining lives in each skill's instructions.
- Changing the `intent.md`, `spec.md`, or `tasks.md` templates structurally (only `tasks.md` gains group headers).
- Changing the gate script behavior. Track 010 handles the message problem.
- Changing the ADR, ref, research, assessment, or handoff artifact formats.
- Hardcoding model names or provider-specific agent identifiers.

## Decisions

### D1: Chaining lives in skill instructions, not a new orchestrator

**Decision:** Each skill's SKILL.md instructions tell the model to present the summary and, on `.`, invoke the next skill. No new command, no new skill, no orchestrator script.

**Rationale:** The skills already run as model instructions. Adding an orchestrator creates a coordination layer that needs its own state machine, error handling, and harness compatibility. The model already has the context of which track it is working on. The simpler approach is to make each skill say "when the user replies `.`, call skill X for the same track."

**Alternatives considered:**
- Single `/fast-track-ai` orchestrator command: higher coupling, needs state persistence across skill boundaries, adds a new file to maintain.
- New `flow.sh` script: scripts cannot invoke model skills; the chain must happen at the model instruction level.

### D2: `.` means "understood, proceed" and never changes intent status

**Decision:** `.` and affirmative synonyms advance to the next skill. They do not set `status: approved` on `intent.md`. Intent stays `draft` until `shipped`.

**Rationale:** The existing norm says "Intent approval is not required before spec.md." Adding a hidden `approved` gate via `.` would create a new requirement that does not exist today. The spec skill already accepts draft intents. The only status gates that matter are `spec.md` and `tasks.md` `status: approved` (set by `.` after spec) and `intent.md` `status: shipped` (set by `.` after implement ship confirmation).

### D3: Autonomous artifact triggers are explicit and enumerated

**Decision:** The intent skill generates supporting artifacts only when one of four enumerated triggers fires. Before each, it informs the user in one sentence without asking permission.

**Triggers:**
1. Research: user mentions technology/API/pattern the model cannot confirm with confidence.
2. Ref: user supplies URL, document, or external snippet that materially grounds the intent.
3. ADR: answer to interactive question meets the existing qualification criteria.
4. Assessment: user asks to evaluate something existing, or intent depends on observable system condition.

**Rationale:** Without explicit triggers, the model will over-generate artifacts. "Use your judgment" produces inconsistent behavior across sessions and models. Enumerated triggers are testable.

**What is NOT a trigger:** The user mentioning a well-known technology (React, Laravel, Postgres) the model already knows. The model saying "I think we should research this" without user mention. A trivially reversible choice. These do not fire.

### D4: Parallelism annotations use Markdown group headers

**Decision:** `tasks.md` uses `## Group <name>` headers to group parallel tasks. Dependency between groups uses an inline annotation: `## Group B (depends: A)`. Tasks within a group are a flat checkbox list.

**Example:**
```markdown
## Group A
- [ ] Task 1: ... Files: ... Validate: ...
- [ ] Task 2: ... Files: ... Validate: ...

## Group B (depends: A)
- [ ] Task 3: ... Files: ... Validate: ...
```

**Rationale:** Markdown headers are parseable by both models and the gate script. YAML frontmatter for dependency edges would be harder to read and maintain. The `depends:` annotation is a parenthetical on the header, keeping the format flat and grep-friendly.

**Alternative considered:** YAML task metadata block. Rejected: adds structural complexity, requires parsing beyond what skills do today, and splits task information across two representations.

### D5: Post-phase summary format is fixed at four bullets

**Decision:** Each skill ends with exactly four short bullets, a list of generated artifacts (if any), the track location, and a next-step line.

**Intent bullets:** problem, outcome, scope, constraints.
**Spec bullets:** outcome, phases, task count, parallel groups.
**Implement bullets:** completed tasks, test results, review outcome, gate result.

**Rationale:** Fixed structure means the user knows where to look. Four bullets force brevity. The ADHD-friendly pattern works because it reduces the summary to scannable chunks, not because of a specific number, but four balances completeness and scanability.

### D6: Non-implementation exits use the standard summary without spec prompt

**Decision:** When the intent skill determines the work is purely investigative or evaluative, it produces the appropriate artifact (research, assessment) and presents the standard four-bullet summary. The next-step line says "Track concluida. Nenhuma implementacao necessaria." instead of ". para continuar com a spec."

**Classification heuristic:** If the user's request starts with "pesquise", "investigue", "avalie", "audite" or equivalent investigative/evaluative verbs, and does not describe a desired state change in the system, it is non-implementation. If ambiguous, the interactive questions resolve it.

## Risks / Trade-offs

**R1: Model compliance with `.` protocol.** The `.` continuation is a model instruction, not enforced by code. A model that ignores it or misinterprets it will break the chain. Mitigation: the instruction is simple and unambiguous; the summary format makes the expected input obvious.

**R2: Autonomous artifact over-generation.** Even with explicit triggers, models may be aggressive. Mitigation: the "known fact does not trigger research" rule is a negative trigger. The inform-before-action pattern gives the user a chance to redirect ("nao precisa pesquisar isso").

**R3: Parallelism annotation is new for the spec skill.** The spec skill must now analyze file overlap and data dependencies to group tasks. This is a harder cognitive task for the model than listing tasks sequentially. Mitigation: conservative grouping is safe; if unsure, put tasks in separate sequential groups.

**R4: `.` after implement means ship.** This is a consequential action (sets `status: shipped`). Unlike intent and spec where `.` is low-stakes, shipping is permanent. The implement summary should make this explicit: ". para ship (marca a track como concluida)".
