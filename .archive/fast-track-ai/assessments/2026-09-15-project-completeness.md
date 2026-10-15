---
captured: 2026-09-15
owner: maintainer
scope: dot-ai method package
evaluator: original assessment agent (provider/model not recorded)
tracks: []
---

# Project Completeness Assessment

## Conclusion

The project is not complete enough to declare version 1.0. The short cycle works on its nominal path, but the complete Spec Kit cycle, structural gates, installation portability, and regression evidence still have blocking gaps.

## Scope and basis

The assessment evaluated the repository-owned method package, its six installed skills, shell scripts, templates, structural gates, installer behavior, and executable evidence available on 2026-09-15. It excluded the unreadable binding Obsidian norm and did not implement the findings except for the initializer conflict fix recorded below.

## Criteria

- Published scripts are syntactically valid and executable.
- Installation and initialization are portable and idempotent.
- Planning approval and lifecycle state are durable and reconstructable.
- Structural gates reject invalid track states.
- Package contracts, ownership, and installed dependencies agree.
- Regression evidence is executable and repeatable.

## Findings

### Verified Strengths

- All published shell scripts pass `bash -n` and are executable.
- The installer links all six skills into a custom agents directory.
- Cross-skill owner-copy references resolve after agents installation.
- Initialization is idempotent on a clean repository.
- The managed AGENTS block is not duplicated on a second initialization.
- The index renders a valid active track.
- The short-cycle gate fails on open tasks and passes after completion.
- Initialization now rejects a conflicting `specs` path before changing the target.

### Critical Findings

### Complete Cycle Does Not Reach the Track Spec

`dot-ai-specify.sh` emits `/speckit-specify`, while the installed OMP integration uses `/speckit.specify`. The wrapper does not set `SPECIFY_FEATURE_DIRECTORY`, so Spec Kit defaults to the public `specs/` path instead of the canonical `dot-ai/tracks/<track>/spec/` path. No skill currently invokes the wrapper, and the planning skill does not branch on `via: completa` before creating a short-cycle plan.

### Structural Gate Accepts Invalid States

The gate checks that an intent contains a `status` field but does not require `status: active`. A draft short-cycle track passed during verification. For a complete-cycle track, the gate returns PASS as soon as `spec/spec.md` exists and does not inspect `spec/tasks.md`; a track with open full-cycle tasks also passed.

### Approval Is Not Durable

The implementation skill requires approved plan and task artifacts, but the templates contain no approval state or marker. Approval therefore depends on conversational context and cannot be reconstructed reliably in a later session.

### High-Priority Findings

### Custom Claude Installation Produces Broken Links

When `--agents-dir` and `--claude-dir` are customized, `install.sh` still points Claude mirrors at `../../.agents/skills`. All six Claude links were broken in the isolated verification scenario, although the agents links worked.

### Constitution Contradicts the Package Layout

The constitution still says the removed `shared` link is mandatory. The implemented package and the current feature specification require per-skill owner copies and no `shared` directory.

### Skill Audit Is Not Evidence-Complete

The audit records aggregate statements such as `PASS all 6` instead of one verdict and evidence quote per rule and skill. It contains six evidence mentions, while the declared six-by-six audit requires at least 36 individual records. The documented lowercase `grep -c evidence` check also fails against the current capitalization.

### Evals Are Not Executable Regressions

The eval document records past results in prose. It does not provide executable prompts, assertions, with-skill runs, baselines, or persisted benchmark output as described by the current skill-creator workflow.

### Medium-Priority Findings

- The index accepts an invalid `via` value instead of enforcing `rapida | completa`.
- Research validation checks only `owner`, not `source`, `captured`, and `status: raw`.
- The managed AGENTS block is not upgraded when package rules change.
- The package contract both forbids and requires sibling owner paths such as `../dot-ai-init/...`.
- `assets/decisions.md` and `dot-ai-specify.sh` are not consumed by their owner skills.
- The package creates `assessments/` but has no assessment workflow.
- There is no durable procedure for moving tracks to `shipped`, `dropped`, or `superseded`.
- External base-skill dependencies are neither declared nor checked by the installer.
- Slash command wrappers are part of the declared package map but are not installed by `install.sh`.

### Resolved During This Assessment

The initializer previously returned success when a real `specs/` directory already existed, then created a separate `dot-ai/specs/` root. It now performs a preflight before any target write:

- a missing `specs` path is accepted;
- the canonical `specs -> dot-ai/specs` symlink is accepted;
- a real directory, file, or unexpected symlink is rejected;
- conflicting content remains unchanged;
- no `dot-ai/` tree or AGENTS block is created on failure.

## Evidence against conclusion

The nominal short cycle worked, all published shell scripts passed syntax checks, custom agents installation resolved its skill links, initialization was idempotent, the managed block remained singular, the index rendered an active track, and the short-cycle gate distinguished open from completed tasks. The initializer conflict behavior was also corrected during the assessment. These strengths reduce local risk but do not remove the blocking complete-cycle, durable-approval, portability, and regression-evidence gaps supporting the conclusion.

## Recommendations

1. Route the complete cycle from active intent to the canonical track spec.
2. Validate active status, durable approval, and open full-cycle tasks in the gate.
3. Fix custom Claude links and declare or install runtime dependencies.
4. Reconcile the constitution and package path contract with owner-copy layout.
5. Replace aggregate audit claims with per-skill evidence.
6. Make deterministic evals executable and repeatable.
7. Validate all required frontmatter and frozen enums.
8. Define assessment and terminal track-state workflows.
9. Re-run the full clean, conflict, short-cycle, and complete-cycle scenarios in `/tmp`.

## Limitations

The binding Obsidian norm referenced by `AGENTS.md` was not readable during this assessment because the operating system denied access. This does not change the conclusion because the repository's own contracts already contain reproducible failures.
