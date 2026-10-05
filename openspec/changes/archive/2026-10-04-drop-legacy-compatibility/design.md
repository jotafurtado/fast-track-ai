# Design

## Context

See `proposal.md` for motivation and the delta specs for the contract. Here is where the legacy contract lives today.

**Index script** (`skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`):
- Line 154 holds a legacy comment, and line 155 accepts `active` in the status `case`.
- Lines 329-335 compute epoch seconds with offset arithmetic.
- Lines 355-358 accept the `HHmm-OFFSET` filename and offset `captured`.
- Line 381 accepts the P0/P1/First-next-action set.

**Gate script** (`skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`):
- Lines 77-78 give `plan.md` a dedicated message.
- Line 90 lists `decisions.md` and `spec` in the root allow-list.
- Lines 103 and 109 type-check them.
- The task parser (lines 186-216) skips the before-first-header check when there is no header, which acts as an implicit group.

**Skills, commands, templates, and snippet:**
- `skills/fast-track-ai-init/SKILL.md` step 4 is the conformance and normalization pass, and `commands/fast-track-ai-init.md` line 7 describes it.
- Implement step 1, spec step 2, the spec template's `## File rules`, and snippet line 19 carry leftover-`spec/` and `plan.md` sentences. So do the implement and spec commands.

**Evals** (`evals/run-evals.sh`):
- `write_tasks` writes an ungrouped task, so every gate fixture relies on the implicit group.
- `write_handoff` writes the P0/P1 headings, and the index and handoff fixtures use `-0300` and `+0200` names.
- The `active` selector proves legacy acceptance.
- `run_init` asserts the normalization text.
- The `spec` selector passes a root `decisions.md`.

**Agent-eval fixtures:** they already group their tasks and do not build handoffs.

## Goals / Non-Goals

**Goals:**
- One contract per artifact, with no "legacy" branch in scripts, skills, or specs.
- Every removed acceptance is replaced by a fixture that proves the legacy shape now fails.
- All selectors stay green, and `flow`, `isolation`, and the agent-eval syntax checks are unaffected.

**Non-Goals:**
- Moving the repository's `fast-track-ai/` tree, editing the repository's `AGENTS.md`, or rewriting the README. These belong to `archive-repo-history`.
- A migration tool for consumers.
- Changing the `init` script's managed-block refresh or the leftover-`specs/` non-interference check. That check is about Spec Kit coexistence, not about the method's own legacy.

## Decisions

### 1. Retired root files fall into the generic rule
**Choice:** Remove the `plan.md` branch, and remove `decisions.md` and `spec` from the allow-list and type checks. The existing loop then reports them as entries outside the allowed set.
**Why:** One message path, and no file names that only exist for history.
**Alternative:** Keep the dedicated `plan.md` message. Rejected, because that is legacy guidance by another name.

### 2. Group headers are mandatory in the task parser
**Choice:**
- Fail with `tasks.md has no group header` when the header count is zero.
- Always fail a task line seen before the first header.
- Run this inside the existing `awk` program, so a single run reports every problem.

**Why:** The implement skill orders work by groups, and the template already has `## Group A`.

### 3. Handoff time handling becomes UTC-only
**Choice:**
- The filename regex is `^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}Z-<slug>\.md$`.
- `captured` must end in `Z`.
- The epoch function drops the offset parsing. Ordering is still by `captured` epoch, not by filename.
- The P0/P1 branch is removed, so `## Next actions` is required.

**Why:** Less code, and the design decisions in `harden-method-scripts` about BSD `date` portability still apply to the remaining arithmetic.

### 4. `active` rejection reuses the unknown-status error
**Choice:** Remove `active` and the legacy comment from the `case`. The existing `invalid status: <value>` message covers it. The `active` eval selector becomes:
- No live file writes `status: active`.
- An `active` fixture fails the index with `invalid status: active`.
- `INDEX.md` stays unchanged.

**Why:** No new error text, and the selector name keeps its meaning.

### 5. Init loses step 4 entirely
**Choice:** Delete step 4 from the init skill and line 7 from its command. Keep steps 1-3 (script, verify tree, index).
**Why:** Without compatibility, migrating old tracks is out of the method. A failing track is reported by the gate when someone works on it.

### 6. Eval fixtures move to the live format first
**Choice:**
- `write_tasks` emits `## Group A` before its task line.
- `write_handoff` emits `## Next actions` and is called only with UTC-seconds names.
- Then the legacy fixtures flip to `expect_failure` cases: ungrouped tasks, root `decisions.md`, `spec/`, `plan.md`, `active`, an offset handoff name, and P0/P1 headings. Each asserts its message.

**Why:** Converting the helpers first keeps the unrelated selectors green while the legacy assertions are inverted.

## Risks / Trade-offs

- **[Consumers with old tracks or handoffs see failures after upgrading]** → Breaking change by decision. Each failure names the file and rule. The removed-requirement `Migration` notes say how to fix it by hand.
- **[Removing the offset branch drops correct ordering for consumers' existing offset handoffs]** → Those files now fail validation outright, so they cannot be misordered silently.
- **[The README stays stale until `archive-repo-history`]** → It is the next planned change, and the proposal states the gap.

## Migration Plan

1. Convert the eval helpers to the live format, and run `run-evals.sh all` to confirm it is still green.
2. Change the index, the gate, and the skill, command, template, and snippet text.
3. Invert the legacy fixtures, then update the `evals.md` rows.
4. Run `run-evals.sh all`, then grep the live package for `legacy`, `leftover`, `plan.md`, `decisions.md`, `HHmm-OFFSET`, `P0 next`, and `assets/legacy`, and confirm none remain outside the allowed eval assertions.

Rollback: revert the commit. No artifact in this repository depends on the legacy contract.
