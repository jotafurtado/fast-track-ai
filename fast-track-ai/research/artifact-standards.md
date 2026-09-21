---
captured: 2026-09-20
owner: maintainer
---

# Research: Supporting artifact standards

## Question

How should fast-track-ai simplify and standardize its five supporting artifact types while remaining self-contained, portable across agents, and legally safe to distribute?

The five artifact types are:

1. Handoff
2. Ref
3. Assessment
4. Research
5. Decision (ADR)

## Scope

This research evaluated:

- Current behavior in the fast-track-ai repository.
- External skills and practices that can inform each artifact workflow.
- License compatibility under the maintainer's MIT-or-Apache source constraint.
- The smallest coherent user-facing workflow.
- How refs, research, assessments, ADRs, handoffs, and `INDEX.md` should interact.

The research does not select a license for the fast-track-ai repository itself.

## Conclusion

Fast-track-ai should keep all five artifact types but expose only three explicit actions:

- `research`: investigate external facts.
- `assess`: evaluate a project, implementation, feature, or idea.
- `handoff`: transfer active working context.

Two artifact types should be captured automatically inside the workflows that consume them:

- `ref`: capture a material user-supplied basis during intent.
- `decision`: capture a qualifying accepted decision during intent, spec, or implementation.

The package should add a seventh skill, `fast-track-ai-assess`. Research, assessment, and handoff should use package-owned instructions and templates. They must not depend at runtime on separately installed third-party skills.

`fast-track-ai/INDEX.md` should remain the single discovery entry point and eventually list tracks plus refs, research, assessments, decisions, and active handoffs. Archived handoffs should remain excluded from the active view.

## Current repository evidence

### Handoff

`skills/fast-track-ai-handoff/SKILL.md` invokes a base `handoff` skill, expects output in the operating-system temporary directory, and then copies it into `fast-track-ai/handoffs/`.

The package installer links only `skills/fast-track-ai-*`. It does not install the base skill. Therefore handoff behavior currently depends on unrelated machine state.

### Research

`skills/fast-track-ai-research/SKILL.md` invokes a base `research` skill and requires singular `source`, `captured`, `status: raw`, and `owner` frontmatter.

The singular source field cannot represent multi-source research without losing claim-level provenance. The single raw status has no lifecycle transition and therefore adds no useful state.

### Assessment

Assessment currently has an init-owned template at `skills/fast-track-ai-init/assets/assessment.md`, but no dedicated command or skill. The template only provides Conclusion and Findings, so it does not require criteria, counterevidence, limitations, recommendations, or evaluator identity.

Track 002 previously avoided a seventh skill. The maintainer has now explicitly selected a dedicated `fast-track-ai-assess` skill because model-independent invocation and consistent evidence requirements outweigh the extra skill entry.

### Ref

Refs currently support `inline` and `pointer`, require SHA-256, have a 500 KB limit, and are immutable. Gaps remain:

- Hash semantics are not precise.
- Pointer pins are required even when the source offers no immutable version.
- Content licensing is not recorded.
- Inaccessible sources are not handled.
- Mutable pages and duplicate source content are not handled.
- The template is owned by init although intent writes refs.

### Decision

The ADR template already has a compact useful structure: Context, Decision, Rationale, Alternatives considered, and Consequences. ADRs use only `accepted` and `superseded` status.

Spec and implementation can create ADRs, but intent only cites existing ADRs. This delays durable decisions made while defining the request. Implementation also lacks an explicit rule for reconciling a new ADR that changes approved spec or tasks.

### Index

`skills/fast-track-ai-init/scripts/fast-track-ai-index.sh` currently:

- Lists tracks, assessments, and decisions.
- Validates refs without listing them.
- Validates research only by checking `owner` and does not list it.
- Does not validate or list handoffs.

The managed AGENTS block tells agents to read `fast-track-ai/INDEX.md` first and never scan the whole tree. Omitting three artifact classes therefore makes the prescribed discovery path incomplete.

## Recommended artifact contracts

### Handoff

Purpose: portable active context for the next session, model, or harness.

Required behavior:

- Preserve exact active user instructions.
- State objective and verified current state.
- Separate completed work, P0 actions, and P1 actions.
- Record relevant paths and observed command results.
- State blockers, risks, unresolved decisions, and the first next action.
- Reference durable artifacts by path instead of duplicating them.
- Remove secrets and unnecessary personal data.
- Keep the three newest handoffs active and archive older files.
- Write directly to `fast-track-ai/handoffs/` without a base skill.

Recommended owner template: `skills/fast-track-ai-handoff/assets/handoff.md`.

### Ref

Purpose: immutable representation or locator for a source that materially grounds an intent.

Required behavior:

