# Proposal

## Why

The repository's `fast-track-ai/` tree (tracks 001-010, ADRs, assessments, research, refs) is the history of how the package was first built, when the method was run on itself. That practice ended, and `drop-legacy-compatibility` removed the last package code that tolerated those tracks. The tree now fails the package's own gate, yet it sits at the repository root next to the live package, and `AGENTS.md` and the README still describe a repository that runs the method on itself.

## What Changes

- **History moves out of the root.** `fast-track-ai/` is moved with `git mv` to `docs/archive/fast-track-ai/`, unchanged and without conversion. The root no longer has a `fast-track-ai/` directory.
- **`AGENTS.md`** drops the rule that treats `fast-track-ai/` as a read-only archive, and the Map gains `openspec/` (specs and change history for the package) and `docs/archive/` (frozen history). The rule that `fast-track-ai-init` is never run here stays.
- **README is rewritten once** for the current package, in Portuguese like today:
  - It drops the init normalization paragraph, the `active` remark, the old `spec/` directory remark, and the "Gravar `plan.md`" breakage item.
  - It states that `## Group` headers are required in `tasks.md`.
  - The repository tree lists `docs/archive/`.
  - It does not mention OpenSpec.
- **Eval guard.** A new `docs` selector in `evals/run-evals.sh` checks that the root has no `fast-track-ai/`, that the README has none of the retired wording, and that `AGENTS.md` carries the new Map entries. `README.md` joins the files copied by the `isolation` selector.
- OpenSpec changes already archived under `openspec/changes/archive/` keep their old `fast-track-ai/...` paths. They are history.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `package-surface`:
  - The eval-suite requirement names `docs/archive/fast-track-ai/` as the place the runner must not read.
  - New requirements: repository history is archived outside the root, the README describes only the current package, and `AGENTS.md` describes the repository's own layout.

## Impact

- **Moved:** 55 tracked files from `fast-track-ai/` to `docs/archive/fast-track-ai/` (content unchanged).
- **Rewritten:** `README.md`.
- **Edited:** `AGENTS.md`, `evals/run-evals.sh`, `evals/evals.md`.
- **Not touched:** skills, commands, scripts, templates, `install.sh`, the managed block, and archived OpenSpec changes.
- **Consumers:** no effect. The `fast-track-ai/` layout that init creates in a consuming repository is the product and does not change.
- **Not in scope:** converting the archived assessments, ADRs, or research into another format; editing anything inside the moved tree; describing the package's own development workflow in the README.
