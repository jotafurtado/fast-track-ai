# Data Model: Skill Standards Compliance

## Skill

A `skills/dot-ai-*` directory. Fields: `name` (matches directory), `description` (pushy: what + trigger contexts + user phrases), `body` (imperative steps, under 500 lines), `resources` (per-skill `scripts/`, `assets/`, optional `references/`).

Validation: frontmatter parses as YAML with `name` and `description` present; body references each bundled file with read guidance.

## Checklist Item

One skill-creator rule applied to one skill. Fields: `rule` (guide text), `verdict` (pass/fail), `evidence` (quote of skill text, required).

State transitions: open → pass, open → fail → fixed → pass. A fail without evidence quote is invalid.

## Eval Prompt

A realistic user utterance plus expectations. Fields: `prompt`, `expected_files` (tree under scratch repo), `expected_exit` (codes per command), `skill` under test.

Validation: running the prompt with the skill on an empty scratch repo reproduces expected files and codes.

## Owner Mapping

Rows of (`script`, `owner_skill`). Invariants: every script referenced by more than one skill has exactly one owner; no references to `skills/shared` remain outside historical notes.
