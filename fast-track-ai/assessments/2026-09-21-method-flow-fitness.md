---
captured: 2026-09-21
owner: maintainer
scope: full method-package flow fitness and improvement points for this repository
evaluator: cursor/grok-4.6
tracks: []
---

# Assessment: Method flow fitness

## Conclusion
The live method cycle is complete and usable. The 2026-09-15 blockers (missing complete cycle, undurable approval, no assessment workflow, non-portable install, non-executable evals) are closed. Remaining gaps are consistency, not missing machinery: track `010` is implemented but unshipped; the 2026-09-21 continuous-flow change lives in OpenSpec rather than a numbered track; evals do not cover the `.` protocol; leftover `001` `plan.md` still fails the live gate; user-facing continuation copy is Portuguese against an English rule; and intent `status: active` is documented but never written.

## Scope and basis
Evaluated the repository-owned method package on 2026-09-21: seven skills under `skills/fast-track-ai-*`, matching files in `commands/`, `install.sh`, init/index/gate scripts, `AGENTS.md` plus the init-owned snippet, `fast-track-ai/INDEX.md`, tracks `001`–`010`, supporting artifacts, archived OpenSpec changes, and the executable eval runner.

Observed commands: `bash -n` on published scripts; `fast-track-ai-gate.sh` against `001-skill-standards` and `010-approval-ask-not-gate-fail`; `run-evals.sh all` from the repository root.

Excluded: implementing recommendations; creating an intent; rewriting method files other than this assessment and the regenerated index; the Obsidian binding norm named in `AGENTS.md`; a live host session that actually types `.` through intent → spec → implement.

## Criteria
- The live cycle (intent → spec → implement → ship, plus research/assess/handoff) is internally consistent across skills, commands, AGENTS, gate, and index.
- Track lifecycle in INDEX is reconstructable from artifacts without conversational memory.
- Executable evals cover the live behavioral contract, including continuous flow, not only structural scripts.
- Historical artifacts do not contradict the live contract in ways that would mislead an agent reading INDEX first.
- Installation covers the declared package map.
- User-facing language matches the declared English rule.
- Method changes are recorded in this method's own track cycle, or dual-method use is explicit.

## Findings

### How the live flow works

1. Discovery starts at `fast-track-ai/INDEX.md`. The managed AGENTS block forbids scanning the tree for discovery.
2. `fast-track-ai-init` creates the `fast-track-ai/` tree and one managed AGENTS block. It vendors nothing and does not create `specs/` or `.specify/`.
3. A change request is drafted as `fast-track-ai/tracks/NNN-slug/intent.md` by `fast-track-ai-intent`. Intent may stay `draft`. Up to three interactive questions are allowed. Explicit triggers may autonomously capture research, a ref, an ADR, or an assessment. Pure investigation or evaluation exits without a spec prompt.
4. `.` (or an affirmative synonym) chains `fast-track-ai-spec`, which writes unified `spec.md` (Outcome plus Phases) and `tasks.md` with `## Group` headers and `(depends:)`. The gate may run as an internal smoke test; draft status is not user-facing failure. `.` then sets both files to `status: approved` and chains implement. There is no live `plan.md`.
5. `fast-track-ai-implement` requires approved spec and tasks, not intent `active`. It resolves groups, launches task subagents, validates, runs the owner-copy gate, reviews against `fast-track-ai/refs/code-review-skill`, and stops. `.` then sets intent `status: shipped` and regenerates INDEX. Checkboxes never ship by themselves.
6. Explicit supporting actions are `fast-track-ai-research`, `fast-track-ai-assess`, and `fast-track-ai-handoff`. Refs and ADRs are captured inside intent/spec/implement. Each writes from a package-owned template.
7. The structural gate PASSes only with `intent.md`, approved `spec.md` and `tasks.md`, closed tasks, no leftover `plan.md`, and no loose files at the track root. Observed: `PASS: 010-approval-ask-not-gate-fail cycle intact`. Observed: `FAIL: 001-skill-standards has plan.md; live tracks must not keep plan.md`.
8. Index validates type-specific invariants and lists tracks, refs, research, assessments, decisions, and active handoffs.

### Verified strengths

- Thirteen eval selectors all passed on 2026-09-21: `self`, `init`, `index`, `approval`, `install`, `audit`, `resources`, `workflows`, `refs`, `decisions`, `handoff`, `spec`, `contract`. Command: `bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all`.
- Seven skills and seven command wrappers exist and match: assess, handoff, implement, init, intent, research, spec.
- All published shell scripts passed `bash -n`.
- The 2026-09-15 assessment's dedicated-assessment gap is closed: `skills/fast-track-ai-assess/SKILL.md` and ADR `007-dedicated-assessment-skill` (`accepted`).
- Durable approval exists as frontmatter `status: approved` on `spec.md` and `tasks.md`. Implement refuses work without it.
- Continuous-flow instructions are present in the three cycle skills, their command wrappers, and `skills/fast-track-ai-init/assets/AGENTS-snippet.md`.
- INDEX already records terminal states for `001`–`009` (`shipped` or `dropped`).

### High-priority gaps

### Track 010 is implemented and unshipped

`fast-track-ai/tracks/010-approval-ask-not-gate-fail/intent.md` is `status: draft`. `spec.md` and `tasks.md` are `status: approved`. All three tasks are checked. The default gate PASSed. INDEX therefore lists the only non-terminal track as `draft`, which under-reports completed work.

The same track is also conceptually overtaken. Its spec still says the user-facing copy is an approval ask and "The skill does not auto-approve." The live spec skill, after the archived OpenSpec change `openspec/changes/archive/2026-09-21-continuous-intent-flow/`, treats `.` as approval plus chain to implement. `010` tasks have no `## Group` headers. Its intent still names `fast-track-ai-plan`, leftover `plan.md` FAIL copy, and a six-skill package.