- `inline`: use when exact text is needed offline, the captured representation is no larger than 500 KB, and repository storage is licensed.
- `pointer`: use for large, binary, stable upstream, restricted, or unknown-license content.
- Common metadata: `type`, `captured`, `owner`, `sha256`, and `content_license`.
- Pointer metadata: canonical `source`; `pin` when upstream offers an immutable identifier; otherwise `retrieved_at`.
- Inline hash: normalized UTF-8 LF source text stored in the body, excluding frontmatter and wrapper text.
- Pointer hash: payload observed at capture time, never the URL, path, or descriptive stub.
- Reuse an existing ref when source content has the same hash.
- Create a new ref when represented source bytes change.
- Allow schema-only metadata enrichment without changing source identity.
- If the source remains inaccessible after one direct request for URL, file, or text, create no synthetic ref and record the missing basis as an open question or explicit assumption.

Recommended owner template: `skills/fast-track-ai-intent/assets/ref.md`.

### Assessment

Purpose: evidence-backed inward evaluation of the project, implementation, feature, or idea.

Required behavior:

- Explicit user action through `fast-track-ai-assess`.
- Keep the assessed target read-only.
- State scope and criteria before reaching a verdict.
- Record evaluator provider/model when delegated.
- Include Conclusion, Scope and basis, Criteria, Findings, Evidence against conclusion, Limitations, and Recommendations.
- Use evidence and counterevidence rather than a mandatory generic scorecard.
- Keep assessments status-free.
- Cite later intents through `assessments:`, never `research:`.

Recommended owner template: `skills/fast-track-ai-assess/assets/assessment.md`.

### Research

Purpose: investigate external facts before a decision.

Required behavior:

- State the question and acceptance boundary.
- Prefer primary sources.
- Read source content rather than relying on search snippets.
- Cite material claims directly.
- Distinguish observed fact from inference.
- Report credible conflicts, stale evidence, single-source dependence, and limitations.
- Keep sources in the body so one artifact can cite multiple sources.
- Produce one status-free file in `fast-track-ai/research/`.
- Run without a base research skill.

Recommended owner template: `skills/fast-track-ai-research/assets/research.md`.

### Decision (ADR)

Purpose: preserve an accepted durable choice and its trade-offs.

A decision qualifies when it is:

- Durable.
- Costly to reverse.
- Surprising without context.
- A resolution of a meaningful trade-off.

Required behavior:

- Capture qualifying accepted decisions during intent, spec, and implementation.
- Keep only `accepted` and `superseded` status.
- Preserve Context, Decision, Rationale, Alternatives considered, and Consequences.
- Allow optional evidence and ref citations.
- Do not create ADRs for local, obvious, or easily reversible choices.
- During implementation, pause and reconcile ADR, spec, and tasks when a new decision materially changes approved planning. Require renewed approval before continuing.
- Supersede rather than rewrite a replaced decision.

Recommended owner template: `skills/fast-track-ai-spec/assets/decisions.md`.

## Recommended ownership model

| Artifact | Writer | Template owner |
|---|---|---|
| Handoff | `fast-track-ai-handoff` | `fast-track-ai-handoff` |
| Research | `fast-track-ai-research` | `fast-track-ai-research` |
| Assessment | `fast-track-ai-assess` | `fast-track-ai-assess` |
| Ref | `fast-track-ai-intent` | `fast-track-ai-intent` |
| Decision | intent, spec, or implement | `fast-track-ai-spec` |

Init should own directory creation, the managed AGENTS block, and index generation only. Cross-skill consumers should reference the owner copy through package-relative paths. No shared resource directory is needed.

## Sources and license evaluation

### Eligible procedural sources

