#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
mode="${1:-all}"
work="$(mktemp -d "${TMPDIR:-/tmp}/fast-track-ai-skill-standards.XXXXXX")"
trap 'rm -rf "$work"' EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

pass() {
  echo "PASS: $1"
}

assert_file() {
  [ -f "$1" ] || fail "missing file: $1"
}

assert_not_file() {
  [ ! -e "$1" ] || fail "unexpected file: $1"
}

assert_dir() {
  [ -d "$1" ] || fail "missing directory: $1"
}

assert_contains() {
  grep -Fq "$2" "$1" || fail "$1 does not contain: $2"
}

assert_not_contains() {
  if grep -Fq "$2" "$1"; then
    fail "$1 unexpectedly contains: $2"
  fi
}

assert_not_matches() {
  if grep -Eq "$2" "$1"; then
    fail "$1 unexpectedly matches: $2"
  fi
}

expect_failure() {
  label="$1"
  shift
  if "$@" >"$work/failure.out" 2>"$work/failure.err"; then
    fail "$label unexpectedly succeeded"
  fi
}

frontmatter_field() {
  awk -v key="$2" '/^---$/{section++; next} section == 1 && index($0, key ":") == 1 { sub("^[^:]+:[[:space:]]*", ""); print; exit }' "$1"
}
write_intent() {
  root="$1"
  track="$2"
  status="$3"
  mkdir -p "$root/fast-track-ai/tracks/$track"
  cat >"$root/fast-track-ai/tracks/$track/intent.md" <<EOF
---
id: $track
status: $status
research: []
decisions: []
---
EOF
}

write_spec() {
  file="$1"
  status="${2:-approved}"
  mkdir -p "$(dirname "$file")"
  cat >"$file" <<EOF
---
status: $status
---

# Spec

### Phase 1: fixture
Done: fixture done
Files: fixture
Accept: fixture accepted
EOF
}

write_plan() {
  file="$1"
  status="$2"
  cat >"$file" <<EOF
---
status: $status
---

# Plan

Files: fixture
Accept: fixture
EOF
}

write_tasks() {
  file="$1"
  status="$2"
  checkbox="$3"
  cat >"$file" <<EOF
---
status: $status
---

# Tasks

- [$checkbox] T001 Fixture. Files: fixture. Validate: true
EOF
}

write_handoff() {
  file="$1"
  captured="$2"
  focus="$3"
  mkdir -p "$(dirname "$file")"
  cat >"$file" <<EOF
---
captured: $captured
owner: maintainer
focus: $focus
---

# Handoff: $focus

## Objective
Fixture objective.

## Active user instructions, verbatim
> Preserve this exact instruction.

## Current state
Verified fixture state.

## Completed
- Fixture completed.

## P0 next actions
- Fixture P0.

## P1 next actions
- Fixture P1.

## Unresolved decisions
- None.

## Relevant paths and durable artifacts
- fast-track-ai/INDEX.md

## Observed command results
- Fixture command passed.

## Blockers and risks
- None known.

## First next action
Run the next fixture.
EOF
}

write_handoff_new() {
  file="$1"
  captured="$2"
  focus="$3"
  mkdir -p "$(dirname "$file")"
  cat >"$file" <<EOF
---
captured: $captured
owner: maintainer
focus: $focus
---

# Handoff: $focus

## Objective
Fixture objective.

## Active user instructions, verbatim
> Preserve this exact instruction.

## Current state
Verified fixture state.

## Completed
- Fixture completed.

## Next actions
1. Run the next fixture.
2. Then the following step.

## Unresolved decisions
- None.

## Relevant paths and durable artifacts
- fast-track-ai/INDEX.md

## Observed command results
- Fixture command passed.

## Blockers and risks
- None known.
EOF
}

write_handoff_no_actions() {
  file="$1"
  captured="$2"
  focus="$3"
  mkdir -p "$(dirname "$file")"
  cat >"$file" <<EOF
---
captured: $captured
owner: maintainer
focus: $focus
---

# Handoff: $focus

## Objective
Fixture objective.

## Active user instructions, verbatim
> Preserve this exact instruction.

## Current state
Verified fixture state.

## Completed
- Fixture completed.

## Unresolved decisions
- None.

## Relevant paths and durable artifacts
- fast-track-ai/INDEX.md

## Observed command results
- Fixture command passed.

## Blockers and risks
- None known.
EOF
}

init_script="$repo_root/skills/fast-track-ai-init/scripts/fast-track-ai-init.sh"
index_script="$repo_root/skills/fast-track-ai-init/scripts/fast-track-ai-index.sh"
gate="$repo_root/skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh"

run_self() {
  bash -n "$repo_root/install.sh"
  bash -n "$init_script"
  bash -n "$index_script"
  bash -n "$gate"
  assert_not_matches "$repo_root/AGENTS.md" 'fast-track-ai-gate\.sh.*\|\|[[:space:]]*true'
  pass "runner self-check"
}

run_init() {
  target="$work/init-target"
  "$init_script" "$target" >/dev/null
  "$init_script" "$target" >/dev/null

  for directory in research refs handoffs/archive assessments decisions tracks; do
    assert_dir "$target/fast-track-ai/$directory"
  done
  [ ! -e "$target/specs" ] || fail "init created specs/"
  [ ! -e "$target/.specify" ] || fail "init created .specify/"
  [ ! -e "$target/fast-track-ai/specs" ] || fail "init created fast-track-ai/specs"
  [ ! -e "$target/scripts" ] || fail "target received a scripts directory"
  [ ! -e "$target/templates" ] || fail "target received a templates directory"
  [ "$(grep -c 'BEGIN MANAGED BLOCK: fast-track-ai' "$target/AGENTS.md")" -eq 1 ] || fail "managed block is not idempotent"

  leftover="$work/init-leftover-specs"
  mkdir -p "$leftover/specs"
  printf 'keep\n' >"$leftover/specs/sentinel"
  "$init_script" "$leftover" >/dev/null
  assert_file "$leftover/specs/sentinel"
  assert_dir "$leftover/fast-track-ai/tracks"
  refreshed="$work/init-refreshed"
  mkdir -p "$refreshed"
  printf 'USER BEFORE\n<!-- BEGIN MANAGED BLOCK: fast-track-ai. old -->\nold text\n<!-- END MANAGED BLOCK: fast-track-ai -->\nUSER AFTER' >"$refreshed/AGENTS.md"
  printf 'USER BEFORE\n' >"$work/init-expected.md"
  cat "$repo_root/skills/fast-track-ai-init/assets/AGENTS-snippet.md" >>"$work/init-expected.md"
  printf 'USER AFTER' >>"$work/init-expected.md"
  "$init_script" "$refreshed" >/dev/null
  cmp "$work/init-expected.md" "$refreshed/AGENTS.md" || fail "init did not replace only the managed block"
  cp "$refreshed/AGENTS.md" "$work/init-refreshed.before"
  "$init_script" "$refreshed" >/dev/null
  cmp "$work/init-refreshed.before" "$refreshed/AGENTS.md" || fail "init changed an already-current managed block"

  for marker_case in missing-end duplicate out-of-order; do
    malformed="$work/init-$marker_case"
    mkdir -p "$malformed"
    case "$marker_case" in
      missing-end) printf '<!-- BEGIN MANAGED BLOCK: fast-track-ai -->\nbody\n' >"$malformed/AGENTS.md";;
      duplicate) printf '<!-- BEGIN MANAGED BLOCK: fast-track-ai -->\na\n<!-- END MANAGED BLOCK: fast-track-ai -->\n<!-- BEGIN MANAGED BLOCK: fast-track-ai -->\nb\n<!-- END MANAGED BLOCK: fast-track-ai -->\n' >"$malformed/AGENTS.md";;
      out-of-order) printf '<!-- END MANAGED BLOCK: fast-track-ai -->\n<!-- BEGIN MANAGED BLOCK: fast-track-ai -->\n' >"$malformed/AGENTS.md";;
    esac
    cp "$malformed/AGENTS.md" "$work/AGENTS-$marker_case.before"
    expect_failure "init with $marker_case managed markers" "$init_script" "$malformed"
    assert_contains "$work/failure.err" "BEGIN count"
    assert_contains "$work/failure.err" "END count"
    cmp "$work/AGENTS-$marker_case.before" "$malformed/AGENTS.md" || fail "init changed malformed AGENTS.md"
    assert_not_file "$malformed/fast-track-ai"
  done

  symlinked="$work/init-symlink"
  mkdir -p "$symlinked"
  printf 'USER BEFORE\n<!-- BEGIN MANAGED BLOCK: fast-track-ai. old -->\nold text\n<!-- END MANAGED BLOCK: fast-track-ai -->\nUSER AFTER' >"$work/AGENTS-link-target.md"
  ln -s "$work/AGENTS-link-target.md" "$symlinked/AGENTS.md"
  "$init_script" "$symlinked" >/dev/null
  [ -L "$symlinked/AGENTS.md" ] || fail "init replaced symlinked AGENTS.md"
  cmp "$work/init-expected.md" "$symlinked/AGENTS.md" || fail "init did not update symlink target"

  init_skill="$repo_root/skills/fast-track-ai-init/SKILL.md"
  assert_contains "$init_skill" '../fast-track-ai-spec/scripts/fast-track-ai-gate.sh'
  assert_contains "$init_skill" 'yes-or-no question'
  assert_contains "$init_skill" 'assets/legacy/'
  assert_contains "$init_skill" 'assets/legacy/decisions.md'
  assert_contains "$init_skill" 'Do not invent a Done, Files, Accept, Validate, or approval value'

  snippet="$repo_root/skills/fast-track-ai-init/assets/AGENTS-snippet.md"
  assert_not_contains "$snippet" 'Intent autonomy'
  assert_not_contains "$snippet" 'Tasks parallelism'
  assert_not_contains "$snippet" 'Each script and template has one owner skill'
  assert_contains "$snippet" 'status: approved'
  assert_not_contains "$snippet" 'decisions.md'
  assert_contains "$snippet" 'intent, spec, and implement end with a four-bullet summary'

  pass "init"
}

