<!-- Sync Impact Report:
Version change: none → 1.0.0 (initial ratification)
Modified principles: none (all sections new)
Added sections: Core Principles I–V, Additional Constraints, Development Workflow, Governance
Removed sections: none
Follow-up TODOs: none
-->

# dot-ai Constitution

## Core Principles

### I. Surgical Changes
Every change delivers exactly one behavior. A change MUST be validated in `/tmp` before commit, following the Validation block in `AGENTS.md`. Incidental refactoring, adjacent reformatting, and speculative abstraction are forbidden.

### II. No Stubs
A published script MUST actually run. Every script under `skills/` MUST pass `bash -n` and the end-to-end `/tmp` test: init, index, gate. Placeholders, mocks, and `TODO: implement` MUST NOT be committed.

### III. Package Portability (NON-NEGOTIABLE)
The method MUST work on any machine. Machine-fixed paths are forbidden. Skills MUST resolve scripts and templates relative to their installed package location; the `shared` link is load-bearing and every installation MUST include it via `install.sh`. Target repos receive only the `dot-ai/` data tree, never vendored method internals.

### IV. Gate-Locked Flow
Work MUST follow intent → plan → implement, with user approval at each gate. No approved intent means no `plan.md`, no `spec/`, no code. No approved plan means no implementation. Locks have no exceptions and MUST be encoded in the skills, not left to agent discretion. Track roots MUST contain only allowlisted entries; auxiliary outputs MUST live under `assets/`.

### V. Validation Before Yield
No work yields green without proof: syntax checks on all touched scripts, fresh `init` in `/tmp`, `index` pass, and gate FAIL/PASS states exercised for the changed path. A FAIL state that is not demonstrated is treated as untested.

## Additional Constraints

Stack: POSIX bash plus `grep`, `sed`, `awk` only; no new runtime dependencies. Code identifiers, folders, files, and frontmatter fields MUST be English. All user-facing prose — commands, skills, error messages — MUST be English. The `via` enum values (`rapida`, `completa`) are frozen identifiers shared with existing tracks and MUST NOT be renamed without a track migration. A live target project MUST NEVER be edited from this repo.

## Development Workflow

Method changes validate in `/tmp`, never in a live target. `init` MUST be idempotent: repeated runs produce no error and no duplicated managed blocks. Reviews MUST verify constitution compliance, gate behavior on both PASS and FAIL paths, and English-only user-facing text. Complexity MUST be justified against the boring-option default.

## Governance

This constitution governs Spec Kit runtime usage in this repo and supersedes ad-hoc practices. The method design itself is governed by the binding norm in Obsidian (`10 - Projetos/Code/dot-ai/dot-ai - Fundamentos v1.2.md`); conflicts between the two MUST be raised to the user before proceeding. Amendments require documentation, explicit user approval, and a migration plan for existing tracks when identifiers change. Versioning follows semantic versioning: MAJOR for incompatible governance or principle removals, MINOR for new principles or sections, PATCH for clarifications. Compliance is verified on every review via the Validation block.

**Version**: 1.0.0 | **Ratified**: 2026-09-15 | **Last Amended**: 2026-09-15
