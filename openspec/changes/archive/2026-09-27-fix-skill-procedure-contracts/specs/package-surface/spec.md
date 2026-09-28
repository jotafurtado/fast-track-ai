# Spec Delta

## MODIFIED Requirements

### Requirement: Live evals cover the continuous-flow protocol
The executable eval runner SHALL include a selector that fails unless the published intent, spec, and implement skills plus the tasks template contain the continuous-flow protocol strings: `. para continuar com a spec`, `. para implementar`, `. para ship`, `## Group`, and `(depends:`. The same selector SHALL fail if the intent skill contains the retired line `Track concluida. Nenhuma implementacao necessaria.`.

#### Scenario: Flow selector passes on the live package
- **WHEN** `run-evals.sh flow` runs against the repository
- **THEN** it exits 0 after asserting those strings in the owner skills and tasks template and the absence of the retired line

#### Scenario: Missing next-step line fails
- **WHEN** the intent skill no longer contains `. para continuar com a spec`
- **THEN** the flow selector exits non-zero

#### Scenario: Retired exit line reappears
- **WHEN** the intent skill contains `Track concluida. Nenhuma implementacao necessaria.`
- **THEN** the flow selector exits non-zero
