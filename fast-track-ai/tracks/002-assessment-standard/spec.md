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

intent (`status: active`) → this `spec.md` → approved `plan.md` and `tasks.md` → implement.

## Constraints

Keep user-facing package prose in English. Stay inside the six-skill package. Do not give assessments a lifecycle. Do not recreate `.specify/` or any Spec Kit view. Do not treat the completeness report format as the template. Frozen `001` prose stays frozen. Validate method changes in `/tmp`.

## Out of scope

Resolving findings inside `2026-09-15-project-completeness.md`. The ADR standard (`004`). Adding `fast-track-ai-assess`. Changing Matt Pocock skills. Rewriting frozen `001` prose. Changing how `fast-track-ai-plan` asks open intent questions (`006`).
