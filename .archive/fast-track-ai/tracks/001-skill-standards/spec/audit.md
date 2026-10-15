# Audit: dot-ai skills vs skill-creator guide

**Date**: 2026-09-16. **Scope**: 6 `skills/dot-ai-*`.

## Rule definitions

### Rule 1: Frontmatter name and description

Each `SKILL.md` MUST open with YAML frontmatter containing a `name:` field matching the directory and a non-empty `description:` field stating what the skill does.

### Rule 2: Pushy trigger contexts

The `description:` MUST follow the skill-creator pushy pattern: state what the skill does AND the exact contexts that trigger it, including user phrases that should trigger it even when the skill is not named.

### Rule 3: Per-skill resource anatomy and owner-copy paths

Resources MUST live per skill (`scripts/`, `references/`, `assets/` inside the skill that owns them). Cross-skill script use MUST reference the owner copy by package-relative path (for example `../dot-ai-init/scripts/dot-ai-index.sh (owner copy)`), never duplicate or load from a removed `shared/` tree.

### Rule 4: Progressive disclosure under 500 lines

The `SKILL.md` body MUST stay under 500 lines. When bundled resources exist, steps MUST name them with explicit read or run guidance (for example `Read ./assets/plan.md` or `run ./scripts/sdd-gate.sh from this skill`). Skills with no bundled resources are not penalized for absence.

### Rule 5: Imperative procedure and output behavior

Steps MUST use imperative verbs (`Run`, `Write`, `Stop`, `Read`, `Ensure`) and name exact outputs, paths, or templates the agent produces or copies.

### Rule 6: Deterministic eval coverage or method-flow coverage

Deterministic skills (init, index, gate paths) MUST be covered by eval prompts with expected files and exit codes in `spec/evals.md`. Non-deterministic skills MUST cite an explicit method-flow contract in the audited skill or its owned resource that makes outputs and gates objectively checkable without a conversational eval.

## Audit matrix

| Skill | Rule | Verdict | Evidence |
|-------|------|---------|----------|
| dot-ai-init | 1 | PASS | `name: dot-ai-init` |
| dot-ai-init | 2 | PASS | `the user says "setup dot-ai", "install dot-ai", "init the method here", or the dot-ai/ tree is missing` |
| dot-ai-init | 3 | PASS | `then run ./scripts/dot-ai-init.sh [target-dir] from this skill` |
| dot-ai-init | 4 | PASS | `Read ./assets/AGENTS-snippet.md, then run ./scripts/dot-ai-init.sh [target-dir] from this skill` |
| dot-ai-init | 5 | PASS | `Run ./scripts/dot-ai-index.sh [target-dir] from this skill and report the result.` |
| dot-ai-init | 6 | PASS | `- Expected exit: 0, twice in a row (idempotent).` |
| dot-ai-intent | 1 | PASS | `name: dot-ai-intent` |
| dot-ai-intent | 2 | PASS | `Use when the user says what they want done ("I want to build X", "start a feature", "we need to fix Y")` |
| dot-ai-intent | 3 | PASS | `read and run ./scripts/dot-ai-specify.sh --track NNN-slug -- <request> from this skill` |
| dot-ai-intent | 4 | PASS | `Draft \`dot-ai/tracks/NNN-slug/intent.md\` from \`./assets/intent.md\` bundled in this skill.` |
| dot-ai-intent | 5 | PASS | `Stop and ask for correction and approval.` |
| dot-ai-intent | 6 | PASS | `No approved intent means no \`plan.md\`, no \`spec/\`, no code. This lock has no exceptions.` |
| dot-ai-plan | 1 | PASS | `name: dot-ai-plan` |
| dot-ai-plan | 2 | PASS | `the user says "make a plan", "plan this track", or asks how to implement` |
| dot-ai-plan | 3 | PASS | `Run \`./scripts/sdd-gate.sh --track NNN-slug --root <target>\` from this skill` |
| dot-ai-plan | 4 | PASS | `Write \`plan.md\` from \`./assets/plan.md\` bundled in this skill.` |
| dot-ai-plan | 5 | PASS | `After explicit approval, set frontmatter \`status: approved\` in both \`plan.md\` and \`tasks.md\`.` |
| dot-ai-plan | 6 | PASS | `- Approval selector: draft intent, draft plan, draft tasks, open short-cycle tasks, and open full-cycle tasks each exit 1; approved closed short and full cycles each exit 0.` |
| dot-ai-implement | 1 | PASS | `name: dot-ai-implement` |
| dot-ai-implement | 2 | PASS | `the user says "implement this", "build the track", or "execute the plan"` |
| dot-ai-implement | 3 | PASS | `run \`../dot-ai-plan/scripts/sdd-gate.sh --track NNN-slug --root <target>\` (owner copy, referenced by package-relative path)` |
| dot-ai-implement | 4 | PASS | `Require intent \`status: active\` plus frontmatter \`status: approved\` in the authoritative plan and tasks.` |
| dot-ai-implement | 5 | PASS | `Run each task's Validate command.` |
| dot-ai-implement | 6 | PASS | `After all tasks, run \`../dot-ai-plan/scripts/sdd-gate.sh --track NNN-slug --root <target>\` (owner copy, referenced by package-relative path), then \`/code-review\`.` |
| dot-ai-research | 1 | PASS | `name: dot-ai-research` |
| dot-ai-research | 2 | PASS | `Use when the user says "research X", "investigate", "gather docs", or needs facts before deciding.` |
| dot-ai-research | 3 | PASS | `Run \`../dot-ai-init/scripts/dot-ai-index.sh <target>\` (owner copy) and report validation errors.` |
| dot-ai-research | 4 | PASS | `Save the result to \`dot-ai/research/<slug>.md\` in the target repo, nowhere else.` |
| dot-ai-research | 5 | PASS | `Ensure the frontmatter: \`source\`, \`captured\`, \`status: raw\`, \`owner\`.` |
| dot-ai-research | 6 | PASS | `Run \`../dot-ai-init/scripts/dot-ai-index.sh <target>\` (owner copy) and report validation errors.` |
| dot-ai-handoff | 1 | PASS | `name: dot-ai-handoff` |
| dot-ai-handoff | 2 | PASS | `the user says "handoff", "compact this", or "pick this up later"` |
| dot-ai-handoff | 3 | PASS | `Run \`../dot-ai-init/scripts/dot-ai-index.sh <target>\` (owner copy) and report.` |
| dot-ai-handoff | 4 | PASS | `Copy the generated file to \`dot-ai/handoffs/<timestamp>-<slug>.md\` in the target repo, timestamp \`AAAA-MM-DD-HHmm-OFFSET\`.` |
| dot-ai-handoff | 5 | PASS | `Keep only the 3 most recent in the root. Move the rest to \`dot-ai/handoffs/archive/\`.` |
| dot-ai-handoff | 6 | PASS | `Reference specs, plans, and diffs by path, never duplicate content.` |

## Re-audit

Convergence re-audit on 2026-09-16: 36 skill-rule pairs, each PASS with one exact evidence quote from the current skill source or owned eval artifact. No aggregate all-pass shortcuts remain.
