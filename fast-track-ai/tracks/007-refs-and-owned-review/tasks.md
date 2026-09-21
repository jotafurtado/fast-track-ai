---
status: approved
---

# Tasks: 007-refs-and-owned-review

- [x] T001 Add the init-owned ref template (`type: inline | pointer`), `sha256`, 500 KB cap, pointer fields `source`, `pin`). Files: `skills/fast-track-ai-init/assets/refs.md`, `skills/fast-track-ai-init/SKILL.md`. Validate: template has those fields; init skill names `fast-track-ai/refs/<slug>.md` and `./assets/refs.md`.
- [x] T002 Add `refs: []` to the intent template and teach the intent skill to file a basis source as a ref and cite the slug in `refs:`. Files: `skills/fast-track-ai-intent/assets/intent.md`, `skills/fast-track-ai-intent/SKILL.md`. Validate: template has `refs: []`; skill names `refs:` and `../fast-track-ai-init/assets/refs.md`.
- [x] T003 Require `type: inline` or `type: pointer` on every ref in the index, keep `sha256` and the 500 KB cap, and add a fixture to the live index eval. Files: `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`, `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`. Validate: `bash -n`; fixture without `type` exits 1; `code-review-skill.md` still indexes.
- [x] T004 Name `refs:`, the two types, and immutability on the managed AGENTS snippet and this repo's managed block. Files: `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`. Validate: both contain `refs:` and `Source changed, new file`; `AGENTS.md` still has one managed block.
- [x] T005 Replace Matt `/code-review` on implement with a package-owned review step adapted from `refs/code-review-skill` (principles, phases, severity). Files: `skills/fast-track-ai-implement/SKILL.md`. Validate: grep finds no `/code-review` and no `issue-tracker.md`; skill names `code-review-skill`.
- [x] T006 Run init and index on a scratch copy in `/tmp`; inject a ref missing `sha256` and confirm index fails. Files: none in this repo. Validate: first index exits 0; after injection, index exits 1.

Auxiliary output files go under `assets/`, never loose at the track root.
