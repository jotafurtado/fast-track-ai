<!-- BEGIN MANAGED BLOCK: fast-track-ai. Installed by fast-track-ai-init, idempotent block. -->

## fast-track-ai

Active memory in `fast-track-ai/`. Read `fast-track-ai/INDEX.md` first, never scan the whole tree.

Mandatory flow, no exceptions: a new request becomes `intent.md` first. No approved intent means no `spec.md`, no `plan.md`, no code. No `spec.md` means no plan approval. No `plan.md` and `tasks.md` with `status: approved` means no implementation. Intents live in `fast-track-ai/tracks/NNN-slug/intent.md`, drafted by the `fast-track-ai-intent` skill.

- Valid handoff: only the 3 most recent in `fast-track-ai/handoffs/`. Ignore `archive/`.
- Track root holds only `intent.md`, `spec.md`, `plan.md`, `tasks.md`, `decisions.md`, plus `assets/`. A leftover `spec/` directory is historical and does not select a cycle. Loose files are forbidden. Auxiliary outputs go under `assets/`.
- `refs/` is immutable. Source changed, new file.
- A recorded decision is never relitigated.
- Each script and template has one owner skill. Cross-skill consumers reference the owner copy via package-relative sibling paths. No `shared` link.

<!-- END MANAGED BLOCK: fast-track-ai -->
