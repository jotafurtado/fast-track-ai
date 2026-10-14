# Design

## Context

See `proposal.md` for motivation. Observed state:

- `fast-track-ai/` holds 55 tracked files. The directory also holds an empty `handoffs/archive/`, which git does not track.
- No skill, command, script, template, `install.sh`, or eval reads the repository's own tree. The `isolation` selector already copies only `skills`, `commands`, `install.sh`, `AGENTS.md`, and `evals` and asserts the copy has no `fast-track-ai/`.
- `AGENTS.md` line 25 calls the tree a read-only archive. Its Map does not list `openspec/`.
- The README still carries the init normalization paragraph (line 33), the `active` remark (line 164), `plan.md` in the gate list and breakage list (lines 178 and 200), and the old `spec/` remark (line 180).
- `evals/evals.md` says "all fifteen selectors" in its recorded run and describes `isolation` and the tree in lines 13, 31, 92.

## Goals / Non-Goals

**Goals:**
- Root with no `fast-track-ai/` directory, and history preserved with `git mv` so `git log --follow` works.
- README and `AGENTS.md` that describe only what the package does now.
- A deterministic guard so the retired wording and the root tree do not come back.

**Non-Goals:**
- Editing or converting any file inside the moved tree.
- Rewriting archived OpenSpec changes.
- Describing the package's own OpenSpec workflow in the README.

## Decisions

### 1. Move the whole directory in one `git mv`
**Choice:** `mkdir -p docs/archive` then `git mv fast-track-ai docs/archive/fast-track-ai`.
**Why:** Renames are detected as 100% similarity, and the untracked empty directory moves with it, so the root ends with no `fast-track-ai/` at all.
**Alternative:** Copy and delete. Rejected, because it loses rename tracking.

### 2. The README is rewritten in place, not from scratch
**Choice:** Keep the structure, diagrams, and the Portuguese voice. Remove only the retired paragraphs and items, add the `## Group` requirement, and add `docs/archive/` to the layout tree.
**Why:** The rest of the README already matches the live contract, and the user asked for one rewrite to the current state.
**Alternative:** A new document. Rejected as scope beyond the retired wording.

### 3. No OpenSpec in the README
**Choice:** The README stays a user-facing document about the method. The repository layout block lists `commands/`, `skills/`, `install.sh`, `evals/`, and `docs/archive/`, and omits `openspec/`.
**Why:** The user decided it. `AGENTS.md` is where maintainers find `openspec/`.

### 4. A `docs` selector guards the result
**Choice:** Add `run_docs` to `evals/run-evals.sh`, after `isolation` in the `all` list and in `run_case`. It:
- asserts `$repo_root/fast-track-ai` does not exist;
- asserts `README.md` does not match, case-insensitively, the extended regex `normaliz|\bactive\b|(^|[^a-z-])spec/|plan\.md|openspec`;
- asserts `README.md` contains `## Group`;
- asserts `AGENTS.md` contains `openspec/` and `docs/archive/`, and does not contain `read-only archive`.

**Why:** It is cheap, deterministic, and keeps the Kiro-free suite as the only gate.
**The `spec/` term is anchored:** a bare `spec/` also matches the live path `skills/fast-track-ai-spec/scripts/...` (README line 168). The `(^|[^a-z-])` prefix excludes a `spec/` preceded by a letter or a hyphen, so only the retired `spec/` directory remark (line 180) matches. Run against the current README, this regex matches lines 33, 164, 178, 180, and 200, which are exactly the retired items.
**Alternative:** Rely on grep in task Verify steps only. Rejected, because nothing would stop a later edit from reintroducing the wording.

### 5. `README.md` joins the isolation copy and `docs` must run inside it
**Choice:** Add `README.md` to the files `run_isolation` copies. The `docs` selector reads `README.md` and `AGENTS.md`, both present in the copy. The root-tree assertion holds in the copy by construction.
**Why:** Otherwise `docs` would fail inside the isolation copy, which runs `all` with the guard variable.

### 6. Count and wording in `evals.md`
**Choice:** Add a `docs` row, change "fifteen" to "sixteen" in the recorded run, and reword the `isolation` row and the lines about the tree to say the archive lives under `docs/archive/fast-track-ai/`.
**Why:** The documentation must match the runner.

## Risks / Trade-offs

- **[A reader looks for `fast-track-ai/` at the root]** → `AGENTS.md` Map points to `docs/archive/`. Moves are visible in git history.
- **[The guard blocks legitimate future README wording such as the word `active`]** → The current README uses `active` only in the retired remark. Any legitimate future use must be rephrased, or the guard edited together with the spec.
- **[Archived OpenSpec changes keep old `fast-track-ai/...` paths]** → By decision. They describe the state when they ran.

## Migration Plan

1. `git mv` the tree, then confirm the root has no `fast-track-ai/`.
2. Edit `AGENTS.md` and rewrite the README.
3. Add the `docs` selector and update `evals.md`, then run `run-evals.sh all`.

Rollback: revert the commit.
