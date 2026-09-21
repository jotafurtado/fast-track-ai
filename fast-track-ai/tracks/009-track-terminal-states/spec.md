---
status: approved
---

# Spec: 009-track-terminal-states

Thin product description owned by this package. Not a Spec Kit artifact.

## Outcome

A track leaves `active` only through an explicit maintainer command, recorded on the intent and then in `INDEX.md`.

- **`shipped`**: tasks have no open items, the structural gate passes, and the maintainer approves the ship. After the gate and the owned review, implement asks for that approval. Only then it sets intent `status: shipped` and regenerates the index. Checkboxes and a green gate never ship by themselves.
- **`dropped`**: the maintainer abandons the work. Implementation is not required. The intent stays the record. `003` is the existing example.
- **`superseded`**: the maintainer names the replacement in `superseded_by`. The index already fails a superseded track that lacks that field.

No seventh skill. Implement owns `shipped`. Intent (or the agent following the managed AGENTS rule) owns `dropped` and `superseded`. Tracks already `shipped` (`001`, `002`, `004`, `005`, `006`, `007`, `008`) are not rewritten.

## Phases

### Phase 1: Implement asks, then ships
Done: Implement step 7 still closes task checkboxes and regenerates the index for review. It then asks for an explicit ship. After that approval it sets intent `status: shipped` and regenerates `INDEX.md` again. It never writes `shipped` before the ask.
Files: `skills/fast-track-ai-implement/SKILL.md`, `commands/fast-track-ai-implement.md`
Accept: Implement skill and command name the ship ask and `status: shipped`; both still say checkboxes alone never ship.

### Phase 2: Dropped and superseded
Done: Intent skill and the managed AGENTS block name how a maintainer sets `dropped` (abandon, no implementation required) and `superseded` (requires `superseded_by`). Neither invents `superseded_by`.
Files: `skills/fast-track-ai-intent/SKILL.md`, `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`
Accept: Intent skill and both AGENTS files name `dropped` and `superseded_by`; `AGENTS.md` still has one managed block.

### Phase 3: Scratch validation
Done: Init and index stay green in `/tmp`. A scratch track with `status: superseded` and no `superseded_by` still fails the index. This repo is not the scratch target. Already-shipped tracks are not rewritten.
Files: none in this repo beyond reading the scripts above
Accept: Scratch index exits 0; injecting `superseded` without `superseded_by` exits 1.

## Constraints

Keep user-facing package prose in English. Stay inside the six-skill package. Do not auto-ship. Do not invent `superseded_by`. Do not rewrite frozen `001` prose. Do not close `010`. Validate method changes in `/tmp`.

## Out of scope

Unified spec (`008`, shipped). Open questions moving with the spec (`006`, shipped). Refs and owned review (`007`, shipped). ADR standard (`004`, shipped). Approval ask vs draft-gate FAIL (`010`). Resolving other findings in `2026-09-15-project-completeness.md`. Adding a seventh skill.

## File rules
Auxiliary outputs (inventories, reports, exports, evidence) go under `assets/`, never loose at the track root. Track root holds only `intent.md`, `spec.md`, `tasks.md`, `decisions.md`, plus `assets/`. Live tracks must not keep `plan.md`. A leftover `spec/` directory is historical and does not select a cycle.
