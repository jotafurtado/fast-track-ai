# Research: Skill Standards Compliance

## Owner assignment for shared scripts

- Decision: `dot-ai-index.sh` → `dot-ai-init`; `sdd-gate.sh` → `dot-ai-plan`; `dot-ai-specify.sh` → `dot-ai-intent`.
- Rationale: each script is owned by the skill that introduces it in the flow. Index first runs at install; gate validates plan structure; specify bridges an approved intent into the full cycle. Other skills reference the owner copy by package-relative path.
- Alternatives considered: duplicating scripts per skill (rejected: drift across copies, 4-way divergence risk); keeping `shared/` as a declared exception (rejected by user decision Q2 in clarify).

## Pushy descriptions vs house terse style

- Decision: descriptions follow the skill-creator pushy pattern (what + trigger contexts + user phrases); bodies stay terse.
- Rationale: descriptions are the triggering mechanism and agents undertrigger; bodies are read post-trigger where terseness saves context.
- Alternatives considered: terse everywhere (rejected: preserves the undertriggering that broke the intent lock once already).

## Eval format

- Decision: lightweight eval prompts per deterministic skill, each with expected files and exit codes on a scratch repo. No full skill-creator harness (subagents, viewer, timing) in this pass.
- Rationale: our outputs are files and exit codes, cheap to assert with a shell script; the full harness is disproportionate for 3 scripts.
- Alternatives considered: full eval-viewer harness (rejected: Python dependency, viewer server, overkill for deterministic outputs); no evals (rejected: regressions already bit once).

## Template placement

- Decision: templates move to per-skill `assets/` (intent → intent skill; plan, tasks, decisions → plan skill; AGENTS-snippet → init skill).
- Rationale: skill-creator anatomy names `assets/` for files used in output; templates are exactly that.
- Alternatives considered: `references/` (rejected: references are docs loaded into context, templates are copied, not read).
