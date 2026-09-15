# Audit: dot-ai skills vs skill-creator guide

**Date**: 2026-09-15. **Scope**: 6 `skills/dot-ai-*` + `skills/shared/`.

## Rule 1: Frontmatter has name + description

- PASS all 6. Evidence: each SKILL.md opens with `name: dot-ai-*` and a `description:` line.

## Rule 2: Description states what + trigger contexts (pushy)

- PASS all 6 (post-fix T005–T010). Evidence dot-ai-intent: description now names user phrases ("I want to build X", "start a feature", "we need to fix Y") plus the lock restated. Same pushy shape in init, plan, implement, research, handoff.

## Rule 3: Per-skill anatomy (scripts/, references/, assets/)

- PASS (post-fix T012–T017). Evidence: index/gate/specify owned by init/plan/intent, templates in per-skill `assets/`, `shared/` removed. References use owner-copy package-relative paths.

## Rule 4: Progressive disclosure (body < 500 lines, clear file refs)

- PASS all 6. Evidence: largest body is implement at ~7 steps; every bundled file referenced with read guidance (e.g., plan step 3 names `./assets/plan.md` inside the skill).

## Rule 5: Imperative writing with output formats

- PASS. Evidence: steps use "Run", "Write", "Stop and ask"; templates define exact output skeletons.

## Rule 6: Evals for deterministic outputs

- PASS (post-fix T019–T020). Evidence: `evals.md` holds 3 prompts with expected files and exit codes; all observed PASS on scratch repo.

## Re-audit

- T011 done: all-pass. Rules 1, 2, 4, 5 pass; rules 3 and 6 fixed by migration and evals below.