run_index() {
  target="$work/index-target"
  "$init_script" "$target" >/dev/null
  write_intent "$target" "001-example" "draft"
  write_intent "$target" "003-legacy-active" "active"

  inline_hash="$(printf 'inline fixture\n' | shasum -a 256 | awk '{print $1}')"
  cat >"$target/fast-track-ai/refs/inline-source.md" <<EOF
---
type: inline
captured: 2026-09-20
owner: maintainer
sha256: $inline_hash
content_license: MIT
---

# Ref: inline source

## Source content

inline fixture
EOF
  inline_no_separator_hash="$(printf 'inline without separator\n' | shasum -a 256 | awk '{print $1}')"
  cat >"$target/fast-track-ai/refs/inline-no-separator.md" <<EOF
---
type: inline
captured: 2026-09-20
owner: maintainer
sha256: $inline_no_separator_hash
content_license: MIT
---

# Ref: inline without separator

## Source content
inline without separator
EOF
  cat >"$target/fast-track-ai/refs/pinned-source.md" <<'EOF'
---
type: pointer
source: https://example.com/pinned-source
captured: 2026-09-20
owner: maintainer
pin: fixture-v1
sha256: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
content_license: MIT
---

# Ref: pinned source
EOF
  cat >"$target/fast-track-ai/refs/mutable-source.md" <<'EOF'
---
type: pointer
source: https://example.com/mutable-source
captured: 2026-09-20
owner: maintainer
retrieved_at: 2026-09-20T12:00:00Z
sha256: bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
content_license: unknown
---

# Ref: mutable source
EOF
  cat >"$target/fast-track-ai/research/example-research.md" <<'EOF'
---
captured: 2026-09-20
owner: maintainer
---

# Research: example

## Question
What does the fixture prove?

## Conclusion
It proves multi-source, status-free research is indexed.

## Findings
- The [first source](https://example.com/one) and [second source](https://example.com/two) agree.

## Conflicts
None found.

## Limitations
Fixture evidence only.

## Sources
- [First](https://example.com/one), retrieved 2026-09-20.
- [Second](https://example.com/two), retrieved 2026-09-20.
EOF
  cat >"$target/fast-track-ai/assessments/2026-09-20-example-assessment.md" <<'EOF'
---
captured: 2026-09-20
owner: maintainer
scope: fixture
evaluator: fixture/model
tracks: []
---

# Assessment: example

## Conclusion
The fixture conforms.

## Scope and basis
Fixture files only.

## Criteria
- Required schema.

## Findings
- Required fields exist.

## Evidence against conclusion
- None found within the fixture.

## Limitations
- Synthetic fixture.

## Recommendations
- Keep the contract.
EOF
  cat >"$target/fast-track-ai/decisions/001-example-decision.md" <<'EOF'
---
id: 001-example-decision
status: accepted
date: 2026-09-20
owner: maintainer
evidence: []
---

# ADR: 001-example-decision

## Context
Fixture context.

## Decision
Keep the fixture.

## Rationale
It verifies the schema.

## Alternatives considered
None.

## Consequences
The decision is indexed.
EOF
  write_handoff "$target/fast-track-ai/handoffs/2026-09-20-1200--0300-active.md" "2026-09-20T12:00:00-03:00" "active"
  write_handoff "$target/fast-track-ai/handoffs/archive/2026-09-20-1100--0300-archived.md" "2026-09-20T11:00:00-03:00" "archived"

  "$index_script" "$target" >/dev/null
  assert_contains "$target/fast-track-ai/INDEX.md" "| 001-example | draft |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| 003-legacy-active | active |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| inline-source | inline | 2026-09-20 |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| inline-no-separator | inline | 2026-09-20 |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| pinned-source | pointer | 2026-09-20 |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| mutable-source | pointer | 2026-09-20 |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| example-research | 2026-09-20 |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| 2026-09-20-example-assessment | 2026-09-20 |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| 001-example-decision | accepted |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| 2026-09-20-1200--0300-active | 2026-09-20T12:00:00-03:00 |"
  assert_not_contains "$target/fast-track-ai/INDEX.md" "2026-09-20-1100--0300-archived"
  assert_not_contains "$target/fast-track-ai/INDEX.md" "| via |"

  cp "$target/fast-track-ai/INDEX.md" "$work/index-first.md"
  "$index_script" "$target" >/dev/null
  cmp "$work/index-first.md" "$target/fast-track-ai/INDEX.md" || fail "unchanged index output is not byte-identical"

  cp "$target/fast-track-ai/refs/pinned-source.md" "$target/fast-track-ai/refs/duplicate-content.md"
  expect_failure "index with duplicate ref hash" "$index_script" "$target"
  assert_contains "$work/failure.err" "duplicates content hash from"
  rm "$target/fast-track-ai/refs/duplicate-content.md"

  locator_hash="$(printf '%s' 'https://example.com/mutable-source' | shasum -a 256 | awk '{print $1}')"
  sed -i.bak "s/^sha256: b\\{64\\}$/sha256: $locator_hash/" "$target/fast-track-ai/refs/mutable-source.md"
  rm "$target/fast-track-ai/refs/mutable-source.md.bak"
  expect_failure "index with locator hash" "$index_script" "$target"
  assert_contains "$work/failure.err" "mutable-source.md sha256 hashes the source locator instead of observed content"
  sed -i.bak "s/^sha256: $locator_hash$/sha256: bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb/" "$target/fast-track-ai/refs/mutable-source.md"
  rm "$target/fast-track-ai/refs/mutable-source.md.bak"

  sed -i.bak 's/^status: draft$/status: unknown/' "$target/fast-track-ai/tracks/001-example/intent.md"
  expect_failure "index with invalid track status" "$index_script" "$target"
  assert_contains "$work/failure.err" "001-example invalid status: unknown"
  mv "$target/fast-track-ai/tracks/001-example/intent.md.bak" "$target/fast-track-ai/tracks/001-example/intent.md"

  sed -i.bak '/^captured:/d' "$target/fast-track-ai/research/example-research.md"
  expect_failure "index with invalid research" "$index_script" "$target"
  assert_contains "$work/failure.err" "example-research.md missing captured field"
  mv "$target/fast-track-ai/research/example-research.md.bak" "$target/fast-track-ai/research/example-research.md"

  sed -i.bak '/^evaluator:/d' "$target/fast-track-ai/assessments/2026-09-20-example-assessment.md"
  expect_failure "index with invalid assessment" "$index_script" "$target"
  assert_contains "$work/failure.err" "2026-09-20-example-assessment.md missing evaluator field"
  mv "$target/fast-track-ai/assessments/2026-09-20-example-assessment.md.bak" "$target/fast-track-ai/assessments/2026-09-20-example-assessment.md"

  sed -i.bak 's/^status: accepted$/status: proposed/' "$target/fast-track-ai/decisions/001-example-decision.md"
  expect_failure "index with invalid decision" "$index_script" "$target"
  assert_contains "$work/failure.err" "001-example-decision.md invalid status: proposed"
  mv "$target/fast-track-ai/decisions/001-example-decision.md.bak" "$target/fast-track-ai/decisions/001-example-decision.md"

  mv "$target/fast-track-ai/handoffs/2026-09-20-1200--0300-active.md" "$target/fast-track-ai/handoffs/bad-handoff.md"
  expect_failure "index with invalid handoff" "$index_script" "$target"
  assert_contains "$work/failure.err" "bad-handoff.md invalid handoff filename"
  mv "$target/fast-track-ai/handoffs/bad-handoff.md" "$target/fast-track-ai/handoffs/2026-09-20-1200--0300-active.md"

  mkdir "$target/fast-track-ai/tracks/011-orphan"
  expect_failure "index with orphan track directory" "$index_script" "$target"
  assert_contains "$work/failure.err" "011-orphan missing intent.md"
  rmdir "$target/fast-track-ai/tracks/011-orphan"

  sed -i.bak 's/^research: \[\]$/research: [missing-topic]/' "$target/fast-track-ai/tracks/001-example/intent.md"
  expect_failure "index with missing research citation" "$index_script" "$target"
  assert_contains "$work/failure.err" "intent.md research references missing missing-topic"
  mv "$target/fast-track-ai/tracks/001-example/intent.md.bak" "$target/fast-track-ai/tracks/001-example/intent.md"

  sed -i.bak 's/^research: \[\]$/research: missing-topic/' "$target/fast-track-ai/tracks/001-example/intent.md"
  expect_failure "index with non-list research citation" "$index_script" "$target"
  assert_contains "$work/failure.err" "research must use [a, b] list form"
  mv "$target/fast-track-ai/tracks/001-example/intent.md.bak" "$target/fast-track-ai/tracks/001-example/intent.md"

  cp "$target/fast-track-ai/tracks/001-example/intent.md" "$work/intent-original.md"
  awk '{ if ($0 == "status: draft") { print "status: superseded"; print "superseded_by: 099-nowhere"; next } print }' "$work/intent-original.md" >"$target/fast-track-ai/tracks/001-example/intent.md"
  expect_failure "index with missing intent replacement" "$index_script" "$target"
  assert_contains "$work/failure.err" "intent.md superseded_by references missing 099-nowhere"
  cp "$work/intent-original.md" "$target/fast-track-ai/tracks/001-example/intent.md"

  awk '{ if ($0 == "status: draft") { print; print "superseded_by: 001-example"; next } print }' "$work/intent-original.md" >"$target/fast-track-ai/tracks/001-example/intent.md"
  expect_failure "index with self-replaced intent" "$index_script" "$target"
  assert_contains "$work/failure.err" "intent.md superseded_by has a self-reference"
  cp "$work/intent-original.md" "$target/fast-track-ai/tracks/001-example/intent.md"

  printf '# not an intent\n' >"$target/fast-track-ai/tracks/003-ghost.md"
  awk '{ if ($0 == "status: draft") { print "status: superseded"; print "superseded_by: 003-ghost"; next } print }' "$work/intent-original.md" >"$target/fast-track-ai/tracks/001-example/intent.md"
  expect_failure "index with loose track file as intent replacement" "$index_script" "$target"
  assert_contains "$work/failure.err" "intent.md superseded_by references missing 003-ghost"
  rm "$target/fast-track-ai/tracks/003-ghost.md"
  cp "$work/intent-original.md" "$target/fast-track-ai/tracks/001-example/intent.md"

  write_intent "$target" "002-replacement" "draft"
  awk '{ if ($0 == "status: draft") { print "status: superseded"; print "superseded_by: 002-replacement"; next } print }' "$work/intent-original.md" >"$target/fast-track-ai/tracks/001-example/intent.md"
  "$index_script" "$target" >/dev/null
  assert_contains "$target/fast-track-ai/INDEX.md" "| 001-example | superseded |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| 002-replacement | draft |"
  cp "$work/intent-original.md" "$target/fast-track-ai/tracks/001-example/intent.md"
  rm -rf "$target/fast-track-ai/tracks/002-replacement"

  sed -i.bak 's/^status: accepted$/status: superseded\
superseded_by: 099-nowhere/' "$target/fast-track-ai/decisions/001-example-decision.md"
  expect_failure "index with missing decision replacement" "$index_script" "$target"
  assert_contains "$work/failure.err" "001-example-decision.md superseded_by references missing 099-nowhere"
  mv "$target/fast-track-ai/decisions/001-example-decision.md.bak" "$target/fast-track-ai/decisions/001-example-decision.md"

  sed -i.bak 's/^status: accepted$/status: superseded\
superseded_by: 001-example-decision/' "$target/fast-track-ai/decisions/001-example-decision.md"
  expect_failure "index with self-replaced decision" "$index_script" "$target"
  assert_contains "$work/failure.err" "001-example-decision.md superseded_by has a self-reference"
  mv "$target/fast-track-ai/decisions/001-example-decision.md.bak" "$target/fast-track-ai/decisions/001-example-decision.md"
  mv "$target/fast-track-ai/handoffs/2026-09-20-1200--0300-active.md" "$target/fast-track-ai/handoffs/archive/"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-21-1000-+0200-a.md" "2026-09-21T10:00:00+02:00" "offset-a"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-21-0930-Z-b.md" "2026-09-21T09:30:00Z" "offset-b"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-21-100000Z-valid.md" "2026-09-21T10:00:00Z" "new-format"
  "$index_script" "$target" >/dev/null
  a_row="$(grep -nF '| 2026-09-21-1000-+0200-a |' "$target/fast-track-ai/INDEX.md" | cut -d: -f1)"
  b_row="$(grep -nF '| 2026-09-21-0930-Z-b |' "$target/fast-track-ai/INDEX.md" | cut -d: -f1)"
  [ "$a_row" -lt "$b_row" ] || fail "handoff rows are not ordered by captured instant"
  assert_contains "$target/fast-track-ai/INDEX.md" "| 2026-09-21-100000Z-valid | 2026-09-21T10:00:00Z |"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-22-100000Z-mismatch.md" "2026-09-22T10:00:01Z" "mismatch"
  expect_failure "index with mismatched new handoff timestamp" "$index_script" "$target"
  assert_contains "$work/failure.err" "filename timestamp does not match captured"
  rm "$target/fast-track-ai/handoffs/2026-09-22-100000Z-mismatch.md"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-22-100000Z-fourth.md" "2026-09-22T10:00:00Z" "fourth"
  expect_failure "index with four active handoffs" "$index_script" "$target"
  assert_contains "$work/failure.err" "more than three handoffs are active"
  rm "$target/fast-track-ai/handoffs/2026-09-22-100000Z-fourth.md"

  # A new-format (## Next actions) handoff is accepted alongside the legacy-heading fixtures.
  rm "$target/fast-track-ai/handoffs/2026-09-21-100000Z-valid.md"
  write_handoff_new "$target/fast-track-ai/handoffs/2026-09-21-100000Z-nextactions.md" "2026-09-21T10:00:00Z" "next-actions"
  "$index_script" "$target" >/dev/null
  assert_contains "$target/fast-track-ai/INDEX.md" "| 2026-09-21-100000Z-nextactions | 2026-09-21T10:00:00Z |"

  # A handoff with neither heading set is rejected and leaves INDEX.md unchanged.
  cp "$target/fast-track-ai/INDEX.md" "$work/index-before-noactions.md"
  write_handoff_no_actions "$target/fast-track-ai/handoffs/2026-09-21-100000Z-nextactions.md" "2026-09-21T10:00:00Z" "next-actions"
  expect_failure "index with handoff missing next actions" "$index_script" "$target"
  assert_contains "$work/failure.err" "missing heading ## Next actions"
  cmp "$work/index-before-noactions.md" "$target/fast-track-ai/INDEX.md" || fail "rejected handoff changed INDEX.md"
  write_handoff_new "$target/fast-track-ai/handoffs/2026-09-21-100000Z-nextactions.md" "2026-09-21T10:00:00Z" "next-actions"

  "$index_script" "$target" >/dev/null
  cp "$target/fast-track-ai/INDEX.md" "$work/index-before-invalid.md"
  cat >"$target/fast-track-ai/research/invalid-research.md" <<'EOF'
---
owner: maintainer
---
EOF
  expect_failure "index does not publish invalid output" "$index_script" "$target"
  assert_contains "$work/failure.err" "INDEX not updated:"
  cmp "$work/index-before-invalid.md" "$target/fast-track-ai/INDEX.md" || fail "invalid index changed INDEX.md"
  for temp_index in "$target/fast-track-ai"/.INDEX.md.*; do
    [ ! -e "$temp_index" ] || fail "temporary index was not cleaned up"
  done
  rm "$target/fast-track-ai/research/invalid-research.md"

  "$index_script" "$target" >/dev/null
  pass "index"
}

run_approval() {
  missing_intent="$work/gate-missing-intent"
  mkdir -p "$missing_intent/fast-track-ai/tracks/001-example"
  write_spec "$missing_intent/fast-track-ai/tracks/001-example/spec.md" "approved"
  write_tasks "$missing_intent/fast-track-ai/tracks/001-example/tasks.md" "approved" "x"
  expect_failure "gate without intent.md" "$gate" --track 001-example --root "$missing_intent"

  short="$work/gate-short"
  write_intent "$short" "001-example" "draft"
  write_spec "$short/fast-track-ai/tracks/001-example/spec.md" "draft"
  write_tasks "$short/fast-track-ai/tracks/001-example/tasks.md" "approved" "x"
  expect_failure "gate with unapproved spec" "$gate" --track 001-example --root "$short"

  write_spec "$short/fast-track-ai/tracks/001-example/spec.md" "approved"
  write_tasks "$short/fast-track-ai/tracks/001-example/tasks.md" "draft" "x"
  expect_failure "gate with unapproved tasks" "$gate" --track 001-example --root "$short"

  write_tasks "$short/fast-track-ai/tracks/001-example/tasks.md" "approved" " "
  expect_failure "gate with open task" "$gate" --track 001-example --root "$short"

  write_spec "$short/fast-track-ai/tracks/001-example/spec.md" "draft"
  write_tasks "$short/fast-track-ai/tracks/001-example/tasks.md" "draft" " "
  structure_output="$("$gate" --mode structure --track 001-example --root "$short")"
  [ "$structure_output" = "PASS: 001-example structure valid" ] || fail "structure mode did not accept a draft with open tasks"
  expect_failure "gate with unknown mode" "$gate" --mode draft --track 001-example --root "$short"
  assert_contains "$work/failure.out" "structure and completion"

  write_spec "$short/fast-track-ai/tracks/001-example/spec.md" "approved"
  write_tasks "$short/fast-track-ai/tracks/001-example/tasks.md" "approved" "x"
  "$gate" --track 001-example --root "$short" >/dev/null

  write_plan "$short/fast-track-ai/tracks/001-example/plan.md" "approved"
  expect_failure "gate with leftover plan.md" "$gate" --track 001-example --root "$short"
  pass "approval gate"
}

assert_installed_layout() {
  agents_dir="$1"
  claude_dir="$2"
  commands_dir="$3"
  count=0
  for skill in "$repo_root"/skills/fast-track-ai-*; do
    name="$(basename "$skill")"
    [ -d "$agents_dir/$name" ] || fail "agent skill does not resolve: $agents_dir/$name"
    [ -d "$claude_dir/$name" ] || fail "Claude mirror does not resolve: $claude_dir/$name"
    count=$((count + 1))
  done
  [ "$count" -eq 7 ] || fail "expected 7 installed skills, got $count"
  [ ! -e "$agents_dir/shared" ] || fail "shared link was installed"
  [ ! -e "$claude_dir/shared" ] || fail "shared Claude mirror was installed"
  cmd_count=0
  for cmd in "$repo_root"/commands/fast-track-ai-*.md; do
    name="$(basename "$cmd")"
    [ -e "$commands_dir/$name" ] || fail "command does not resolve: $commands_dir/$name"
    cmd_count=$((cmd_count + 1))
  done
  [ "$cmd_count" -eq 7 ] || fail "expected 7 installed commands, got $cmd_count"
}

run_install() {
  custom="$work/install-custom"
  mkdir -p "$custom/claude"
  "$repo_root/install.sh" --agents-dir "$custom/agents/skills" --claude-dir "$custom/claude/skills" >/dev/null
  assert_installed_layout "$custom/agents/skills" "$custom/claude/skills" "$custom/claude/commands"

  default="$work/install-default"
  mkdir -p "$default/home/.claude"
  HOME="$default/home" "$repo_root/install.sh" >/dev/null
  assert_installed_layout "$default/home/.agents/skills" "$default/home/.claude/skills" "$default/home/.claude/commands"
  pass "install"
}

run_resources() {
  init_skill="$repo_root/skills/fast-track-ai-init/SKILL.md"
  intent_skill="$repo_root/skills/fast-track-ai-intent/SKILL.md"
  spec_skill="$repo_root/skills/fast-track-ai-spec/SKILL.md"
  assess_skill="$repo_root/skills/fast-track-ai-assess/SKILL.md"
  research_skill="$repo_root/skills/fast-track-ai-research/SKILL.md"
  handoff_skill="$repo_root/skills/fast-track-ai-handoff/SKILL.md"

  for resource in './scripts/fast-track-ai-init.sh' './scripts/fast-track-ai-index.sh' './assets/AGENTS-snippet.md'; do
    assert_contains "$init_skill" "$resource"
  done
  for resource in './assets/intent.md' './assets/ref.md'; do
    assert_contains "$intent_skill" "$resource"
  done
  for resource in './assets/spec.md' './assets/tasks.md' './assets/decisions.md' './scripts/fast-track-ai-gate.sh'; do
    assert_contains "$spec_skill" "$resource"
  done
  assert_contains "$assess_skill" './assets/assessment.md'
  assert_contains "$research_skill" './assets/research.md'
  assert_contains "$handoff_skill" './assets/handoff.md'

  for resource in './scripts/fast-track-ai-init.sh' './scripts/fast-track-ai-index.sh' './assets/AGENTS-snippet.md' './assets/intent.md' './assets/ref.md' './assets/spec.md' './assets/tasks.md' './assets/decisions.md' './scripts/fast-track-ai-gate.sh' './assets/assessment.md' './assets/research.md' './assets/handoff.md'; do
    owner_count="$(grep -Fl "$resource" "$repo_root"/skills/fast-track-ai-*/SKILL.md | wc -l | tr -d ' ')"
    [ "$owner_count" -eq 1 ] || fail "$resource has $owner_count owner skill references; expected 1"
  done

  assert_not_file "$repo_root/skills/fast-track-ai-init/assets/assessment.md"
  assert_not_file "$repo_root/skills/fast-track-ai-init/assets/refs.md"
  for skill_file in "$repo_root"/skills/fast-track-ai-*/SKILL.md; do
    assert_not_contains "$skill_file" 'fast-track-ai-init/assets/assessment.md'
    assert_not_contains "$skill_file" 'fast-track-ai-init/assets/refs.md'
  done
  for skill_file in "$repo_root"/skills/fast-track-ai-*/SKILL.md; do
    assert_contains "$skill_file" "resolve from this skill's installed directory, and \`fast-track-ai/\` paths resolve from the target repository root"
  done
  pass "resource guidance"
}

run_workflows() {
  assess_skill="$repo_root/skills/fast-track-ai-assess/SKILL.md"
  research_skill="$repo_root/skills/fast-track-ai-research/SKILL.md"
  handoff_skill="$repo_root/skills/fast-track-ai-handoff/SKILL.md"
  assess_template="$repo_root/skills/fast-track-ai-assess/assets/assessment.md"
  research_template="$repo_root/skills/fast-track-ai-research/assets/research.md"
  handoff_template="$repo_root/skills/fast-track-ai-handoff/assets/handoff.md"

  for workflow in assess research handoff; do
    assert_file "$repo_root/commands/fast-track-ai-$workflow.md"
    assert_file "$repo_root/skills/fast-track-ai-$workflow/SKILL.md"
    assert_contains "$repo_root/commands/fast-track-ai-$workflow.md" "\`fast-track-ai-$workflow\`"
  done

  assert_not_matches "$research_skill" 'base `research`|base research skill|Run the base'
  assert_not_matches "$handoff_skill" 'base `handoff`|base handoff skill|Run the base'
  assert_not_matches "$repo_root/commands/fast-track-ai-research.md" 'base research skill|Run the base'
  assert_not_matches "$repo_root/commands/fast-track-ai-handoff.md" 'base handoff skill|Run the base'

  for field_name in captured owner; do
    assert_contains "$research_template" "$field_name:"
  done
  for heading in '## Question' '## Conclusion' '## Conflicts' '## Limitations' '## Sources'; do
    assert_contains "$research_template" "$heading"
  done
  assert_not_matches "$research_template" '^(source|status):'

  for field_name in captured owner scope evaluator tracks; do
    assert_contains "$assess_template" "$field_name:"
  done
  for heading in '## Conclusion' '## Scope and basis' '## Criteria' '## Findings' '## Evidence against conclusion' '## Limitations' '## Recommendations'; do
    assert_contains "$assess_template" "$heading"
  done
  assert_not_matches "$assess_template" '^status:'

  for field_name in captured owner focus; do
    assert_contains "$handoff_template" "$field_name:"
  done
  for heading in '## Objective' '## Active user instructions, verbatim' '## Current state' '## Completed' '## Next actions' '## Unresolved decisions' '## Relevant paths and durable artifacts' '## Observed command results' '## Blockers and risks'; do
    assert_contains "$handoff_template" "$heading"
  done
  assert_not_matches "$handoff_template" '^status:'
  assert_not_contains "$handoff_template" '## P0 next actions'
  assert_not_contains "$handoff_template" '## First next action'

  for package_file in "$repo_root"/skills/fast-track-ai-*/SKILL.md "$repo_root"/commands/fast-track-ai-*.md; do
    assert_not_matches "$package_file" 'Jhony Walker|jhonywalkeer|Guia Completo sobre Architecture'
  done

  assert_contains "$research_skill" 'the result is inconclusive'
  assert_contains "$research_skill" 'Never overwrite an existing research file silently.'
  assert_contains "$assess_skill" 'the problem, its evidence, its consequence, and the recommendation'
  assert_contains "$assess_skill" 'any priority follows from the stated consequence'
  assert_contains "$assess_skill" 'Set `tracks` to the IDs of the tracks the assessment evaluates, or `[]`'
  assert_contains "$assess_skill" 'Never overwrite an existing assessment file silently.'
  assert_contains "$assess_template" 'the problem, its evidence citation, its consequence, and the recommendation'
  pass "self-contained artifact workflows"
}

run_refs() {
  template="$repo_root/skills/fast-track-ai-intent/assets/ref.md"
  intent_skill="$repo_root/skills/fast-track-ai-intent/SKILL.md"
  intent_template="$repo_root/skills/fast-track-ai-intent/assets/intent.md"
  assert_file "$template"
  for contract_text in 'content_license' 'Normalize it to UTF-8' 'observed at capture time' 'never the URL' 'Use `pin` when' 'retrieved_at'; do
    assert_contains "$intent_skill" "$contract_text"
  done
  assert_not_contains "$template" '## Contract'
  assert_contains "$intent_skill" 'compare the hash with existing refs'
  assert_contains "$intent_skill" 'create no ref or synthetic hash'
  assert_contains "$intent_skill" 'Open questions'
  assert_contains "$intent_skill" 'Assumed state'
  for provenance_list in '### Stated by the user' '### Unverified assumptions' '### Access limits'; do
    assert_contains "$intent_template" "$provenance_list"
  done


  unavailable="$work/unavailable-ref"
  "$init_script" "$unavailable" >/dev/null
  write_intent "$unavailable" "001-unavailable-source" "draft"
  cat >>"$unavailable/fast-track-ai/tracks/001-unavailable-source/intent.md" <<'EOF'

# Intent: unavailable source

## Assumed state
The source payload was not available.

## Open questions
- Maintainer: provide the source URL, file, or text.
EOF
  assert_not_file "$unavailable/fast-track-ai/refs/unavailable-source.md"
  "$index_script" "$unavailable" >/dev/null
  existing="$unavailable/fast-track-ai/refs/existing-source.md"
  candidate_payload='captured source payload'
  candidate_hash="$(printf '%s' "$candidate_payload" | shasum -a 256 | awk '{print $1}')"
  cat >"$existing" <<EOF
---
type: pointer
source: https://example.com/existing-source
captured: 2026-09-20
owner: maintainer
pin: fixture-v1
sha256: $candidate_hash
content_license: MIT
---

# Ref: existing source
EOF
  existing_slug="$(basename "$existing" .md)"
  [ "$candidate_hash" = "$(frontmatter_field "$existing" sha256)" ] || fail "candidate hash did not match existing ref"
  assert_contains "$intent_skill" 'reuses the existing slug'
  assert_not_file "$unavailable/fast-track-ai/refs/duplicate-source.md"
  "$index_script" "$unavailable" >/dev/null
  assert_contains "$unavailable/fast-track-ai/INDEX.md" "| $existing_slug | pointer | 2026-09-20 |"
  pass "ref capture contract"
}

run_decisions() {
  intent_skill="$repo_root/skills/fast-track-ai-intent/SKILL.md"
  spec_skill="$repo_root/skills/fast-track-ai-spec/SKILL.md"
  implement_skill="$repo_root/skills/fast-track-ai-implement/SKILL.md"
  template="$repo_root/skills/fast-track-ai-spec/assets/decisions.md"

  assert_contains "$intent_skill" 'durable, costly to reverse, surprising without context, or resolves a meaningful trade-off'
  assert_contains "$intent_skill" 'Do not create an ADR for a local, easily reversible, or obvious implementation choice.'
  assert_contains "$spec_skill" 'Do not create an ADR for local, easily reversible, or obvious choices.'
  assert_contains "$implement_skill" 'materially changes approved `spec.md` or `tasks.md`'
  assert_contains "$implement_skill" 'renewed explicit approval'
  assert_contains "$implement_skill" 'If it does not materially change approved scope or design, record it and continue.'
  assert_not_matches "$template" '^evidence:'
  assert_contains "$template" '## Evidence'
  assert_contains "$spec_skill" 'the ADR frontmatter has no `evidence` field'
  assert_contains "$spec_skill" 'set the original'"'"'s `status: superseded` and add `superseded_by: <replacement-id>`'
  replacement="$work/replacement-target"
  "$init_script" "$replacement" >/dev/null
  write_intent "$replacement" "001-replacement-fixture" "draft"
  original_payload_hash="$(printf '%s' 'mutable payload v1' | shasum -a 256 | awk '{print $1}')"
  replacement_payload_hash="$(printf '%s' 'mutable payload v2' | shasum -a 256 | awk '{print $1}')"
  cat >"$replacement/fast-track-ai/refs/mutable-v1.md" <<EOF
---
type: pointer
source: https://example.com/mutable
captured: 2026-09-20
owner: maintainer
retrieved_at: 2026-09-20T12:00:00Z
sha256: $original_payload_hash
content_license: unknown
---

# Ref: mutable v1
EOF
  cp "$replacement/fast-track-ai/refs/mutable-v1.md" "$work/mutable-v1.before"
  cat >"$replacement/fast-track-ai/refs/mutable-v2.md" <<EOF
---
type: pointer
source: https://example.com/mutable
captured: 2026-09-20
owner: maintainer
retrieved_at: 2026-09-21T12:00:00Z
sha256: $replacement_payload_hash
content_license: unknown
---

# Ref: mutable v2
EOF
  cat >"$replacement/fast-track-ai/decisions/001-original.md" <<'EOF'
---
id: 001-original
status: superseded
date: 2026-09-20
owner: maintainer
superseded_by: 002-replacement
evidence: []
---

# ADR: 001-original

## Context
Original fixture decision.

## Decision
Use the original fixture path.

## Rationale
It was the accepted initial choice.

## Alternatives considered
Use the replacement path immediately.

## Consequences
The original decision remains historical.
EOF
  cp "$replacement/fast-track-ai/decisions/001-original.md" "$work/001-original.before"
  cat >"$replacement/fast-track-ai/decisions/002-replacement.md" <<'EOF'
---
id: 002-replacement
status: accepted
date: 2026-09-21
owner: maintainer
evidence: []
---

# ADR: 002-replacement

## Context
The original fixture decision no longer applies.

## Decision
Use the replacement fixture path.

## Rationale
The observed mutable source changed.

## Alternatives considered
Keep the original path.

## Consequences
New work follows the replacement decision.
EOF
  "$index_script" "$replacement" >/dev/null
  cmp "$work/mutable-v1.before" "$replacement/fast-track-ai/refs/mutable-v1.md" || fail "mutable original ref changed"
  cmp "$work/001-original.before" "$replacement/fast-track-ai/decisions/001-original.md" || fail "original ADR content changed"
  assert_contains "$replacement/fast-track-ai/INDEX.md" "| mutable-v1 | pointer | 2026-09-20 |"
  assert_contains "$replacement/fast-track-ai/INDEX.md" "| mutable-v2 | pointer | 2026-09-20 |"
  assert_contains "$replacement/fast-track-ai/INDEX.md" "| 001-original | superseded |"
  assert_contains "$replacement/fast-track-ai/INDEX.md" "| 002-replacement | accepted |"
  assert_contains "$replacement/fast-track-ai/decisions/001-original.md" "superseded_by: 002-replacement"
  pass "decision capture contract"
}

run_handoff() {
  target="$work/handoff-target"
  "$init_script" "$target" >/dev/null
  write_handoff "$target/fast-track-ai/handoffs/2026-09-20-1000-+0200-first.md" "2026-09-20T10:00:00+02:00" "first"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-20-0900-Z-second.md" "2026-09-20T09:00:00Z" "second"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-20-100000Z-third.md" "2026-09-20T10:00:00Z" "third"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-20-110000Z-fourth.md" "2026-09-20T11:00:00Z" "fourth"
  mv "$target/fast-track-ai/handoffs/2026-09-20-1000-+0200-first.md" "$target/fast-track-ai/handoffs/archive/"

  active_handoffs=("$target"/fast-track-ai/handoffs/*.md)
  [ "${#active_handoffs[@]}" -eq 3 ] || fail "handoff fixture did not retain exactly three active files"
  assert_file "$target/fast-track-ai/handoffs/archive/2026-09-20-1000-+0200-first.md"
  assert_contains "$target/fast-track-ai/handoffs/archive/2026-09-20-1000-+0200-first.md" '> Preserve this exact instruction.'
  assert_not_matches "$repo_root/skills/fast-track-ai-handoff/SKILL.md" 'base `handoff`|base handoff skill|Run the base'
  handoff_skill="$repo_root/skills/fast-track-ai-handoff/SKILL.md"
  collision_line="$(grep -n 'Before writing, check that this path exists in neither' "$handoff_skill" | cut -d: -f1)"
  write_line="$(grep -n 'Write the final document directly to that path' "$handoff_skill" | cut -d: -f1)"
  validate_line="$(grep -n 'Validate the new handoff before touching any other handoff' "$handoff_skill" | cut -d: -f1)"
  archive_line="$(grep -n 'Move each older handoff to `fast-track-ai/handoffs/archive/`' "$handoff_skill" | cut -d: -f1)"
  index_line="$(grep -n 'run `../fast-track-ai-init/scripts/fast-track-ai-index.sh' "$handoff_skill" | cut -d: -f1)"
  [ -n "$collision_line" ] && [ -n "$write_line" ] && [ -n "$validate_line" ] && [ -n "$archive_line" ] && [ -n "$index_line" ] || fail "handoff skill lacks a collision, write, validate, archive, or index step"
  [ "$collision_line" -lt "$write_line" ] && [ "$write_line" -lt "$validate_line" ] || fail "handoff skill does not check collision, then write, then validate"
  [ "$validate_line" -lt "$archive_line" ] && [ "$archive_line" -lt "$index_line" ] || fail "handoff skill does not validate, then archive, then index"
  "$index_script" "$target" >/dev/null
  assert_not_contains "$target/fast-track-ai/INDEX.md" '2026-09-20-1000-+0200-first'
  second_row="$(grep -nF '| 2026-09-20-0900-Z-second |' "$target/fast-track-ai/INDEX.md" | cut -d: -f1)"
  third_row="$(grep -nF '| 2026-09-20-100000Z-third |' "$target/fast-track-ai/INDEX.md" | cut -d: -f1)"
  fourth_row="$(grep -nF '| 2026-09-20-110000Z-fourth |' "$target/fast-track-ai/INDEX.md" | cut -d: -f1)"
  [ "$second_row" -lt "$third_row" ] && [ "$third_row" -lt "$fourth_row" ] || fail "handoffs are not ordered by captured instant"

  # A new-format handoff is accepted, and one with neither heading set is rejected without changing INDEX.
  rm "$target/fast-track-ai/handoffs/2026-09-20-100000Z-third.md"
  write_handoff_new "$target/fast-track-ai/handoffs/2026-09-20-100000Z-third.md" "2026-09-20T10:00:00Z" "third-new"
  "$index_script" "$target" >/dev/null
  assert_contains "$target/fast-track-ai/INDEX.md" "| 2026-09-20-100000Z-third | 2026-09-20T10:00:00Z |"
  cp "$target/fast-track-ai/INDEX.md" "$work/handoff-index-before.md"
  write_handoff_no_actions "$target/fast-track-ai/handoffs/2026-09-20-100000Z-third.md" "2026-09-20T10:00:00Z" "third-new"
  expect_failure "handoff missing next actions" "$index_script" "$target"
  assert_contains "$work/failure.err" "missing heading ## Next actions"
  cmp "$work/handoff-index-before.md" "$target/fast-track-ai/INDEX.md" || fail "rejected handoff changed INDEX.md"
  pass "handoff active window"
}

run_spec() {
  missing="$work/spec-missing"
  write_intent "$missing" "001-example" "draft"
  write_tasks "$missing/fast-track-ai/tracks/001-example/tasks.md" "approved" "x"
  expect_failure "gate without spec.md" "$gate" --track 001-example --root "$missing"

  leftover="$work/spec-leftover-dir"
  write_intent "$leftover" "002-example" "draft"
  mkdir -p "$leftover/fast-track-ai/tracks/002-example/spec"
  printf '# Spec\n' >"$leftover/fast-track-ai/tracks/002-example/spec/spec.md"
  write_tasks "$leftover/fast-track-ai/tracks/002-example/spec/tasks.md" "approved" "x"
  expect_failure "gate with spec/ and no root spec.md" "$gate" --track 002-example --root "$leftover"

  ok="$work/spec-ok"
  write_intent "$ok" "003-example" "draft"
  write_spec "$ok/fast-track-ai/tracks/003-example/spec.md" "approved"
  write_tasks "$ok/fast-track-ai/tracks/003-example/tasks.md" "approved" "x"
  "$gate" --track 003-example --root "$ok" >/dev/null

  sed -i.bak 's/^id: 003-example$/id: 004-other/' "$ok/fast-track-ai/tracks/003-example/intent.md"
  expect_failure "gate with mismatched intent id" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "intent id mismatch: 004-other"
  mv "$ok/fast-track-ai/tracks/003-example/intent.md.bak" "$ok/fast-track-ai/tracks/003-example/intent.md"

  cat >"$ok/fast-track-ai/tracks/003-example/spec.md" <<'EOF'
---
status: draft
---
Files: fixture
Accept: fixture
EOF
  expect_failure "gate with no spec phases" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "spec has no ### Phase section"

  write_spec "$ok/fast-track-ai/tracks/003-example/spec.md" "draft"
  cat >>"$ok/fast-track-ai/tracks/003-example/spec.md" <<'EOF'

### Phase 2: empty accept
Done: fixture done
Files: fixture
Accept:
EOF
  expect_failure "gate with empty second phase Accept" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "Phase 2: empty accept missing or empty Accept:"

  write_spec "$ok/fast-track-ai/tracks/003-example/spec.md" "draft"
  cat >"$ok/fast-track-ai/tracks/003-example/tasks.md" <<'EOF'
---
status: draft
---
Files: fixture
Validate: fixture
EOF
  expect_failure "gate with no task lines" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "tasks file has no task lines"

  write_tasks "$ok/fast-track-ai/tracks/003-example/tasks.md" "draft" " "
  cat >>"$ok/fast-track-ai/tracks/003-example/tasks.md" <<'EOF'
- [ ] Missing Validate. Files: fixture
EOF
  expect_failure "gate with task missing Validate" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "line 8 task missing or empty Validate:"

  cat >"$ok/fast-track-ai/tracks/003-example/tasks.md" <<'EOF'
---
status: draft
---
## Group A (depends: Missing)
- [ ] Work. Files: fixture Validate: fixture
EOF
  expect_failure "gate with unknown group dependency" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "group A has unknown dependency Missing"

  cat >"$ok/fast-track-ai/tracks/003-example/tasks.md" <<'EOF'
---
status: draft
---
## Group A (depends: A)
- [ ] Work. Files: fixture Validate: fixture
EOF
  expect_failure "gate with self-dependent group" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "group A depends on itself"

  cat >"$ok/fast-track-ai/tracks/003-example/tasks.md" <<'EOF'
---
status: draft
---
## Group A
- [ ] Work. Files: fixture Validate: fixture
## Group A
- [ ] More. Files: fixture Validate: fixture
EOF
  expect_failure "gate with duplicate group names" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "duplicate group name A"

  cat >"$ok/fast-track-ai/tracks/003-example/tasks.md" <<'EOF'
---
status: draft
---
## Group A (depends: B)
- [ ] Work. Files: fixture Validate: fixture
## Group B (depends: A)
- [ ] More. Files: fixture Validate: fixture
EOF
  expect_failure "gate with dependency cycle" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "dependency cycle involving"

  cat >"$ok/fast-track-ai/tracks/003-example/tasks.md" <<'EOF'
---
status: draft
---
- [ ] Before group. Files: fixture Validate: fixture
## Group A
- [ ] Work. Files: fixture Validate: fixture
EOF
  expect_failure "gate with task before first group" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "task appears before first group header"

  write_tasks "$ok/fast-track-ai/tracks/003-example/tasks.md" "draft" "x"
  "$gate" --mode structure --track 003-example --root "$ok" >/dev/null

  write_plan "$ok/fast-track-ai/tracks/003-example/plan.md" "approved"
  expect_failure "gate with leftover plan.md" "$gate" --track 003-example --root "$ok"
  rm "$ok/fast-track-ai/tracks/003-example/plan.md"

  root_dir="$ok/fast-track-ai/tracks/003-example"
  for hidden_name in .notes .DS_Store; do
    printf 'hidden\n' >"$root_dir/$hidden_name"
    expect_failure "gate with hidden root entry $hidden_name" "$gate" --mode structure --track 003-example --root "$ok"
    assert_contains "$work/failure.out" "hidden root entry: $hidden_name"
    rm "$root_dir/$hidden_name"
  done

  printf 'not a directory\n' >"$root_dir/assets"
  expect_failure "gate with file assets" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "assets must be a directory"
  rm "$root_dir/assets"

  printf 'not a directory\n' >"$root_dir/spec"
  expect_failure "gate with file spec" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "spec must be a directory"
  rm "$root_dir/spec"

  mv "$root_dir/spec.md" "$work/spec-ok-spec.md"
  mkdir "$root_dir/spec.md"
  expect_failure "gate with directory spec.md" "$gate" --mode structure --track 003-example --root "$ok"
  assert_contains "$work/failure.out" "spec.md must be a file"
  rmdir "$root_dir/spec.md"
  mv "$work/spec-ok-spec.md" "$root_dir/spec.md"

  printf '# Legacy decisions\n' >"$root_dir/decisions.md"
  "$gate" --mode structure --track 003-example --root "$ok" >/dev/null
  rm "$root_dir/decisions.md"
  spec_skill="$repo_root/skills/fast-track-ai-spec/SKILL.md"
  spec_template="$repo_root/skills/fast-track-ai-spec/assets/spec.md"
  tasks_template="$repo_root/skills/fast-track-ai-spec/assets/tasks.md"
  assert_contains "$spec_skill" 'Done:'
  assert_contains "$spec_skill" 'Accept:'
  assert_contains "$spec_skill" '(Phase N)'
  assert_contains "$spec_skill" 'observable procedure with its expected observation'
  assert_contains "$spec_template" 'Done: the delivered, observable state when this phase closes.'
  assert_contains "$spec_template" 'Accept: the command with its expected result, or the observable procedure with its expected observation.'
  assert_not_contains "$spec_template" 'decisions.md'
  assert_contains "$tasks_template" '(Phase 1):'
  assert_contains "$tasks_template" 'Validate: command or procedure with its expected result.'

  from_template="$work/spec-from-template"
  write_intent "$from_template" "005-template" "draft"
  base_dir="$from_template/fast-track-ai/tracks/005-template"
  sed 's/NNN-slug/005-template/g' "$spec_template" >"$base_dir/spec.md"
  sed -i.bak $'s/^Done:$/Done: phase two delivered state/; s/^Files:$/Files: fixture/; s/^Accept:$/Accept: run true, expect exit 0/' "$base_dir/spec.md"
  rm -f "$base_dir/spec.md.bak"
  sed 's/NNN-slug/005-template/g' "$tasks_template" >"$base_dir/tasks.md"
  "$gate" --mode structure --track 005-template --root "$from_template" >/dev/null
  pass "spec cycle"
}

run_flow() {
  intent_skill="$repo_root/skills/fast-track-ai-intent/SKILL.md"
  spec_skill="$repo_root/skills/fast-track-ai-spec/SKILL.md"
  implement_skill="$repo_root/skills/fast-track-ai-implement/SKILL.md"
  tasks_template="$repo_root/skills/fast-track-ai-spec/assets/tasks.md"
  assert_contains "$intent_skill" ". para continuar com a spec"
  assert_contains "$spec_skill" ". para implementar"
  assert_contains "$implement_skill" ". para ship"
  assert_contains "$implement_skill" "Delegate proportionally"
  assert_contains "$implement_skill" "each delegated task gets its own subagent"
  assert_not_contains "$implement_skill" "one task per agent"
  assert_contains "$implement_skill" "continue from the first open task"
  assert_contains "$implement_skill" "record the divergence in the track's"
  assert_not_contains "$intent_skill" "Track concluida. Nenhuma implementacao necessaria."
  assert_contains "$implement_skill" "provenance"
  assert_contains "$implement_skill" "does not need"
  assert_not_contains "$implement_skill" "pointer; do not vendor"
  assert_contains "$tasks_template" "## Group"
  assert_contains "$tasks_template" "(depends:"
  pass "flow"
}

check_no_live_active() {
  package_root="$1"
  for live_file in "$package_root"/skills/fast-track-ai-*/SKILL.md "$package_root"/skills/fast-track-ai-*/assets/* "$package_root"/commands/fast-track-ai-*.md; do
    [ -f "$live_file" ] || continue
    assert_not_contains "$live_file" 'status: active'
  done
}

run_active() {
  check_no_live_active "$repo_root"
  assert_contains "$index_script" 'active is accepted only as a legacy value'
  legacy_line="$(grep -n 'active is accepted only as a legacy value' "$index_script" | cut -d: -f1)"
  case_line="$(grep -n 'case "$status" in draft|active|' "$index_script" | cut -d: -f1)"
  [ "$((legacy_line + 1))" -eq "$case_line" ] || fail "legacy active comment is not directly above the intent status case"
  pass "legacy active"
}

expect_index_frontmatter_rejection() {
  target_root="$1"
  expected="$2"
  expect_failure "index rejecting frontmatter: $expected" "$index_script" "$target_root"
  assert_contains "$work/failure.err" "$expected"
  cmp "$work/frontmatter-index.before" "$target_root/fast-track-ai/INDEX.md" || fail "frontmatter rejection changed INDEX.md"
}

expect_gate_frontmatter_rejection() {
  target_root="$1"
  expected="$2"
  expect_failure "gate rejecting frontmatter: $expected" "$gate" --mode structure --track 001-front --root "$target_root"
  assert_contains "$work/failure.out" "$expected"
}

run_frontmatter() {
  target="$work/frontmatter-target"
  "$init_script" "$target" >/dev/null
  track_dir="$target/fast-track-ai/tracks/001-front"
  intent="$track_dir/intent.md"
  write_intent "$target" "001-front" "draft"
  write_spec "$track_dir/spec.md" "draft"
  write_tasks "$track_dir/tasks.md" "draft" " "
  research="$target/fast-track-ai/research/front-research.md"
  cat >"$research" <<'EOF'
---
captured: 2026-09-20
owner: maintainer
---

# Research: front

## Question
Fixture.

## Conclusion
Fixture.

## Conflicts
None.

## Limitations
Fixture.

## Sources
- Fixture.
EOF
  "$index_script" "$target" >/dev/null
  "$gate" --mode structure --track 001-front --root "$target" >/dev/null
  cp "$target/fast-track-ai/INDEX.md" "$work/frontmatter-index.before"
  cp "$intent" "$work/frontmatter-intent.good"
  cp "$research" "$work/frontmatter-research.good"
  cp "$track_dir/spec.md" "$work/frontmatter-spec.good"
  cp "$track_dir/tasks.md" "$work/frontmatter-tasks.good"
  gate_intent="fast-track-ai/tracks/001-front/intent.md"

  printf -- '---\nid: 001-front\nstatus: draft\n' >"$intent"
  expect_index_frontmatter_rejection "$target" "001-front/intent.md frontmatter not closed"
  expect_gate_frontmatter_rejection "$target" "FAIL: $gate_intent frontmatter not closed"

  printf -- '---\nid: 001-front\nstatus: draft\nstatus: shipped\n---\n' >"$intent"
  expect_index_frontmatter_rejection "$target" "001-front/intent.md duplicate frontmatter field status"
  expect_gate_frontmatter_rejection "$target" "FAIL: $gate_intent duplicate frontmatter field status"

  printf -- '---\nid: 001-front\nstatus: draft\nrefs:\n  - slug\n---\n' >"$intent"
  expect_index_frontmatter_rejection "$target" "001-front/intent.md frontmatter line 5 is not a key: value field"
  expect_gate_frontmatter_rejection "$target" "FAIL: $gate_intent frontmatter line 5 is not a key: value field"

  printf -- '# Intent\n\n---\nid: 001-front\nstatus: draft\n---\n' >"$intent"
  expect_index_frontmatter_rejection "$target" "001-front missing id field"
  expect_gate_frontmatter_rejection "$target" "FAIL: intent without id"
  cp "$work/frontmatter-intent.good" "$intent"

  awk '{ print } $0 == "captured: 2026-09-20" { print "captured: 2026-09-21" }' "$work/frontmatter-research.good" >"$research"
  expect_index_frontmatter_rejection "$target" "front-research.md duplicate frontmatter field captured"
  cp "$work/frontmatter-research.good" "$research"

  awk '{ print } $0 == "status: draft" { print "status: approved" }' "$work/frontmatter-spec.good" >"$track_dir/spec.md"
  expect_gate_frontmatter_rejection "$target" "FAIL: fast-track-ai/tracks/001-front/spec.md duplicate frontmatter field status"
  cp "$work/frontmatter-spec.good" "$track_dir/spec.md"

  printf -- '---\nstatus: draft\n' >"$track_dir/tasks.md"
  expect_gate_frontmatter_rejection "$target" "FAIL: fast-track-ai/tracks/001-front/tasks.md frontmatter not closed"
  cp "$work/frontmatter-tasks.good" "$track_dir/tasks.md"

  "$index_script" "$target" >/dev/null
  "$gate" --mode structure --track 001-front --root "$target" >/dev/null

  template_count=0
  for template in "$repo_root"/skills/fast-track-ai-*/assets/*; do
    [ -f "$template" ] || continue
    [ "$(head -n 1 "$template")" = "---" ] || continue
    template_count=$((template_count + 1))
    cp "$template" "$target/fast-track-ai/research/template-check.md"
    "$index_script" "$target" >/dev/null 2>"$work/template-check.err" || true
    if grep -Eq 'frontmatter not closed|duplicate frontmatter field|frontmatter line [0-9]+ is not a key: value field' "$work/template-check.err"; then
      fail "template frontmatter violates the canonical subset: $template"
    fi
  done
  rm "$target/fast-track-ai/research/template-check.md"
  [ "$template_count" -gt 0 ] || fail "no frontmatter templates found"
  pass "frontmatter subset"
}

run_isolation() {
  iso="$work/isolation"
  mkdir -p "$iso"
  for item in skills commands install.sh AGENTS.md evals; do
    cp -R "$repo_root/$item" "$iso/$item"
  done
  [ ! -e "$iso/fast-track-ai" ] || fail "isolation copy unexpectedly contains fast-track-ai/"
  FAST_TRACK_AI_ISOLATION_GUARD=1 bash "$iso/evals/run-evals.sh" all >/dev/null
  pass "isolation"
}

run_case() {
  case "$1" in
    self) run_self ;;
    init) run_init ;;
    index) run_index ;;
    approval) run_approval ;;
    install) run_install ;;
    resources) run_resources ;;
    workflows) run_workflows ;;
    refs) run_refs ;;
    decisions) run_decisions ;;
    handoff) run_handoff ;;
    spec) run_spec ;;
    flow) run_flow ;;
    active) run_active ;;
    frontmatter) run_frontmatter ;;
    isolation) run_isolation ;;
    *) fail "unknown eval: $1" ;;
  esac
}

if [ "$mode" = "all" ]; then
  for eval_name in self init index approval install resources workflows refs decisions handoff spec flow active frontmatter isolation; do
    if [ "$eval_name" = "isolation" ] && [ "${FAST_TRACK_AI_ISOLATION_GUARD:-}" = "1" ]; then
      continue
    fi
    run_case "$eval_name"
  done
  pass "all evals"
else
  run_case "$mode"
fi
