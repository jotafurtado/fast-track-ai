# Tasks

## 1. Package-Owned Artifact Workflows

- [x] 1.1 Add `commands/fast-track-ai-assess.md`, `skills/fast-track-ai-assess/SKILL.md`, and `skills/fast-track-ai-assess/assets/assessment.md` with the evidence, counterevidence, evaluator, limitation, and recommendation contract; verify a `/tmp` install exposes the seventh skill and its command references that skill.
- [x] 1.2 Add `skills/fast-track-ai-research/assets/research.md` and rewrite the research skill and command to perform and save multi-source, status-free research without invoking a base skill; verify a fixture produced without external skills contains direct citations, conflicts/limitations sections, `captured`, and `owner`, and omits singular `source` and `status` frontmatter.
- [x] 1.3 Add `skills/fast-track-ai-handoff/assets/handoff.md` and rewrite the handoff skill and command to create the final file directly; verify a four-handoff `/tmp` fixture retains the three newest active files, archives the oldest, preserves exact user instructions, and contains no base-skill invocation.

## 2. Template Ownership and Capture Rules

- [x] 2.1 Move the ref template to `skills/fast-track-ai-intent/assets/ref.md`, encode inline/pointer license, hash, pin, retrieval, deduplication, and inaccessible-source rules, update intent to use its owner copy, then remove `skills/fast-track-ai-init/assets/refs.md`; verify eval fixtures cover inline, pinned pointer, mutable pointer, duplicate hash, invalid locator hash, and unavailable source behavior.
- [x] 2.2 Update `skills/fast-track-ai-intent/SKILL.md` so qualifying accepted decisions create and cite ADRs during intent, and update `skills/fast-track-ai-spec/assets/decisions.md`, spec, and implement instructions with optional evidence citations and planning-drift reconciliation; verify fixtures distinguish qualifying from local choices and require renewed approval only when implementation decisions materially change approved spec or tasks.
- [x] 2.3 Remove the init-owned assessment template after migrating every consumer to the assess-owned template, and update package ownership assertions; verify the resource eval reports exactly one owner for every script and template and no reference to either removed init asset remains.

## 3. Durable Evidence and Existing Artifacts

- [x] 3.1 Migrate `fast-track-ai/research/artifact-standards.md` from the current `status: raw` contract to the package research template while preserving its source/license matrix and adopted concepts; verify every eligible procedural source has its exact source URL, license URL, retrieval date, and MIT or Apache-2.0-compatible result, while excluded or restricted sources are labeled citation-only.
- [x] 3.2 Capture the Jhony Walker Medium article as an immutable pointer ref with canonical URL, retrieval metadata, observed-content SHA-256, and `content_license: unknown`; verify the hash is derived from the retrieved article payload rather than the URL or pointer body and that no protected article text is copied into package instructions.
- [x] 3.3 Record the accepted dedicated-assessment-skill decision in the next numbered file under `fast-track-ai/decisions/`, citing the earlier track 002 rationale without claiming a nonexistent ADR was superseded; verify the ADR contains context, decision, rationale, alternatives, consequences, and evidence references.
- [x] 3.4 Migrate repository-owned refs and assessments to required metadata without changing represented source identity, and verify the stricter index validator accepts every existing artifact before obsolete templates are deleted.

## 4. Index and Agent Guidance

- [x] 4.1 Extend `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh` to validate and deterministically render tracks plus refs, research, assessments, decisions, and active handoffs; verify valid fixtures appear in all six tables, archived handoffs are absent, each invalid invariant returns an artifact-specific failure, and two unchanged runs produce byte-identical output.
- [x] 4.2 Update `skills/fast-track-ai-init/assets/AGENTS-snippet.md` and the repository managed AGENTS block with the five artifact contracts, three explicit actions, two automatic captures, and INDEX-first discovery rule; verify the installed `/tmp` managed block matches the owner asset and a second init run creates no duplicate block.
- [x] 4.3 Regenerate `fast-track-ai/INDEX.md` with the updated generator and verify the saved research, Jhony ref, assessment artifacts, decisions, and any active handoffs are discoverable from the index without scanning their directories.

## 5. Evaluation and Final Gate

- [x] 5.1 Expand `fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh` and affected package contract fixtures for seven installed skills, new owner paths, self-contained workflows, schemas, licensing boundaries, and deterministic index behavior; verify each focused eval fails against the old contract and passes against the implemented contract.
- [x] 5.2 Run `./fast-track-ai/tracks/001-skill-standards/spec/assets/run-evals.sh all` in the repository, run init twice against a fresh `/tmp` target, run its index twice and compare outputs, and verify no `specs/`, `.specify/`, duplicated AGENTS block, external runtime skill dependency, or validation error remains.

## 6. Verification Follow-up

- [x] 6.1 Add focused coverage for procedural ref deduplication: compare a candidate hash before writing, reuse the existing ref slug instead of creating a duplicate, and retain index rejection for duplicate refs already persisted.
- [x] 6.2 Add focused fixtures for mutable pointer replacement and ADR supersession: preserve the original ref or decision content, create the new artifact, set the original ADR to `superseded`, and record `superseded_by`.
