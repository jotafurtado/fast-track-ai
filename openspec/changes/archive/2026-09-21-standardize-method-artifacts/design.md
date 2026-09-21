# Design

## Context

See `proposal.md` for motivation and `specs/method-artifacts/spec.md` for the behavioral contract.

The package currently has six `fast-track-ai-*` skills. The installer discovers those directories automatically, so a seventh skill needs no installer branch, but it does need its own command, skill directory, template, and evaluation coverage. Research and handoff are thin wrappers around non-package skills that the installer does not provide. Assessment is represented only by an init-owned template. Ref creation is performed by intent but its template is owned by init. ADR creation is performed by spec and implementation, while intent can only cite existing ADRs.

`fast-track-ai-index.sh` currently lists tracks, assessments, and decisions. It validates refs and research without listing them and has no handoff validation. `AGENTS.md` tells agents to read the index instead of scanning the tree, so omitted artifact classes are not discoverable through the prescribed entry point.

## Goals / Non-Goals

**Goals:**

- Keep three explicit user actions: research, assess, and handoff.
- Make those actions portable across harnesses without runtime skill dependencies.
- Put each template under the skill that writes that artifact.
- Keep validation deterministic, local, and executable with the package's existing shell requirements.
- Preserve the research basis and licensing evidence for future maintainers.
- Migrate repository-owned examples and fixtures to the new contracts in the same change.

**Non-Goals:**

- Add lifecycle status to refs, research, assessments, or handoffs.
- Introduce a database, schema library, content cache, generic knowledge graph, or shared resources directory.
- Vendor third-party skills, templates, or protected article text.
- Select or add a license for this repository.
- Convert fast-track-ai from its existing intent/spec/tasks lifecycle to OpenSpec.

## Decisions

### 1. Use one deep capability and five shallow artifact contracts

The implementation will retain five file types but define them through one `method-artifacts` capability. The types share capture, citation, indexing, and validation concerns, so separate runtime registries or generic artifact abstractions would add indirection without removing meaningful duplication.

Alternative considered: one capability and one framework module per artifact. Rejected because the package is instruction-and-template driven and each workflow is small.

### 2. Make three workflows explicit and two captures automatic

Research, assessment, and handoff remain invokable skills and commands. Intent automatically captures a material user-supplied basis as a ref. Intent, spec, and implementation automatically capture qualifying accepted decisions as ADRs.

Alternative considered: add commands for refs and ADRs. Rejected because both artifacts exist to support another workflow and a separate command would add user ceremony and allow uncited orphan artifacts.

### 3. Assign templates to their writer skills

Template ownership will be:

| Artifact | Owner template |
|---|---|
| handoff | `skills/fast-track-ai-handoff/assets/handoff.md` |
| research | `skills/fast-track-ai-research/assets/research.md` |
| assessment | `skills/fast-track-ai-assess/assets/assessment.md` |
| ref | `skills/fast-track-ai-intent/assets/ref.md` |
| decision | `skills/fast-track-ai-spec/assets/decisions.md` |

Init will own only directory creation, the managed AGENTS block, and index generation. Cross-skill consumers will use package-relative paths to the owner copy. The old init-owned assessment and ref templates will be removed after every consumer and evaluation fixture is migrated.

Alternative considered: a shared templates directory. Rejected by the repository rule that every script and template has one owner and no shared link.

### 4. Internalize procedures, not upstream implementations

`fast-track-ai-research` and `fast-track-ai-handoff` will contain complete package procedures and use their package-owned templates. `fast-track-ai-assess` will contain the complete inward-evaluation procedure. Upstream work informs the procedures but is not invoked, vendored, or imported at runtime.

Research procedure:

1. State the question and acceptance boundary.
2. Prefer primary sources and retrieve the source itself rather than relying on a search result snippet.
3. Tie material claims to citations.
4. Report conflicts, single-source dependence, freshness concerns, inference, and limitations.
5. Write one durable result directly to `fast-track-ai/research/` and regenerate the index.

Assessment procedure:

1. Freeze the target and scope so evaluation remains read-only toward the assessed subject.
2. State criteria before judging evidence.
3. Gather supporting evidence and counterevidence.
4. Produce a defensible conclusion, limitations, and concrete recommendations.
5. Record provider/model identity when delegated and write one result directly to `fast-track-ai/assessments/`.

