# Design

## Context

See proposal.md for motivation. Current state that shapes the approach:

- `fast-track-ai-index.sh` and `fast-track-ai-gate.sh` each carry their own one-line awk field extractor. Both count every `---` line, so a file whose frontmatter does not open on line 1 can still yield fields, and an unclosed block reads the body as metadata. Both return the first match, so a duplicate key is silently ignored.
- The gate walks the track root with `"$base"/*`. The glob skips dotfiles, and the walk checks names only, never types.
- The index accepts `active` in its intent status `case`. The `index` selector's main fixture `001-example` is written `active` and asserted as `| 001-example | active |`.
- The handoff skill writes, archives, then indexes. The index cannot validate the new handoff before archiving, because four active handoffs trip its more-than-three rule.
- The init conformance check is agent-run from the skill and relies on gate failures. A root `decisions.md` passes the gate, so the check never sees it today.
- The ownership rule applies: each script has one owner skill, there is no shared library, and cross-skill use goes through sibling paths.
- Every template's frontmatter already fits the subset: `key: value` lines, flow lists, and no blank or indented lines.

## Goals / Non-Goals

**Goals:**

- Index and gate agree on what counts as valid frontmatter and reject the same malformed inputs.
- Every script and template change has an eval that fails on regression, and `evals/run-evals.sh all` and `isolation` stay green.
- Consuming repositories with legacy `active` intents or root `decisions.md` files keep indexing and gating.

**Non-Goals:**

- A full YAML parser, or any new dependency.
- Gate warnings. The gate's output stays one `PASS:` line or `FAIL:` lines.
- Moving legacy `decisions.md` content into global ADRs. Normalization preserves the file and does not interpret it.
- A single-file validation mode in the index.

## Decisions

### D1. Duplicate a small frontmatter validator in each script

Each script gets the same awk validator, plus a field extractor that reads only the line-1 block. The validator returns the first violation as one of three messages:
- `frontmatter not closed`.
- `duplicate frontmatter field <key>`.
- `frontmatter line <N> is not a key: value field`.

Each script wraps that message in its own style. The index uses `ERROR: <file> ...`, accumulates, and skips the artifact's other checks. The gate uses `FAIL: <file> ...` and exits.

The `frontmatter` eval feeds the same malformed fixtures to both scripts and asserts the same rule text from each. That keeps the two copies in lockstep.

Alternatives considered:
- **Gate calls the index script.** The index walks the whole tree and fails on unrelated artifacts.
- **A shared helper file.** It breaks the single-owner rule, since there is no `shared` link.

### D2. Blank lines inside the block are allowed, comments are not

A blank line is unambiguous. A `#` comment, an indented continuation, or a block-style list item is not a field, so it fails with its line number. This rejects exactly the YAML shapes the current extractor would misread.

### D3. Hidden root entries fail without an ignore list

The gate enumerates dotfiles explicitly, excluding `.` and `..`. Any hidden entry fails with `FAIL: <track> hidden root entry: <name>`, including `.DS_Store`.

An ignore list would encode one operating system's or one editor's habits into the method. The gate claims to check the track root, so it checks all of it. Init normalization moves such entries to `assets/legacy/`, and the user can delete them instead.

### D4. Root checks run in a fixed order with one message per rule

The checks run in this order:
1. Intent presence and its frontmatter, then the intent id.
2. `plan.md`.
3. Hidden entries.
4. Unknown names, which keeps the existing loose-file message.
5. Type checks: `<name> must be a file` for the four `.md` names, `<name> must be a directory` for `spec` and `assets`.
6. Missing `spec.md` or `tasks.md`.
7. Frontmatter of `spec.md` and `tasks.md`.

Type checks use `-f` and `-d`, so a symlink to the right type is accepted. That matches how the scripts already treat paths.

### D5. Legacy root `decisions.md` is detected by init, not the gate

