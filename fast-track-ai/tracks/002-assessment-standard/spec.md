---
status: approved
---

# Spec: 002-assessment-standard

Thin product description owned by this package. Not a Spec Kit artifact.

## Outcome

An assessment is inward research: an evaluation of this method or of a target repository. It is raw input for a later intent. It is not a track, not a plan, and not external research.

Location: `fast-track-ai/assessments/<YYYY-MM-DD>-<slug>.md`. Repository-wide. Optional `tracks` list names zero or more track ids.

Required English frontmatter: `captured` (the date in the filename), `owner`, `scope`. Optional: `tracks`. Forbidden: `status`. Body baseline: title, Conclusion, Findings.

`fast-track-ai/INDEX.md` has two tables: tracks (`track`, `status`) and assessments (`assessment`, `captured`). The index validates every assessment file: name shape, required fields, no `status`, and `captured` matching the filename date.

No seventh skill. `fast-track-ai-init` owns the template. Any skill or the agent files from that template when the work is an internal evaluation. `fast-track-ai-intent` reads assessments and cites them on a new intent in `assessments: [<YYYY-MM-DD>-<slug>, ...]`. The `research` field stays for `fast-track-ai/research/` slugs only.

The file `fast-track-ai/assessments/2026-09-15-project-completeness.md` is an example. This track may drop its `status` field. It does not close or rewrite findings.

## Cycle

intent.md (draft allowed) → `fast-track-ai-spec` drafts `spec.md` and `tasks.md` → approval → implement.

## Phases

### Phase 1: Template and filing rule
Done: The init-owned template has `captured`, `owner`, `scope`, optional `tracks`, and no `status`. Init tells the agent when a write is an assessment and where to file it.
Files: `skills/fast-track-ai-init/assets/assessment.md`, `skills/fast-track-ai-init/SKILL.md`
Accept: Template greps have no `^status:`; skill text names the filename shape and forbids `status`.

### Phase 2: Index second table
Done: `fast-track-ai-index.sh` still writes the tracks table, then an assessments table (`assessment`, `captured`). It validates assessment files and fails on `status` or missing required fields.
Files: `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`
Accept: A scratch tree with one valid assessment lists it; a file with `status` makes the index exit 1.

### Phase 3: Intent citation and AGENTS rule
Done: Intent template has `assessments: []`. Intent skill cites existing assessments there, not in `research`. Managed AGENTS block distinguishes assessments from research.
Files: `skills/fast-track-ai-intent/assets/intent.md`, `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`
Accept: New intent template greps `^assessments:`; AGENTS managed block names `fast-track-ai/assessments/` and says assessments have no `status`.

### Phase 4: Align the existing example
Done: The completeness report drops `status` and keeps its findings. Index in this repo lists that file. Findings are not edited.
Files: `fast-track-ai/assessments/2026-09-15-project-completeness.md`, `fast-track-ai/INDEX.md`
Accept: File has no `^status:`; `INDEX.md` has an assessments table row for `2026-09-15-project-completeness`.

### Phase 5: Scratch validation
Done: Init, index, and a one-file assessment are green in `/tmp`. A second init stays idempotent. This repo is not the scratch target.
Files: none in this repo beyond reading the scripts above
Accept: Scratch index exits 0 with two tables; injecting `status: open` into the scratch assessment makes index exit 1.

## Constraints

Keep user-facing package prose in English. Stay inside the six-skill package. Do not give assessments a lifecycle. Do not recreate `.specify/` or any Spec Kit view. Do not treat the completeness report format as the template. Frozen `001` prose stays frozen. Validate method changes in `/tmp`.

## Out of scope

Resolving findings inside `2026-09-15-project-completeness.md`. The ADR standard (`004`). Adding `fast-track-ai-assess`. Changing Matt Pocock skills. Rewriting frozen `001` prose. Changing how `fast-track-ai-plan` asks open intent questions (`006`).
