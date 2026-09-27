# Tasks

## 1. Gate modes and structure checks

- [x] 1.1 Add `--mode structure|completion` to `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`, with completion as the default and unknown values rejected by a message naming both modes. Structure mode also checks the intent `id` against the directory name. Structure prints `PASS: <track> structure valid`, and completion keeps `PASS: <track> cycle intact`. Verify: `bash -n` passes, and `--mode draft` exits 1 naming `structure` and `completion`.
- [x] 1.2 Implement the per-phase `awk` check (at least one `### Phase`; non-empty `Done:`, `Files:`, `Accept:` per phase) and the per-task and group `awk` check: at least one task line, non-empty `Files:` and `Validate:` per task, unique group names, known `depends:` targets, no self-dependency, no task before the first header when headers exist, and DFS cycle detection. Messages name the file plus the phase or line. Verify: running the gate by hand on scratch tracks in `/tmp` reproduces each track-gate scenario's exit code and message.
- [x] 1.3 Switch `skills/fast-track-ai-spec/SKILL.md` step 4 and `commands/fast-track-ai-spec.md` to `--mode structure`, and remove the instruction to disregard draft-status and open-task gate results. Verify: `rg -- '--mode structure' skills/fast-track-ai-spec/SKILL.md commands/fast-track-ai-spec.md` matches both files, and `rg -i 'gate miss|open-task count' skills/fast-track-ai-spec/SKILL.md commands/fast-track-ai-spec.md` returns nothing.

## 2. Index integrity and atomic publication

- [x] 2.1 Render `INDEX.md` into `mktemp "$ai/.INDEX.md.XXXXXX"` with a cleanup trap. On success, `mv` it over `INDEX.md`. On errors, print `INDEX not updated: N error(s).` and exit 1. Verify: in `/tmp`, after a successful index, adding an invalid research file makes the index exit 1, `cmp` shows `INDEX.md` unchanged, and no `.INDEX.md.*` file remains.
- [x] 2.2 Add the orphan check (every `tracks/*/` directory has `intent.md`), flow-list parsing and existence checks for intent `refs`, `research`, `assessments`, and `decisions`, and `superseded_by` existence plus self-reference checks for intents and decisions. Verify: `/tmp` fixtures for `011-orphan`, `research: [missing-topic]`, `superseded_by: 099-nowhere`, a self-reference, and a non-list value each exit 1 with the named artifact.
- [x] 2.3 Fix `inline_source_hash` so it skips at most one blank separator line after `## Source content`. Verify: `/tmp` inline refs with and without the blank separator both validate when `sha256` covers all source lines, and the existing inline fixture's hash is unchanged.
- [x] 2.4 Accept `YYYY-MM-DD-HHmmssZ-slug.md` alongside the legacy handoff regex. For the new format, require the filename instant to equal a `Z` `captured`. Compute `captured` epoch seconds in `awk` to order handoff rows ascending, breaking ties by name, and fail when more than three active handoffs exist. Verify: a `/tmp` fixture with `2026-09-21-1000-+0200-a.md` and `2026-09-21-0930-Z-b.md` lists `a` before `b`, a mismatched new-format name fails, and a fourth active handoff fails.

## 3. Init block refresh

- [x] 3.1 In `skills/fast-track-ai-init/scripts/fast-track-ai-init.sh`, preflight the managed markers before any `mkdir`. The rules:
  - 0 and 0: append.
  - 1 and 1 in order: splice the snippet over the inclusive range.
  - Anything else: fail naming the counts, with no writes.
  - Write through `cat tmp > AGENTS.md` only when `cmp` shows a difference.

  Verify: `/tmp` fixtures cover an outdated block between user text (outside bytes identical, block equals the snippet), two runs byte-identical, begin without end, a duplicated block, and a symlinked `AGENTS.md` that is still a symlink with its target updated. The failure cases also leave the target without a `fast-track-ai/` tree.

## 4. Caller and template copy

- [x] 4.1 Update `skills/fast-track-ai-handoff/SKILL.md`, `skills/fast-track-ai-handoff/assets/handoff.md`, and `commands/fast-track-ai-handoff.md` for the UTC-with-seconds filename and `captured`, ordering by `captured` instant, no overwrite of active or archive files, and the archive-then-index sequence. Verify: `rg 'HHmmssZ' skills/fast-track-ai-handoff` matches both handoff files, and `rg 'HHmm-OFFSET' skills/fast-track-ai-handoff commands` returns nothing.
- [x] 4.2 Reword the 500 KB rule in `skills/fast-track-ai-intent/SKILL.md` and `skills/fast-track-ai-intent/assets/ref.md` so it applies to the whole ref file. Verify: both files state the limit for the ref file, and neither says that only the text must fit in 500 KB.

## 5. Evals and repository check

- [x] 5.1 Update `run-evals.sh`: `write_spec` gets a `### Phase 1: fixture` section with `Done:`, `Files:`, and `Accept:`. Add fixtures for every new scenario under the owning selectors (`approval` and `spec` for the gate, `index`, `handoff`, `init`), plus a positive completion run on repo tracks `008`, `009`, and `010`. Update `evals.md` rows to describe the new contracts. Verify: `bash fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all` exits 0 and prints `PASS: all evals`.
- [x] 5.2 Before running the index, copy the repository's `fast-track-ai/INDEX.md` to `/tmp`. Then run `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh .` and the default gate on `008-unified-spec`, `009-track-terminal-states`, and `010-approval-ask-not-gate-fail`. Verify: the index exits 0, `cmp` with the `/tmp` copy succeeds, and each gate run prints `PASS: <track> cycle intact`.
