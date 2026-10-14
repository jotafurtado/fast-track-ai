---
status: approved
---

# Tasks: 002-assessment-standard

- [x] T001 Remove `status` from the assessment template; keep `captured`, `owner`, `scope`; add optional `tracks: []`. Files: `skills/fast-track-ai-init/assets/assessment.md`. Validate: `grep -q '^status:'` fails; `captured`, `owner`, `scope`, and `tracks` are present.
- [x] T002 Update the init skill filing rule: when a write is inward research, file `fast-track-ai/assessments/<YYYY-MM-DD>-<slug>.md` from the owner template; no `status`. Files: `skills/fast-track-ai-init/SKILL.md`. Validate: skill text names that path and forbids a `status` field.
- [x] T003 Extend `fast-track-ai-index.sh` with an assessments table (`assessment`, `captured`) and validation (name `YYYY-MM-DD-slug.md`, required fields, no `status`, `captured` equals the filename date). Files: `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`. Validate: `bash -n` on the script; a fixture with `status` exits 1; a valid fixture prints a second table.
- [x] T004 Add `assessments: []` to the intent template. Files: `skills/fast-track-ai-intent/assets/intent.md`. Validate: template greps `^assessments: \[\]$`.
- [x] T005 Teach the intent skill to list cited inward evaluations in `assessments`, never in `research`. Files: `skills/fast-track-ai-intent/SKILL.md`. Validate: skill text names `assessments:` and `fast-track-ai/assessments/`.
- [x] T006 Add the assessments rule to the managed AGENTS snippet and refresh this repo's managed block. Files: `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`. Validate: both contain `fast-track-ai/assessments/` and `no status`; `AGENTS.md` still has one managed block.
- [x] T007 Drop `status` from the completeness report only. Files: `fast-track-ai/assessments/2026-09-15-project-completeness.md`. Validate: `grep -q '^status:'` fails; Conclusion and Findings text is unchanged.
- [x] T008 Regenerate `fast-track-ai/INDEX.md` with the updated index script. Files: `fast-track-ai/INDEX.md`. Validate: file has a tracks table and an assessments row `2026-09-15-project-completeness`.
- [x] T009 Run init and index on a scratch copy in `/tmp`; then inject `status` into the scratch assessment and confirm index fails. Files: none in this repo. Validate: first index exits 0 with two tables; after `status` injection, index exits 1.

Auxiliary output files go under `assets/`, never loose at the track root.
