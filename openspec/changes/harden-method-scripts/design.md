# Design

## Context

All three scripts are Bash with `awk`, `grep`, and `sed`, and run on macOS (BSD userland) and Linux. None of them have a YAML parser. They read frontmatter with line heuristics, so the field format stays the one the templates emit: one `key: value` per line and flow-style lists (`[a, b]`).

Observed state at `daa9040`:

- **Gate.** It exits on the first failure. It checks `Files:`, `Accept:`, and `Validate:` with a whole-file `grep -q` (`fast-track-ai-gate.sh:63-67`). It counts open tasks, so a file with zero task lines passes. The implement skill calls it without flags, and the eval selectors `approval` and `spec` rely on that default behavior.
- **Index.** It writes `INDEX.md` before checking `errors` (`fast-track-ai-index.sh:250-263`). It iterates only `tracks/*/intent.md`. Inline hash extraction starts after the first blank line following `## Source content` (`:40-46`).
- **Init.** It only appends the block when the begin marker is missing (`fast-track-ai-init.sh:18-24`). It creates directories before inspecting `AGENTS.md`.
- **Live links in this repo.** Every intent citation and every `superseded_by` resolves: `code-review-skill`, `2026-09-15-project-completeness`, decisions `001`-`006`. No track directory lacks `intent.md`. `handoffs/` holds only `archive/`. The new index checks therefore keep this repository green.
- **Shipped tracks.** `008`, `009`, and `010` use `### Phase N:` sections with `Done:`, `Files:`, and `Accept:` lines, and task lines carrying `Files:` and `Validate:` without group headers. All three pass the current gate.

## Goals / Non-Goals

**Goals:**
- Each rule in the delta specs is proved by a failing-then-passing fixture in `run-evals.sh`.
- The current callers keep working unchanged, except the spec skill's gate call, which moves to structure mode in this change.
- Legacy data in consumer projects still validates: `active` intents, minute-and-offset handoff names, and ungrouped `tasks.md`.

**Non-Goals:**
- Reporting every error in one gate run. The gate keeps its exit-on-first-failure style.
- Validating YAML beyond the template subset, or rejecting duplicate frontmatter keys.
- Having the index archive handoffs. It reports excess actives only.
- Detecting hidden files at the track root.

## Decisions

### 1. One gate script, `--mode`, default `completion`

**Choice:** Add `--mode structure|completion` to `fast-track-ai-gate.sh`. Omitting it means completion. Structure checks run first in both modes, and completion mode then adds approval and closed tasks.

**Why:** The implement skill, its command, and the `approval` and `spec` evals already call the gate with no flag and expect completion semantics. Defaulting to completion means only the spec skill and its command change.

**Alternatives:**
- A second script (rejected: it adds a resource owner and duplicates the structure logic).
- Defaulting to structure (rejected: it silently weakens every existing completion caller).

### 2. Parse phases, tasks, and groups in one `awk` program per file

**Choice:**
- `spec.md`: split into `### Phase` sections ending at the next `###` or `##` heading, then require non-empty `Done:`, `Files:`, and `Accept:` lines.
- `tasks.md`: track the current `## Group` header and record group names and `(depends: ...)` lists. Check each `- [ ] ` or `- [x] ` line for `Files:` and `Validate:` values. A label's value is non-empty when at least one non-space character appears after it and before the other label or the end of the line.
- Error messages carry the file, the phase or line number, and the violated rule.

**Why:** The same line-oriented style as the existing scripts, no new dependency, and precise messages.

**Alternatives:**
- Per-field `grep` on sliced ranges (rejected: many subprocesses, and slicing is awkward).
- A Go or TypeScript helper (rejected: the package ships shell scripts only).

### 3. Cycle detection by DFS in `awk`, not `tsort`

**Choice:** Build the group dependency graph in `awk` and run an iterative DFS with white, gray, and black marks. A gray back-edge is a cycle, and the message lists the groups on it.

**Why:** On this machine, BSD `tsort` prints `tsort: cycle in data` and still exits 0, while GNU `tsort` exits 1. Relying on `tsort` would need stderr parsing that differs between the two.

**Alternatives:** `tsort` plus a stderr check (rejected: the message format is not portable).

### 4. Index writes to a sibling temp file and renames on success

**Choice:**
- Render into `mktemp "$ai/.INDEX.md.XXXXXX"`, and remove it with a trap on any exit.
- With zero errors, `mv` it over `INDEX.md`.
- With errors, print `INDEX not updated: N error(s).` to stderr and exit 1.

**Why:** A rename within one directory is atomic on POSIX filesystems. A failed run leaves the previous memory intact, and the message states it.

**Alternatives:** Write to a temp file elsewhere and `cp` (rejected: not atomic and it crosses filesystems).

### 5. Link validation over flow-style lists only

**Choice:**
- For `refs`, `research`, `assessments`, and `decisions` on each intent, an absent field is fine (older intents omit some fields).
- A value of `[]` or `[a, b]` is split on commas, trimmed, and each slug is checked against `<category>/<slug>.md`.
- Any other non-empty form fails with `must use [a, b] list form`.
- `superseded_by` on intents resolves to `tracks/<id>/intent.md`, and on decisions to `decisions/<id>.md`. Each must also differ from the artifact's own id.

