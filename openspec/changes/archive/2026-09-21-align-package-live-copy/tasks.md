# Tasks

## 1. Live copy without Spec Kit

- [x] 1.1 Remove Spec Kit / speckit / `.specify` sentences from `skills/fast-track-ai-spec/assets/spec.md`, `skills/fast-track-ai-init/SKILL.md`, and `commands/fast-track-ai-init.md`. Init skill and command describe the tree they create, not what they refuse. Verify: `rg -i 'spec.?kit|speckit|\.specify' skills/fast-track-ai-*/SKILL.md skills/fast-track-ai-*/assets commands` returns no matches.
- [x] 1.2 Drop Spec Kit / `.specify` from live evals table prose in `fast-track-ai/tracks/001-skill-standards/spec/evals.md` and from `spec/contracts/skill-package.md` if present. Keep the init eval script asserting those paths are absent. Verify: evals.md table does not name Spec Kit or `.specify`; `run-evals.sh init` still exits 0.

## 2. AGENTS and intent status

- [x] 2.1 Update `skills/fast-track-ai-init/assets/AGENTS-snippet.md` and the managed block in `AGENTS.md`: replace "Mandatory flow, no exceptions" with a lock that implementation needs approved spec and tasks, while research, assess, and handoff may stop after their artifact; replace "A track leaves `active`" with draft-until-shipped / dropped / superseded. Verify: both files match on those sentences; neither contains `no exceptions` or the phrase `leaves active`.
- [x] 2.2 Narrow the AGENTS house rule so English remains default for commands, skills, and error messages, with an explicit exception for the continuous-flow next-step and non-implementation-exit lines. Verify: `AGENTS.md` names that exception and still contains the Portuguese strings only as the allowed exception, not as a rewrite of the skill files.
- [x] 2.3 Remove "Intent `status: active` is not required" (and any instruction to write `active`) from live spec/implement skills and commands. They may stay `draft`. Verify: `rg 'status: active' skills commands` returns no matches.

## 3. Installer command links

- [x] 3.1 Add `--commands-dir` to `install.sh`, default `$HOME/.claude/commands`; when `--claude-dir` is set and `--commands-dir` is omitted, default to `dirname(claude-dir)/commands`. Link every `commands/fast-track-ai-*.md` with `ln -sfn`. Verify: `bash -n install.sh`; a custom-dir run creates seven resolving command links beside the custom Claude skills dir.
- [x] 3.2 Extend `assert_installed_layout` / `run_install` in `run-evals.sh` so default and custom installs each resolve seven command files. Verify: `bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh install` exits 0.

## 4. Flow eval and draft fixtures

- [x] 4.1 Add selector `flow` that asserts `. para continuar com a spec`, `. para implementar`, `. para ship`, `Track concluida. Nenhuma implementacao necessaria.`, `## Group`, and `(depends:` in the owner skills and tasks template. Wire it into `all`. Verify: `run-evals.sh flow` exits 0; evals.md lists the selector.
- [x] 4.2 Change gate/spec eval fixtures that only need a valid intent from `active` to `draft`. Leave at most one index fixture on `active` if needed to prove the enum. Verify: `rg 'write_intent .* "active"' run-evals.sh` is empty or only the index enum fixture; `run-evals.sh approval` and `spec` exit 0.

## 5. Ship 010 and full evals

- [x] 5.1 Set `fast-track-ai/tracks/010-approval-ask-not-gate-fail/intent.md` `status: shipped`. Do not edit that track's `spec.md` or `tasks.md`. Run `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh .`. Verify: INDEX row is `| 010-approval-ask-not-gate-fail | shipped |`; `cmp` of 010 spec and tasks against their pre-edit bytes succeeds.
- [x] 5.2 Run `bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all` and confirm the new `flow` selector is included. Verify: the command exits 0 and prints `PASS: all evals`.