Handoff procedure:

1. Preserve exact active user instructions and unresolved decisions.
2. Separate verified completed state from P0 and P1 work.
3. Record relevant paths and observed command results without copying durable documents.
4. Remove secrets and unnecessary personal data.
5. Name the first next action, write directly to `fast-track-ai/handoffs/`, and archive beyond the three-file active window.

Alternative considered: declare dependencies on external base skills. Rejected because `install.sh` only installs package skills and cross-machine behavior would remain accidental.

### 5. Use content identity and explicit licensing for refs

The ref template will distinguish:

- `inline`: normalized UTF-8 LF source text stored in the body; hash covers that stored source text, excluding frontmatter and explanatory wrapper text.
- `pointer`: canonical locator plus metadata; hash covers the payload actually observed at capture time, never the locator string.

Required common metadata: `type`, `captured`, `owner`, `sha256`, and `content_license`. A pointer also requires `source`. It requires `pin` when the upstream exposes an immutable identifier; otherwise it requires `retrieved_at`. The body records how the hash was obtained and any inability to retrieve the full source.

The source representation and identity fields remain immutable. Schema-only metadata may be enriched during this migration without changing source identity or hash. Changed source bytes require a new ref. Before creating a ref, intent compares hashes and reuses an existing match.

If the source remains inaccessible after one direct request for the URL, file, or text, intent creates no ref. It records the missing basis as an open question or explicit assumption.

Alternative considered: hash the whole Markdown ref. Rejected because metadata corrections would change identity even when the represented source did not.

### 6. Preserve research evidence in the project tree

The exploration research is captured at `fast-track-ai/research/artifact-standards.md` under the current research contract. Implementation will migrate it to the new status-free contract while preserving the evidence matrix below and its independently adopted concepts. The user-supplied Jhony Walker article will be captured separately as a pointer ref because it is a basis source, not package-produced research.

#### Eligible procedural sources