### Dual authority: OpenSpec overlay vs numbered tracks

The 2026-09-21 continuous-flow work is archived under OpenSpec (`openspec/changes/archive/2026-09-21-continuous-intent-flow/` plus `openspec/specs/continuous-flow/spec.md`) and is not a `fast-track-ai/tracks/NNN-*` entry. INDEX-first discovery does not show it. `openspec/changes/` has no active change; archive also contains `2026-09-21-standardize-method-artifacts`. The method's own "new request becomes intent.md first" rule was not used for the largest recent behavior change.

### Continuous flow has no executable eval

`fast-track-ai/tracks/001-skill-standards/spec/evals.md` (dated 2026-09-20) and `run-evals.sh` cover init, index, gate, install, workflows, refs, decisions, handoff, spec cycle, and the seven-skill contract. They do not assert `.` continuation, four-bullet summaries, `## Group` parsing, non-implementation exits, or the Portuguese next-step lines. Continuous-flow research (`fast-track-ai/research/continuous-intent-flow-analysis.md`) already recorded that the protocol is instruction-based, not code-enforced.

### Intent `active` is documented but unused

Index still accepts `draft|active|shipped|dropped|superseded`. The managed AGENTS block says "A track leaves `active` only by explicit maintainer command." Continuous-flow spec says intent stays `draft` until ship. No current skill step writes `status: active`. Eval fixtures in `run-evals.sh` still construct intents with `status: "active"`. Agents cannot tell whether `active` is required, optional, or leftover.

### Medium-priority gaps

### Frozen `001` contradicts the live gate

`fast-track-ai/tracks/001-skill-standards/spec.md` still says remaining authority is root `plan.md` and `tasks.md`. Root `plan.md` exists. ADR `006-no-live-plan-md` forbids live `plan.md`. The live gate fails that shipped track. ADR `003-live-evals-vs-frozen-spec` froze `001` prose, so the contradiction is known and unresolved.

### User-facing language is split

`AGENTS.md` Rules: "User-facing prose in English: commands, skills, error messages." Track `010` repeats that constraint. Live next-step lines are Portuguese: `. para continuar com a spec`, `. para implementar`, `. para ship (marca a track como concluida)`, plus "Track concluida. Nenhuma implementacao necessaria." The OpenSpec continuous-flow spec hard-codes those Portuguese strings as required copy.

### `install.sh` still does not install `commands/`

`install.sh` links `skills/fast-track-ai-*` into agents and Claude skill dirs. It does not copy or link `commands/`. AGENTS.md Map lists those seven command files as part of the package. The 2026-09-15 assessment already recorded this; the eval `install` selector only checks skill links.

### Stale discovery documents

`fast-track-ai/research/artifact-standards.md` (captured 2026-09-20) still describes an init-owned assessment template and a handoff skill that invokes a base `handoff` skill. Those statements are false against current `skills/fast-track-ai-assess/` and `skills/fast-track-ai-handoff/SKILL.md`. Research is status-free, so INDEX lists it as current evidence.

### AGENTS "no exceptions" fights explicit assess/research exits

The managed block: "Mandatory flow, no exceptions: a new request becomes `intent.md` first." Assess, research, and handoff skills all stop after their artifact and index regeneration, and this assessment followed that assess rule. The "no exceptions" sentence is stronger than the non-implementation exit already written into intent and the three explicit actions.

## Evidence against conclusion
The package is further along than a "not ready" reading. `run-evals.sh all` exited 0 with thirteen PASSes on this date. The seven-skill install eval covers custom agents/Claude links. Gate, index, and approval contracts match the unified-spec / no-`plan.md` design on scratch fixtures. Track `010` itself PASSes the implement-time gate. Continuous-flow OpenSpec work is archived, not an open competing change. These facts support "usable now" and limit the conclusion to consistency and dogfooding, not missing cycle pieces.

## Limitations
- The Obsidian binding norm `10 - Projetos/Code/dot-ai/dot-ai - Fundamentos v1.2.md` was not read.
- No live `.` continuation was executed in a host ask session; continuous-flow findings are from skill text, OpenSpec specs, and the absence of eval coverage.
- Shipped tracks `002`–`009` were not re-audited for `## Group` headers; they predate that annotation and are not live work.
- Evaluator identity is the coordinating agent `cursor/grok-4.6`. No delegated evaluator was used.
- `install.sh` custom-dir behavior was accepted via the eval selector, not re-run as a separate manual fixture in this pass.

## Recommendations
1. P0: Close `010`. Either set intent `status: shipped` after an explicit ship ask, or `superseded` with a named `superseded_by` if continuous flow absorbed the approval-copy outcome.
2. P0: Record the 2026-09-21 continuous-flow behavior in a numbered track (or an accepted ADR that states OpenSpec is an overlay for method-package work). INDEX-first discovery should show it.
3. P1: Add eval selectors for `.` continuation copy, `## Group` / `(depends:)` presence in the tasks template, and the non-implementation exit line.
4. P1: Pick one user-facing language for continuation lines. Either change the AGENTS English rule or replace the Portuguese strings.
5. P1: Decide intent `active`: remove it from the index enum, or name the skill step that writes it.
6. P2: Relabel `001` root `spec.md` so `plan.md` is a historical leftover, not remaining authority. Keep frozen `spec/` prose; stop telling agents to treat root `plan.md` as live.
7. P2: Install `commands/` or document that slash-command files are copied by a harness-specific step outside `install.sh`.
8. P2: Soften the managed-block "no exceptions" sentence so assess, research, and handoff remain first-class exits without an intent.
9. P2: Leave `artifact-standards` as historical research; add a short current snapshot only if INDEX-first readers keep treating it as live description.
