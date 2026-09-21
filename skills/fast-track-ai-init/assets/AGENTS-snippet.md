<!-- BEGIN MANAGED BLOCK: fast-track-ai. Installed by fast-track-ai-init, idempotent block. -->

## fast-track-ai

Active memory lives in `fast-track-ai/`. Always read `fast-track-ai/INDEX.md` first; never scan the whole tree for discovery. The generated index lists tracks, refs, research, assessments, decisions, and active handoffs.

Mandatory flow, no exceptions: a new request becomes `intent.md` first. The `fast-track-ai-intent` skill drafts `intent.md` only. The `fast-track-ai-spec` skill drafts `spec.md` and `tasks.md`. Intent approval is not required before those files. No `spec.md` and `tasks.md` with `status: approved` means no implementation. Intents live in `fast-track-ai/tracks/NNN-slug/intent.md`.

Continuous flow: each skill ends with a four-bullet summary plus a next-step line. `.` (or an affirmative synonym such as "sim", "pode continuar", "yes", "continue") means "understood, proceed" and chains the next skill for the same track without typing a command; any other input is a new instruction to the current skill. `.` never changes intent `status`; intent stays `draft` until the implement ship sets `shipped`.

Intent autonomy: the intent skill asks up to three focused interactive questions when the request is vague, and autonomously generates supporting artifacts when explicit triggers fire (research for unknown tech, ref for user-supplied URL, ADR for a qualifying answer, assessment for an evaluation request), informing in one sentence before each without asking permission. Purely investigative or evaluative requests exit cleanly with their artifact and no spec prompt.

Tasks parallelism: `tasks.md` organizes tasks under `## Group <name>` headers with `(depends: <group>)` on dependent group headers. Tasks in one group run concurrently; groups run in dependency order. The implement skill resolves these annotations and requests an execution-class agent from the harness for task subagents.

Supporting artifact contracts:

- A ref preserves an immutable source input at `fast-track-ai/refs/<slug>.md`. It is `inline` or `pointer`, records content identity and license, and is cited on an intent in `refs:`. Changed source bytes require a new ref.
- Research investigates external facts at `fast-track-ai/research/<slug>.md`. It is status-free, multi-source, and cited on an intent in `research:`.
- An assessment evaluates the project, implementation, feature, or idea at `fast-track-ai/assessments/<YYYY-MM-DD>-<slug>.md`. It is status-free, records evaluator plus evidence and counterevidence, and is cited on an intent in `assessments:`, never `research:`.
- A decision preserves a qualifying accepted durable choice at `fast-track-ai/decisions/<NNN-slug>.md`. It uses only `accepted` or `superseded` and is cited on an intent in `decisions:`.
- A handoff transfers active working context at `fast-track-ai/handoffs/<timestamp>-<slug>.md`. Keep the three newest active files and move older files to `handoffs/archive/`; archived handoffs are not active index entries.

Explicit actions: use `fast-track-ai-research` for external investigation, `fast-track-ai-assess` for inward evaluation, and `fast-track-ai-handoff` for context transfer. Each action writes directly from its package-owned template without a third-party runtime skill.

Automatic captures: intent captures a material user-supplied basis as a ref; intent, spec, and implementation capture qualifying accepted decisions as ADRs. Do not add separate ref or ADR commands.

- Track root holds only `intent.md`, `spec.md`, `tasks.md`, `decisions.md`, plus `assets/`. Live tracks must not keep `plan.md`. A leftover `spec/` directory is historical and does not select a cycle. Loose files are forbidden. Auxiliary outputs go under `assets/`.
- A track leaves `active` only by explicit maintainer command. `dropped` abandons the work; implementation is not required. `superseded` requires `superseded_by`. Do not invent `superseded_by`. Implement owns `shipped` and asks before writing it.
- Each script and template has one owner skill. Cross-skill consumers reference the owner copy via package-relative sibling paths. No `shared` link.

<!-- END MANAGED BLOCK: fast-track-ai -->