| Source | Use | Verified license |
|---|---|---|
| [Matt Pocock handoff](https://github.com/mattpocock/skills/blob/main/skills/productivity/handoff/SKILL.md) and [research](https://github.com/mattpocock/skills/blob/main/skills/engineering/research/SKILL.md) | Minimal direct workflows, durable file, primary sources | [MIT](https://github.com/mattpocock/skills/blob/main/LICENSE) |
| [cablate ai-toolkit handoff](https://github.com/cablate/ai-toolkit/blob/master/skills/handoff/SKILL.md) | P0/P1 ordering, exact user instructions, pitfalls | [MIT](https://github.com/cablate/ai-toolkit/blob/master/LICENSE) |
| [B143KC47 deep-research-skill](https://github.com/B143KC47/deep-research-skill/blob/main/deep-research/SKILL.md) | Claim/evidence discipline, conflicts, stale and single-source labels | [MIT](https://github.com/B143KC47/deep-research-skill/blob/main/LICENSE) |
| [GitHub Spec Kit analyze](https://github.com/github/spec-kit/blob/main/templates/commands/analyze.md) and [assess](https://github.com/github/spec-kit/blob/main/extensions/assess/README.md) | Evidence, counterevidence, severity, limits, defensible verdict | [MIT](https://github.com/github/spec-kit/blob/main/LICENSE) |
| [OpenSpec verify-change](https://github.com/Fission-AI/OpenSpec/blob/main/skills/openspec-verify-change/SKILL.md) | Completeness, correctness, coherence | [MIT](https://github.com/Fission-AI/OpenSpec/blob/main/LICENSE) |
| [OKF Wiki capture](https://github.com/jotafurtado/okf-wiki-skills/blob/main/skills/okf-wiki-capture/SKILL.md) | Content identity, canonical source, immutable changed bytes, duplicate detection | [Apache-2.0](https://github.com/jotafurtado/okf-wiki-skills/blob/main/LICENSE) |
| [MADR](https://github.com/adr/madr) | Compact ADR structure and consequences | [MIT OR CC0-1.0](https://github.com/adr/madr/blob/main/LICENSE) |
| [wshobson architecture-decision-records](https://github.com/wshobson/agents/tree/main/plugins/documentation/skills/architecture-decision-records) | ADR trigger and lifecycle concepts | [MIT](https://github.com/wshobson/agents/blob/main/LICENSE) |

#### Citation-only sources

| Source | Constraint |
|---|---|
| [Joel Parker Henderson architecture_decision_record](https://github.com/joelparkerhenderson/architecture-decision-record) | CC BY-NC-SA 4.0; pointer and independently expressed concepts only |
| [Jhony Walker ADR article](https://medium.com/@jhonywalkeer/guia-completo-sobre-architecture-decision-records-adr-defini%C3%A7%C3%A3o-e-melhores-pr%C3%A1ticas-f63e66d33e6) | No explicit reuse license found; pointer only with `content_license: unknown` |

Firecrawl deep-research is excluded because its ISC license does not meet the user's MIT-or-Apache source constraint.

### 7. Keep ADRs accepted-only and reconcile planning drift

The existing ADR shape remains intentionally small. The template gains optional evidence/ref citations. Intent gains the same qualifying-decision rule already present in spec and implementation. No `proposed` status is added.

During implementation, a qualifying decision that does not alter approved scope can be recorded and work can continue. A decision that conflicts with or materially changes approved spec or tasks triggers a pause, updates to ADR/spec/tasks, and renewed approval before implementation resumes.

Implementation will also record the maintainer's accepted choice to add `fast-track-ai-assess` as a new ADR. It will cite the earlier track 002 rationale rather than claim an existing ADR was superseded when none exists.

Alternative considered: let ADRs silently override approved plans. Rejected because it creates two competing sources of implementation scope.

### 8. Generate one deterministic index with six sections

The index will keep the track table and add or retain one table for each supporting artifact type: refs, research, assessments, decisions, and active handoffs. Rows will be sorted by stable filename or identifier. Archived handoffs remain outside the active table.

The validator will enforce each artifact contract before reporting success. It will write the complete deterministic index and still return nonzero when validation errors exist, preserving the current diagnostic behavior. Evals will compare repeated output and cover valid and invalid examples for every type.

Alternative considered: a separate index per artifact type. Rejected because agents are explicitly instructed to begin with one `INDEX.md`.

## Risks / Trade-offs

- [Research and ref schema changes invalidate existing artifacts] → Migrate repository-owned research, assessment, and ref metadata in the same task before enabling stricter validation.
- [Hash semantics can drift between human and script] → Put the canonical byte rules in the ref template and eval fixed fixtures with known digests.
- [A comprehensive index becomes noisy] → Keep columns minimal and exclude archived handoffs; details remain in the artifact files.
- [Assessment becomes another mandatory gate] → Keep it explicitly invoked and input-only; intent may cite it but does not require one.
- [Source attribution can become stale] → Store retrieval date and exact license URL in the durable research artifact.
- [Instructions may accidentally reproduce restricted text] → Use eligible sources for procedural wording and retain restricted sources only as citations or pointers.
- [Existing consumers parse the old index layout] → Treat the index layout as a documented breaking change and update all package evals atomically.

## Migration Plan

1. Add the assess command, skill, owner template, and focused eval fixtures.
2. Add package-owned research and handoff templates; replace external runtime calls with complete local procedures.
3. Move ref and assessment template ownership, update all relative consumers, and remove obsolete owner copies.
4. Update intent, spec, and implementation decision/ref behavior; add the dedicated-assessment ADR.
5. Migrate the artifact-standards research and other repository-owned artifacts to the new metadata contract, then capture the Jhony Walker pointer ref.
6. Expand index validation and rendering for all five types, update the managed AGENTS guidance, and regenerate `fast-track-ai/INDEX.md`.
7. Run isolated package evals in `/tmp`, verify installation exposes seven skills, run init twice, and verify repeated index output is byte-identical.

Rollback is a source revert of the package changes and regenerated index. Newly created research, ref, and ADR files are durable evidence and should be retained or explicitly reverted with the same change rather than silently deleted.

## Verification Reconciliation

The ref capture workflow is procedural rather than an executable writer. Deduplication occurs before a new ref is written: intent compares the candidate content hash, reuses the existing slug, and cites that slug. The indexer separately rejects duplicate hashes that already exist on disk, providing an integrity postcondition rather than replacing the pre-write reuse step.

Mutable pointer changes preserve the existing ref and require a new ref for the newly observed payload. ADR replacement preserves the original decision content, changes its status to `superseded`, records `superseded_by`, and creates a replacement ADR. Follow-up fixtures must exercise these boundaries explicitly.