| Source | Relevant contribution | License evidence | Retrieved | Compatibility result |
|---|---|---|---|---|
| [Matt Pocock handoff](https://github.com/mattpocock/skills/blob/main/skills/productivity/handoff/SKILL.md) | Minimal handoff, temporary capture, path references, redaction | [MIT](https://github.com/mattpocock/skills/blob/main/LICENSE) | 2026-09-20 | MIT-compatible |
| [Matt Pocock research](https://github.com/mattpocock/skills/blob/main/skills/engineering/research/SKILL.md) | Background investigation, primary sources, one cited Markdown result | [MIT](https://github.com/mattpocock/skills/blob/main/LICENSE) | 2026-09-20 | MIT-compatible |
| [cablate ai-toolkit handoff](https://github.com/cablate/ai-toolkit/blob/master/skills/handoff/SKILL.md) | P0/P1 actions, exact user instructions, pitfalls | [MIT](https://github.com/cablate/ai-toolkit/blob/master/LICENSE) | 2026-09-20 | MIT-compatible |
| [B143KC47 deep-research-skill](https://github.com/B143KC47/deep-research-skill/blob/main/deep-research/SKILL.md) | Claim/evidence discipline, conflicts, stale and single-source labels | [MIT](https://github.com/B143KC47/deep-research-skill/blob/main/LICENSE) | 2026-09-20 | MIT-compatible |
| [GitHub Spec Kit analyze](https://github.com/github/spec-kit/blob/main/templates/commands/analyze.md) | Read-only consistency analysis and severity | [MIT](https://github.com/github/spec-kit/blob/main/LICENSE) | 2026-09-20 | MIT-compatible |
| [GitHub Spec Kit assess](https://github.com/github/spec-kit/blob/main/extensions/assess/README.md) | Intake, evidence, counterevidence, limits, and defensible verdict | [MIT](https://github.com/github/spec-kit/blob/main/LICENSE) | 2026-09-20 | MIT-compatible concepts; full five-file pipeline rejected as excessive |
| [OpenSpec verify-change](https://github.com/Fission-AI/OpenSpec/blob/main/skills/openspec-verify-change/SKILL.md) | Completeness, correctness, and coherence | [MIT](https://github.com/Fission-AI/OpenSpec/blob/main/LICENSE) | 2026-09-20 | MIT-compatible |
| [OKF Wiki capture](https://github.com/jotafurtado/okf-wiki-skills/blob/main/skills/okf-wiki-capture/SKILL.md) | Content identity, canonical URL, immutable changed bytes, duplicate detection, and capture verification | [Apache-2.0](https://github.com/jotafurtado/okf-wiki-skills/blob/main/LICENSE) | 2026-09-20 | Apache-2.0-compatible |
| [MADR](https://github.com/adr/madr) | Compact ADR structure, alternatives, and consequences | [MIT OR CC0-1.0](https://github.com/adr/madr/blob/main/LICENSE) | 2026-09-20 | MIT-compatible through the MIT option |
| [wshobson architecture-decision-records](https://github.com/wshobson/agents/tree/main/plugins/documentation/skills/architecture-decision-records) | ADR triggers and lifecycle concepts | [MIT](https://github.com/wshobson/agents/blob/main/LICENSE) | 2026-09-20 | MIT-compatible |

### Citation-only or excluded sources

| Source | License finding | Classification | Treatment |
|---|---|---|---|
| [Joel Parker Henderson architecture_decision_record](https://github.com/joelparkerhenderson/architecture-decision-record) | CC BY-NC-SA 4.0 | Citation-only | Cite and express concepts independently. Do not adapt protected text into MIT or Apache package instructions. |
| [Jhony Walker, Guia Completo sobre Architecture Decision Records (ADR): Definição e Melhores Práticas](https://medium.com/@jhonywalkeer/guia-completo-sobre-architecture-decision-records-adr-defini%C3%A7%C3%A3o-e-melhores-pr%C3%A1ticas-f63e66d33e6) | No explicit reuse license found | Citation-only | Capture as a pointer with `content_license: unknown`. Do not copy the article into package instructions. |
| Firecrawl deep-research | ISC | Excluded | Do not use procedurally because the maintainer required MIT or Apache-2.0-compatible sources. |

## License interpretation

CC BY-NC-SA 4.0 permits third parties to share and adapt content with attribution, noncommercial use, and ShareAlike licensing. It does not permit relicensing an adaptation as MIT or Apache-2.0. Linking to or citing the source does not impose that license on the surrounding repository, but copying or adapting protected expression would carry its restrictions.

Creative Commons does not recommend CC licenses for software. CC BY-NC-SA is also not considered an open-source software license because of its noncommercial restriction.

Therefore the Joel Parker Henderson repository and the unlicensed Jhony Walker article can inform independent reasoning and be cited, but they must not supply adapted package wording.

## Decisions reached

- Keep all five artifact types.
- Add the seventh skill `fast-track-ai-assess`.
- Keep only research, assessment, and handoff as explicit user actions.
- Capture refs and ADRs automatically in the workflows that consume them.
- Remove runtime dependency on external research and handoff skills.
- Keep ADR status limited to accepted and superseded.
- List and validate every active artifact type through one deterministic INDEX.
- Exclude the repository's own license selection from this change.

## Implementation implications

The approved OpenSpec change is `openspec/changes/standardize-method-artifacts/`.

Its implementation needs to:

1. Add `fast-track-ai-assess` and its command/template.
2. Internalize research and handoff procedures.
3. Move ref and assessment template ownership.
4. Update intent, spec, and implementation ADR behavior.
5. Capture the Jhony Walker article as a pointer ref.
6. Record the dedicated assessment skill as an accepted ADR.
7. Expand the index generator and managed AGENTS guidance.
8. Update `/tmp` eval fixtures for seven skills and all five artifact contracts.

## Conflicts

No credible source conflict was found about the procedural recommendations. The legal permissions differ by source, so incompatible, noncommercial, unknown, and out-of-policy licenses are classified as citation-only or excluded rather than treated as reusable procedure.

## Limitations

- License findings are based on the upstream license files observed during this research and can change upstream.
- The Jhony Walker Medium article exposes no explicit reuse license in the captured material. `unknown` is the conservative classification.
- This is technical process and license compatibility research, not legal advice.
- The current index generator validates research but does not list it. Listing research requires the approved implementation change rather than a manual edit to generated `INDEX.md`.
