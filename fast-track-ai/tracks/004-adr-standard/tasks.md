---
status: approved
---

# Tasks: 004-adr-standard

- [x] T001 Replace the track-log template with a per-file ADR template (`id`, `status: accepted`, `date`, `owner`, Context, Decision, Rationale, Alternatives considered, Consequences). Files: `skills/fast-track-ai-plan/assets/decisions.md`. Validate: file has those headings; grep finds no `# Decisions: NNN-slug`.
- [x] T002 Teach plan and implement to file a qualifying decision at `fast-track-ai/decisions/<NNN-slug>.md` from the owner template, without a separate request. Files: `skills/fast-track-ai-plan/SKILL.md`, `skills/fast-track-ai-implement/SKILL.md`. Validate: both name that path and `accepted | superseded`.
- [x] T003 Extend `fast-track-ai-index.sh` with a decisions table (`decision`, `status`) and validation (`id` equals stem, required fields, `accepted | superseded`, `superseded_by` when superseded). Files: `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`. Validate: `bash -n`; fixture with `status: proposed` exits 1; valid fixture prints a third table.
- [x] T004 Teach the intent skill to cite ADRs in `decisions:`. Files: `skills/fast-track-ai-intent/SKILL.md`. Validate: skill text names `decisions:` and `fast-track-ai/decisions/`.
- [x] T005 Add the ADR rule to the managed AGENTS snippet and refresh this repo's managed block. Files: `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`. Validate: both contain `fast-track-ai/decisions/` and `never relitigated`; `AGENTS.md` still has one managed block.
- [x] T006 Promote the four 005 records to `fast-track-ai/decisions/` with `Rationale` and `Alternatives considered` as `None`. Files: `fast-track-ai/decisions/001-spec-md-owner.md`, `fast-track-ai/decisions/002-historical-spec-dir.md`, `fast-track-ai/decisions/003-live-evals-vs-frozen-spec.md`, `fast-track-ai/decisions/004-drop-vendored-speckit.md`. Validate: each Decision paragraph matches `005` `decisions.md`; no invented alternatives.
- [x] T007 Cite those four slugs on the 005 intent and regenerate `INDEX.md`. Files: `fast-track-ai/tracks/005-lightweight-sdlc/intent.md`, `fast-track-ai/INDEX.md`. Validate: `005` greps `001-spec-md-owner`; INDEX has a decisions table with four `accepted` rows.
- [x] T008 Run init and index on a scratch copy in `/tmp`; inject `status: proposed` and confirm index fails. Files: none in this repo. Validate: first index exits 0 with three tables; after injection, index exits 1.

Auxiliary output files go under `assets/`, never loose at the track root.