**Why:** The templates emit only flow lists. Rejecting other forms is safer than half-parsing them.

**Alternatives:** Accept block lists (rejected: no writer produces them, and the parser would grow for no current input).

### 6. Handoff instants computed in `awk`

**Choice:**
- New format: filename `YYYY-MM-DD-HHmmssZ-slug.md` with `captured: YYYY-MM-DDTHH:MM:SSZ`. The index checks that the filename instant equals `captured`.
- Legacy filenames (`HHmm-OFFSET`) are still accepted, without the equality check.
- The sort key is epoch seconds, computed in `awk` from `captured` using a days-from-civil calculation and the offset. Rows are listed ascending by key, and ties are broken by filename.
- More than three active files is an error.

**Why:** `date -d` (GNU) and `date -j -f` (BSD) are not portable. Plain arithmetic in `awk` works on both.

**Alternatives:**
- Sort by filename (rejected: this is the defect).
- Require UTC for every file (rejected: it breaks legacy handoffs in consumer projects).

### 7. Handoff skill archives, then indexes

**Choice:**
1. Write the new handoff (stop if the path exists).
2. Order the active files by `captured` instant.
3. Move all but the newest three into `archive/`, stopping before any move whose target exists.
4. Run the index and report its result.

**Why:** The index now fails on more than three actives. Indexing before archiving would always fail when the fourth file arrives. Only older, previously indexed files are moved, so a failed index afterwards points at the new handoff.

**Alternatives:** An index `--check-file` flag to validate one handoff before archiving (rejected: a new interface for a low-risk ordering problem).

### 8. Init preflights markers and writes in place only when content changes

**Choice:**
- Before creating any directory, count lines that start with `<!-- BEGIN MANAGED BLOCK: fast-track-ai` and lines that start with `<!-- END MANAGED BLOCK: fast-track-ai -->`.
- 0 and 0: append (current behavior). 1 and 1 with the begin line first: splice the snippet over that inclusive range. Anything else: fail naming both counts.
- Compute the result in a temp file and compare it with `cmp`. When it differs, write it with `cat tmp > AGENTS.md`.

**Why:** Writing through `>` keeps a symlinked `AGENTS.md` a symlink and keeps its mode. `mv` would replace the link with a regular file. Skipping identical writes keeps repeated runs byte-identical, with an unchanged mtime.

**Alternatives:** `mv` over the file (rejected: it breaks the symlink case). `sed -i` range replacement (rejected: `-i` differs between BSD and GNU).

### 9. Inline hash: skip at most one separator line

**Choice:** In `inline_source_hash`, after the heading, skip the next line only if it is empty. Then emit every remaining line with CR stripped.

**Why:** It matches the documented normalization and the template's layout, where a blank line follows the heading. Refs written that way hash identically before and after the change.

### 10. Eval fixtures grow real structure

**Choice:**
- `write_spec` emits a `### Phase 1: fixture` section with `Done:`, `Files:`, and `Accept:`. `write_tasks` keeps one task line.
- New negative fixtures, one per spec scenario, go under the existing selectors: gate cases under `approval` and `spec`, index cases under `index`, handoff cases under `handoff`, and block refresh under `init`.
- One positive fixture runs completion mode on repo tracks `008`, `009`, and `010`.

**Why:** Existing selectors already own these contracts, so a new selector would only split them.

## Risks / Trade-offs

- [Upgrade makes the index stricter in consumer projects: dangling citations, orphan directories, or four active handoffs now fail and leave the old `INDEX.md` in place] → Every error names the file and the fix. Legacy `active`, legacy handoff names, and ungrouped tasks stay valid.
- [A task whose `Validate:` text itself contains `Files:` is misread] → Values are measured up to the other label only. A literal label inside backticks in `Validate:` is still an edge case. Fixtures cover the template shape, and the error names the line so the author can rephrase.
- [Init fails on repos whose prose quotes the marker at line start] → Only lines that start with the exact marker prefix count, and inline mentions are ignored. On failure, nothing is written.
- [Shipped tracks from before `008` (for example `001`) may not satisfy the new phase rules] → The gate runs only on the track being implemented. `001` already fails on `plan.md` by prior decision. `008`, `009`, and `010` are asserted to still pass.
- [Changing the default message could break callers] → The completion success message stays `PASS: <track> cycle intact`. Structure mode prints `PASS: <track> structure valid`.

## Migration Plan

1. Land gate, index, and init changes with their fixtures, plus the caller edits: spec skill and command, handoff skill and template, and the 500 KB wording in the intent skill and ref template.
2. Run `run-evals.sh all` and the gate on `008`, `009`, and `010`. Then run the index on this repository and confirm that `INDEX.md` is byte-identical to its current content.
3. Consumers pick up the change by reinstalling and rerunning init, which now refreshes their block, and then the index.
4. Rollback: revert the commit. The data formats stay backward compatible (legacy handoffs and `active` still accepted), so no artifact needs to be rewritten either way.
