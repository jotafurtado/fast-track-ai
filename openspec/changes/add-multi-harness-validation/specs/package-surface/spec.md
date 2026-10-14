# Spec Delta

## ADDED Requirements

### Requirement: Generic installed skills resolve executable resources
The deterministic installation evaluation SHALL verify the published skills through installed `.agents/skills` entries and Claude mirrors in disposable default and custom installation layouts. It SHALL verify readable skill metadata and every owned template, exercise cross-skill sibling resource resolution, and run the bundled init, index, and gate scripts through installed locations against disposable target repositories. It SHALL require no authenticated model or executable harness and SHALL not modify a live consumer project or the maintainer's real home directory.

#### Scenario: Installed resources execute successfully
- **WHEN** the package is installed into a disposable `.agents/skills` directory with Claude mirrors
- **THEN** all seven skills and their resources resolve, init is idempotent, index produces the expected target index, and the gate accepts a valid approved closed track through installed resource paths

#### Scenario: Installed sibling dependency is broken
- **WHEN** an installed cross-skill sibling resource cannot be resolved or executed in the disposable fixture
- **THEN** installation validation fails with the affected location instead of passing from the number of links alone

#### Scenario: Generic layout is not an executable harness
- **WHEN** generic `.agents` installation validation passes
- **THEN** the reported result identifies installation and resource compatibility without claiming real-agent behavior for an unnamed harness
