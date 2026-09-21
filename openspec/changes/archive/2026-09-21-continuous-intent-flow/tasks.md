# Tasks

## 1. Intent Skill: Interactive Questions and Autonomous Artifacts

- [x] 1.1 Rewrite `skills/fast-track-ai-intent/SKILL.md` step 3 to use the host interactive ask pattern with up to three focused questions, each explaining why it matters. Clear requests skip questions.
- [x] 1.2 Add autonomous artifact triggers to `skills/fast-track-ai-intent/SKILL.md`: research (unknown tech/API), ref (user-supplied URL/doc), ADR (qualifying answer), assessment (evaluation request or system-condition dependency). Each trigger informs in one sentence before invoking.
- [x] 1.3 Add non-implementation exit path to `skills/fast-track-ai-intent/SKILL.md`: when request is purely investigative or evaluative, produce the artifact and present summary without suggesting spec/implement.
- [x] 1.4 Add post-phase summary step to `skills/fast-track-ai-intent/SKILL.md`: four bullets (problem, outcome, scope, constraints), generated artifacts list, track location, ". para continuar com a spec" next-step line.
- [x] 1.5 Add `.` continuation step to `skills/fast-track-ai-intent/SKILL.md`: on `.` or affirmative synonym, invoke spec skill for same track. Other input is processed as instruction before proceeding.
- [x] 1.6 Update `commands/fast-track-ai-intent.md` description to reflect interactive questions, autonomous artifacts, and `.` continuation.

## 2. Spec Skill: Summary, Continuation, and Parallelism in Tasks

- [x] 2.1 Update `skills/fast-track-ai-spec/assets/tasks.md` template to include `## Group <name>` headers with `(depends: <group>)` annotation convention.
- [x] 2.2 Add parallelism grouping instruction to `skills/fast-track-ai-spec/SKILL.md` step 3: organize tasks into named parallel groups based on file disjointness and data independence. Conservative: sequential groups when unsure.
- [x] 2.3 Add post-phase summary step to `skills/fast-track-ai-spec/SKILL.md`: four bullets (outcome, phases, task count, parallel groups), ". para implementar" next-step line. Replace the current approval gate ask with this summary (`.` sets both `spec.md` and `tasks.md` to `status: approved`).
- [x] 2.4 Add `.` continuation step to `skills/fast-track-ai-spec/SKILL.md`: on `.` or affirmative synonym, set `status: approved` on both files and invoke implement skill for same track. Other input is processed as instruction.
- [x] 2.5 Update `commands/fast-track-ai-spec.md` description to reflect summary format and `.` continuation.

## 3. Implement Skill: Parallelism Resolution, Agent Efficiency, and Ship Continuation

- [x] 3.1 Add parallelism resolution step to `skills/fast-track-ai-implement/SKILL.md`: read `## Group` headers and `(depends:)` annotations from `tasks.md`. Launch groups in dependency order, parallelize tasks within each group.
- [x] 3.2 Add agent efficiency instruction to `skills/fast-track-ai-implement/SKILL.md` step 4: request execution-class agent from harness for task subagents, reserve session model for planning/integration/review. No hardcoded model names.
- [x] 3.3 Update post-implementation summary in `skills/fast-track-ai-implement/SKILL.md`: four bullets (completed tasks, test results, review outcome, gate result), ". para ship (marca a track como concluida)" next-step line.
- [x] 3.4 Add `.` continuation for ship in `skills/fast-track-ai-implement/SKILL.md`: on `.` or affirmative synonym after the summary, set `intent.md` `status: shipped`, regenerate index, and stop.
- [x] 3.5 Update `commands/fast-track-ai-implement.md` description to reflect parallelism, agent efficiency, and `.` ship continuation.

## 4. Documentation: AGENTS Snippet and Managed Block

- [x] 4.1 Update `skills/fast-track-ai-init/assets/AGENTS-snippet.md` to document: `.` continuation protocol, autonomous artifact generation during intent, post-phase summary format, parallelism groups in tasks, and non-implementation exit paths.
- [x] 4.2 Update the `AGENTS.md` managed block in place to match the updated snippet content.

## 5. Validation

- [x] 5.1 Run `fast-track-ai-gate.sh` against a test track in `/tmp` to confirm the gate script still parses `tasks.md` with group headers.
- [x] 5.2 Verify all three SKILL.md files are internally consistent: same `.` protocol, same summary format, same continuation vocabulary.
- [x] 5.3 Run `fast-track-ai-index.sh` against a test tree in `/tmp` to confirm index generation is unaffected.