The gate keeps `decisions.md` in its allowed list with the file-type check. The init skill adds a separate rule: list any track whose root holds `decisions.md`, with the reason `legacy root decisions.md`, in the same single question as the gate failures. On yes, move it to `assets/legacy/decisions.md`, with the existing collision stop.

A gate failure would break every existing consumer track at once. A gate warning would change the gate's output contract.

### D6. Handoff self-validation is an agent step in the skill

The skill gets explicit ordered steps: check collision, write, validate the new file, archive, index. The validation checks every heading in `./assets/handoff.md`, the `captured` form and its equality with the filename instant, and the subset rules.

The command wrapper already says "archives older handoffs before running the index". It gains "after validating the new handoff". The `handoff` eval asserts the step order by line position in `SKILL.md`, using the validate, archive, and index lines.

### D7. Legacy `active` gets one dedicated fixture

In the `index` selector, `001-example` becomes `draft`, and its row assertion changes to match. A new `003-legacy-active` intent proves that `active` still indexes.

A new `active` eval asserts the following:
- No `SKILL.md`, template, or command file contains `status: active`.
- The index script carries the legacy comment next to its status `case`.
- `active` appears in `run-evals.sh` only for the legacy fixture.

### D8. Init normalization cannot move `assets` into itself

When the rejected root entry is a regular file named `assets`, normalization stops for that track and reports it. Renaming it to free the directory name would be an invented layout. Other mistyped entries move to `assets/legacy/<name>` as usual.

## Eval Coverage

| Change | Selector | Regression it catches |
|---|---|---|
| Legacy `active` comment, live surfaces free of `status: active`, dedicated fixture | `active` (new), `index` | A skill or template writes `active` again, the index stops accepting legacy `active`, or a default fixture reverts to `active` |
| Frontmatter subset in the index | `frontmatter` (new) | Unclosed block, duplicate key, indented or block-list line, or later-pair read is accepted, or `INDEX.md` changes on rejection |
| Frontmatter subset in the gate | `frontmatter` (new) | The same fixtures pass the gate for `intent.md`, `spec.md`, and `tasks.md` |
| Templates conform | `frontmatter` (new) | A template's frontmatter stops fitting the subset |
| Hidden and mistyped root entries | `spec` | `.notes`, `.DS_Store`, file `assets`, directory `spec.md`, or file `spec` passes; a root `decisions.md` file starts failing |
| Code-review provenance wording | `flow` | The implement skill loses the provenance-only and consumer-need-not-have statements, or regains `pointer; do not vendor` |
| Handoff order | `handoff` | Validate, archive, and index steps appear out of order in `SKILL.md` |
| Root `decisions.md` retired | `init`, `spec` | The snippet or spec template lists `decisions.md` again; the init skill drops the legacy move to `assets/legacy/decisions.md` |

Agent-run behavior, such as init actually moving files or handoff actually refusing to archive, stays covered only by skill-text assertions. Agent evals are out of scope.

## Risks / Trade-offs

- **[Risk]** Consumers on macOS fail the gate because of `.DS_Store` in a track root. → **Mitigation:** The message names the entry, and init normalization or a plain delete fixes it. The `spec` eval pins this behavior so it is a visible decision, not an accident.
- **[Risk]** Consumer artifacts written by hand with comments or block lists in frontmatter start failing the index. → **Mitigation:** Every message names the file, the rule, and the line number. The templates never produced these shapes.
- **[Risk]** The two validator copies drift. → **Mitigation:** The `frontmatter` eval runs identical fixtures through both scripts.
- **[Trade-off]** Handoff self-validation is agent-checked, not script-checked. The index still validates every handoff after archiving, so a missed defect surfaces one step later, with no archive collision possible.

## Migration Plan

1. Ship scripts, templates, skills, and evals in one change.
2. In consuming repositories, the next gate or index run reports any hidden or mistyped root entry and any frontmatter violation. Running init lists legacy root `decisions.md` files and offers normalization.
3. Rollback is a revert of this change. No artifact in a consuming repository is rewritten without user consent.
