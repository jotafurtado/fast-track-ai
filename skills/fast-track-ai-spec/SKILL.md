---
name: fast-track-ai-spec
description: Draft unified spec.md (Outcome plus Phases) and tasks.md with parallelism groups for a track that has intent.md. Chains to implement on user continuation. Intent status may be draft.
---

1. Read `fast-track-ai/tracks/NNN-slug/intent.md` in the target repo. Intent `status: active` is not required. Copy unanswered items under `Open questions` into `spec.md` Phases and `tasks.md` as work to resolve. Do not invent answers.
2. Write `fast-track-ai/tracks/NNN-slug/spec.md` from `./assets/spec.md` bundled in this skill. Outcome plus numbered Phases with observable Done, explicit Files, one-line Accept per phase, Out of scope repeated from the intent without widening. Do not write `plan.md`. Auxiliary outputs go under `assets/`, never loose at the track root. A leftover `spec/` directory does not select a cycle and is not a substitute for `spec.md`.
3. Write `tasks.md` from `./assets/tasks.md` bundled in this skill: organize tasks into named parallel groups using `## Group <name>` headers, with `(depends: <group>)` on the header when a group depends on another. Tasks within one group touch disjoint files and have no data dependency, so they may run concurrently. When unsure about independence, use separate sequential groups. Each task has Files and Validate. Include a task for each leftover open question copied from the intent. When the user makes a qualifying decision (durable, costly to reverse, surprising without context, or a meaningful trade-off), file `fast-track-ai/decisions/<NNN-slug>.md` from `./assets/decisions.md` without a separate request and cite supporting refs, research, assessments, source URLs, or repository paths when available. Status is `accepted | superseded` only. Do not create an ADR for local, easily reversible, or obvious choices. File outputs point under `assets/`.
4. Run `./scripts/fast-track-ai-gate.sh --track NNN-slug --root <target>` from this skill as an internal smoke test. Do not present a draft-status gate miss or an open-task count as user-facing failure. Report leftover `plan.md`, loose files, missing Files/Accept/Validate, and any other non-draft breakage.
5. Present a post-phase summary. Format:
   - Four short bullets: outcome, phases, task count, parallel groups.
   - Track location: `fast-track-ai/tracks/NNN-slug/`.
   - Next-step line: `. para implementar`.
   Do not report draft status as failure. Do not present an approval gate.
6. Wait for user input. If the user replies `.` or an affirmative synonym ("sim", "pode continuar", "yes", "continue"), set frontmatter `status: approved` in both `spec.md` and `tasks.md`, then invoke the `fast-track-ai-implement` skill for the same track. Do not auto-approve. Any other input is processed as an instruction to revise the spec or tasks before proceeding; after revision, present the summary again.
