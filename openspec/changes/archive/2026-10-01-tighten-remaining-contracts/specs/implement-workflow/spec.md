## ADDED Requirements

### Requirement: Review procedure is self-contained
The implement skill SHALL carry the complete review procedure: principles, phases, severities, and the fix loop. It SHALL state that `fast-track-ai/refs/code-review-skill` names only the provenance of the approach. It SHALL state that the consuming project does not need that ref, and that the review runs the same way whether or not the ref exists.

#### Scenario: Consumer without the ref
- **WHEN** implement reaches review in a target repository with no `fast-track-ai/refs/code-review-skill`
- **THEN** the skill runs the full review from its own text and does not stop, fetch, or create the ref

#### Scenario: Skill text marks provenance
- **WHEN** the implement skill is inspected
- **THEN** it names `fast-track-ai/refs/code-review-skill` as provenance only and states that the consuming project does not need it
