# Evals: Skill Standards Compliance

## Eval 1: init on empty repo

- Prompt: "Setup dot-ai here."
- Expected files: `dot-ai/{research,refs,handoffs/archive,assessments,decisions,tracks,specs}/`, `specs` symlink, `dot-ai/INDEX.md`, managed block in `AGENTS.md`. No `scripts/`, no `templates/` in target.
- Expected exit: 0, twice in a row (idempotent).
- Result (2026-09-15, /tmp/dot-ai-test7): PASS. Second run clean, no duplicated block.

## Eval 2: index on active track

- Prompt: "Regenerate the index."
- Expected files: `dot-ai/INDEX.md` with `| 001-exemplo | active | rapida |`.
- Expected exit: 0.
- Result: PASS.

## Eval 3: gate on open and closed tasks

- Prompt: "Check if the track is done."
- Expected exit: 1 with `2 open task(s)` before checking boxes; 0 with `short cycle intact` after.
- Result: PASS, both states observed.
