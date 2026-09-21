---
status: approved
---

# Spec: 007-refs-and-owned-review

Thin product description owned by this package. Not a Spec Kit artifact.

## Outcome

A user-supplied source that is the basis for a track is filed at `fast-track-ai/refs/<slug>.md`. Two types:

- **inline**: the full durable text (for example an Obsidian Markdown note).
- **pointer**: a short Markdown file that names where the content lives (URL, pin, hash). Used for live online sources.

`refs/` stays immutable: source changed, new file. An intent cites those slugs in `refs:`. `research:` stays for investigation this package produced. `assessments:` stays for inward evaluations.

Index validation keeps `sha256` and the 500 KB cap. Intent template and skill know how to file a ref and cite it. The managed AGENTS block names `refs:` and the immutability rule.

Implement stops calling Matt Pocock `/code-review`. After the structural gate it runs a package-owned review step, adapted from `refs/code-review-skill` (principles, phases, severity labels). No seventh skill. The upstream language-guide tree is not vendored. `docs/agents/issue-tracker.md` is not required.

The existing pointer `fast-track-ai/refs/code-review-skill.md` stays the review base for this track.

## Cycle

intent.md (draft allowed) → `fast-track-ai-spec` drafts `spec.md` and `tasks.md` → approval → implement.

## Phases

### Phase 1: File and cite refs
Done: A user-supplied source that is the basis for a track is filed at `fast-track-ai/refs/<slug>.md` from an init-owned template. Two types: `inline` (full durable text) and `pointer` (URL, pin, hash). Intent template has `refs: []`. Intent skill files the ref and cites the slug in `refs:`. `research:` and `assessments:` stay as they are.
Files: `skills/fast-track-ai-init/assets/refs.md`, `skills/fast-track-ai-init/SKILL.md`, `skills/fast-track-ai-intent/assets/intent.md`, `skills/fast-track-ai-intent/SKILL.md`
Accept: Template has `type`, `sha256`, and 500 KB note; intent template has `refs: []`; intent skill names `fast-track-ai/refs/<slug>.md` and `refs:`.

### Phase 2: Index and AGENTS
Done: Index still requires `sha256` and the 500 KB cap, and also requires `type: inline` or `type: pointer`. Managed AGENTS block names `refs:`, the two types, and immutability (`source changed, new file`). Existing `fast-track-ai/refs/code-review-skill.md` stays the review base and still passes the index.
Files: `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`, `skills/fast-track-ai-init/assets/AGENTS-snippet.md`, `AGENTS.md`, `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh`
Accept: Scratch index fails a ref without `type` or `sha256`; valid pointer fixture exits 0; both AGENTS files name `refs:`; `AGENTS.md` still has one managed block.

### Phase 3: Owned review on implement
Done: Implement no longer calls Matt Pocock `/code-review`. After the gate it runs a package-owned review: principles, phases, and severity labels adapted from `refs/code-review-skill`. No seventh skill. No vendored upstream tree. `docs/agents/issue-tracker.md` is not required.
Files: `skills/fast-track-ai-implement/SKILL.md`
Accept: Skill text names the owned review and `refs/code-review-skill`; grep finds no `/code-review` and no `issue-tracker.md`.

### Phase 4: Scratch validation
Done: Init, index, and a pointer plus inline ref fixture are green in `/tmp`. A ref over 500 KB or missing `sha256` fails. This repo is not the scratch target.
Files: none in this repo beyond reading the scripts above
Accept: Scratch index exits 0 with the existing pointer shape; missing `sha256` then exits 1.

## Constraints

Keep user-facing package prose in English. Stay inside the six-skill package. Do not vendor `awesome-skills/code-review-skill`. Do not require `docs/agents/issue-tracker.md`. Preserve `refs/` immutability and the 500 KB cap. Do not rewrite frozen `001` prose. Do not close `004`, `006`, `008`, or `009`. Validate method changes in `/tmp`.

## Out of scope

The ADR standard (`004`). Open questions moving with the spec (`006`, shipped). Adding `fast-track-ai-review`. Installing or mirroring the upstream skill into the harness. Changing Matt Pocock `research`, `handoff`, or `grilling`. Unified spec (`008`). Track terminal states (`009`).
