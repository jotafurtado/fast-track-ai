# Tasks

## 1. Move the history

- [x] 1.1 Run `mkdir -p docs/archive && git mv fast-track-ai docs/archive/fast-track-ai`. Verify:
  - `test ! -e fast-track-ai` succeeds, so the root has no `fast-track-ai/`, not even an empty `handoffs/archive/`.
  - `git ls-files docs/archive/fast-track-ai | wc -l` prints `55`.
  - `git status --short` shows only renames (`R`) for the moved files, and `git diff --cached -M --stat` reports no content change for them.

## 2. Repository docs

- [x] 2.1 Edit `AGENTS.md`:
  - Add `openspec/` (package specs and change history) and `docs/archive/` (frozen history of how the package was first built) to the Map.
  - Replace the rule at line 25 with: this repository does not run the method on itself, and `fast-track-ai-init` is never run here. Drop the "read-only archive" wording.

  Verify: `grep -c 'openspec/' AGENTS.md` and `grep -c 'docs/archive/' AGENTS.md` are both at least 1, `grep -ci 'read-only archive' AGENTS.md` prints `0`, and `grep -c 'never run `fast-track-ai-init`' AGENTS.md` prints `1`.
- [x] 2.2 Rewrite `README.md` in place, in Portuguese, keeping its structure and diagrams:
  - Remove the init paragraph about checking and normalizing existing tracks (line 33).
  - Remove the `active` remark (line 164).
  - Remove `plan.md` from the gate list (line 178) and from the breakage list (line 200).
  - Remove the old `spec/` directory remark (line 180).
  - Add one sentence saying `tasks.md` requires at least one `## Group` header.
  - Add `docs/archive/` as frozen history to the repository layout block.
  - Do not mention OpenSpec anywhere.

  Verify:
  - `grep -niE 'normaliz|\bactive\b|(^|[^a-z-])spec/|plan\.md|openspec' README.md` returns nothing.
  - `grep -n 'docs/archive/' README.md` matches the layout block.
  - `grep -n 'Group' README.md` matches the new required-header sentence.

## 3. Eval guard

- [x] 3.1 In `evals/run-evals.sh`:
  - Add `run_docs`, wired into `run_case` and placed after `isolation` in the `all` list.
  - `run_docs` asserts `$repo_root/fast-track-ai` does not exist.
  - It asserts `README.md` does not match `normaliz|\bactive\b|(^|[^a-z-])spec/|plan\.md|openspec` (case-insensitive) and contains `## Group`.
  - It asserts `AGENTS.md` contains `openspec/` and `docs/archive/` and does not contain `read-only archive`.
  - Add `README.md` to the items `run_isolation` copies.

  Verify:
  - `bash evals/run-evals.sh docs` exits 0 and prints `PASS: docs`.
  - On a temporary copy of `README.md` with the word `openspec` appended, the same assertions fail (run them against the copy, not the real file).
- [x] 3.2 In `evals/evals.md`:
  - Add a `docs` row to the selector table.
  - Change "fifteen" to "sixteen" in the recorded run.
  - Update the `isolation` row to list `README.md` among the copied files.
  - Reword the lines about the repository's own tree so they say the history lives under `docs/archive/fast-track-ai/`.

  Verify: `grep -c '`docs`' evals/evals.md` is at least 1, `grep -c 'sixteen' evals/evals.md` prints `1`, and no line still describes a root `fast-track-ai/` tree as present.

## 4. Final checks

- [x] 4.1 Run the whole change end to end. Verify:
  - `bash evals/run-evals.sh all` exits 0 and prints `PASS: all evals`. This includes `isolation`, which runs `all` in a copy without `docs/` or a root `fast-track-ai/`.
  - `bash -n evals/run-agent-evals.sh evals/agent/kiro-adapter.sh` passes.
  - `openspec validate archive-repo-history --strict` prints that the change is valid.
  - `git status --short` shows no modified file under `skills/`, `commands/`, or `install.sh`.
