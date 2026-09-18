<!-- BEGIN MANAGED BLOCK: dot-ai. Installed by dot-ai-init, idempotent block. -->

## dot-ai

Active memory in `dot-ai/`. Read `dot-ai/INDEX.md` first, never scan the whole tree.

Mandatory flow, no exceptions: a new request becomes `intent.md` first. No approved intent means no `plan.md`, no `spec/`, no code. No `plan.md` and `tasks.md` with `status: approved` means no implementation. Intents live in `dot-ai/tracks/NNN-slug/intent.md`, drafted by the `dot-ai-intent` skill.

- Valid handoff: only the 3 most recent in `dot-ai/handoffs/`. Ignore `archive/`.
- A track with `plan.md` and no `spec/` has no spec. Do not look for one.
- Track root holds only `intent.md`, `plan.md`, `tasks.md`, `decisions.md`, plus `spec/` and `assets/`. Loose files are forbidden. Auxiliary outputs go under `assets/`.
- `refs/` is immutable. Source changed, new file.
- A recorded decision is never relitigated.
- Full cycle: the `dot-ai-specify` wrapper from the skill package, run with the target repo as working directory. Never the Spec Kit script directly.

<!-- END MANAGED BLOCK: dot-ai -->
