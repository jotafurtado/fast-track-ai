# Decisions: 005-lightweight-sdlc

## 001-spec-md-owner
Context: The catalog adds a required thin `spec.md` without adding a seventh skill.
Decision: `fast-track-ai-intent` owns `assets/spec.md`. After intent approval it drafts `spec.md` and stops. `fast-track-ai-plan` requires that file and does not write it.
Consequence: The specify wrapper is replaced by a spec draft inside the intent skill, not by a new command.

## 002-historical-spec-dir
Context: `001-skill-standards` already has a Spec Kit `spec/` tree. The new gate must not treat `spec/` as a second cycle.
Decision: `spec/` is allowed as a historical leftover and never selects a cycle. Authority is always track-root `spec.md`, `plan.md`, and `tasks.md`. Track `001` receives a thin root `spec.md` that points at the frozen `spec/` directory.
Consequence: Existing `spec/plan.md` and `spec/tasks.md` are not executed.

## 003-live-evals-vs-frozen-spec
Context: The only executable package suite lives under `001-skill-standards/spec/assets/run-evals.sh` and `spec/evals.md`. The intent freezes that spec as historical.
Decision: Leave `spec.md`, `audit.md`, `plan.md`, `tasks.md`, `research.md`, `data-model.md`, and related 001 prose frozen. Update `run-evals.sh` and the `evals.md` selector table because they are live package tests, not historical narrative. Replace the `specify` selector with a `spec.md` cycle selector.
Consequence: 001 prose and the live runner may disagree. The runner is the package contract.

## 004-drop-vendored-speckit
Context: This repo vendors Spec Kit under `.specify/` and exposes `specs -> dot-ai/specs`.
Decision: Remove the Spec Kit integration and the vendored `.specify/` tree from this repo. Move any still-live constitution rules into the managed AGENTS block. Drop the constitution eval that reads `.specify/memory/constitution.md`.
Consequence: Init and evals no longer mention `.specify` or `specs/`.
