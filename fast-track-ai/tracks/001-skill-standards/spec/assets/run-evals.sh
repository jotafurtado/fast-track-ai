#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../../../.." && pwd)"
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

## Phases
Files: fixture
Accept: fixture
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
  pass "init"
}

run_index() {
  target="$work/index-target"
  "$init_script" "$target" >/dev/null
  write_intent "$target" "001-example" "active"

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
  assert_contains "$target/fast-track-ai/INDEX.md" "| 001-example | active |"
  assert_contains "$target/fast-track-ai/INDEX.md" "| inline-source | inline | 2026-09-20 |"
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

  sed -i.bak 's/^status: active$/status: unknown/' "$target/fast-track-ai/tracks/001-example/intent.md"
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

run_audit() {
  audit="$repo_root/fast-track-ai/tracks/001-skill-standards/spec/audit.md"
  for skill in dot-ai-init dot-ai-intent dot-ai-plan dot-ai-implement dot-ai-research dot-ai-handoff; do
    for rule in 1 2 3 4 5 6; do
      [ "$(grep -Fc "| $skill | $rule | PASS |" "$audit")" -eq 1 ] || fail "audit lacks one PASS row for $skill rule $rule"
    done
  done
  rows="$(grep -Ec '^\| dot-ai-(init|intent|plan|implement|research|handoff) \| [1-6] \| PASS \| `.+` \|$' "$audit" || true)"
  [ "$rows" -eq 36 ] || fail "audit has $rows evidence-backed PASS rows; expected 36"
  assert_not_contains "$audit" "| FAIL |"
  assert_not_contains "$audit" "| PARTIAL |"
  pass "audit"
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
  pass "resource guidance"
}

run_workflows() {
  assess_skill="$repo_root/skills/fast-track-ai-assess/SKILL.md"
  research_skill="$repo_root/skills/fast-track-ai-research/SKILL.md"
  handoff_skill="$repo_root/skills/fast-track-ai-handoff/SKILL.md"
  assess_template="$repo_root/skills/fast-track-ai-assess/assets/assessment.md"
  research_template="$repo_root/skills/fast-track-ai-research/assets/research.md"
  handoff_template="$repo_root/skills/fast-track-ai-handoff/assets/handoff.md"
  research_artifact="$repo_root/fast-track-ai/research/artifact-standards.md"

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
  for heading in '## Objective' '## Active user instructions, verbatim' '## Current state' '## Completed' '## P0 next actions' '## P1 next actions' '## Unresolved decisions' '## Relevant paths and durable artifacts' '## Observed command results' '## Blockers and risks' '## First next action'; do
    assert_contains "$handoff_template" "$heading"
  done
  assert_not_matches "$handoff_template" '^status:'

  compatible_count="$(grep -Ec '\| 2026-09-20 \| (MIT-compatible|Apache-2\.0-compatible)' "$research_artifact")"
  [ "$compatible_count" -eq 10 ] || fail "research has $compatible_count compatible source rows; expected 10"
  citation_only_count="$(grep -c '| Citation-only |' "$research_artifact")"
  [ "$citation_only_count" -eq 2 ] || fail "research has $citation_only_count citation-only rows; expected 2"
  assert_contains "$research_artifact" '| Firecrawl deep-research | ISC | Excluded |'
  for package_file in "$repo_root"/skills/fast-track-ai-*/SKILL.md "$repo_root"/commands/fast-track-ai-*.md; do
    assert_not_matches "$package_file" 'Jhony Walker|jhonywalkeer|Guia Completo sobre Architecture'
  done
  pass "self-contained artifact workflows"
}

run_refs() {
  template="$repo_root/skills/fast-track-ai-intent/assets/ref.md"
  intent_skill="$repo_root/skills/fast-track-ai-intent/SKILL.md"
  assert_file "$template"
  for contract_text in 'content_license' 'Normalize it to UTF-8' 'observed at capture time' 'never the URL' 'Use `pin` when' 'retrieved_at' 'compare the candidate content hash' 'create no ref and no synthetic hash'; do
    assert_contains "$template" "$contract_text"
  done
  assert_contains "$intent_skill" 'compare the hash with existing refs'
  assert_contains "$intent_skill" 'create no ref or synthetic hash'
  assert_contains "$intent_skill" 'Open questions'
  assert_contains "$intent_skill" 'Assumed state'


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
  decision="$repo_root/fast-track-ai/decisions/007-dedicated-assessment-skill.md"

  assert_contains "$intent_skill" 'durable, costly to reverse, surprising without context, or resolves a meaningful trade-off'
  assert_contains "$intent_skill" 'Do not create an ADR for a local, easily reversible, or obvious implementation choice.'
  assert_contains "$spec_skill" 'Do not create an ADR for local, easily reversible, or obvious choices.'
  assert_contains "$implement_skill" 'materially changes approved `spec.md` or `tasks.md`'
  assert_contains "$implement_skill" 'renewed explicit approval'
  assert_contains "$implement_skill" 'If it does not materially change approved scope or design, record it and continue.'
  assert_contains "$template" 'evidence: []'
  assert_contains "$template" '## Evidence'
  for heading in '## Context' '## Decision' '## Rationale' '## Alternatives considered' '## Consequences' '## Evidence'; do
    assert_contains "$decision" "$heading"
  done
  assert_contains "$decision" 'fast-track-ai/tracks/002-assessment-standard/intent.md'
  assert_not_contains "$decision" 'superseded_by:'
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
  write_handoff "$target/fast-track-ai/handoffs/2026-09-20-0900--0300-first.md" "2026-09-20T09:00:00-03:00" "first"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-20-1000--0300-second.md" "2026-09-20T10:00:00-03:00" "second"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-20-1100--0300-third.md" "2026-09-20T11:00:00-03:00" "third"
  write_handoff "$target/fast-track-ai/handoffs/2026-09-20-1200--0300-fourth.md" "2026-09-20T12:00:00-03:00" "fourth"
  mv "$target/fast-track-ai/handoffs/2026-09-20-0900--0300-first.md" "$target/fast-track-ai/handoffs/archive/"

  active_handoffs=("$target"/fast-track-ai/handoffs/*.md)
  [ "${#active_handoffs[@]}" -eq 3 ] || fail "handoff fixture did not retain exactly three active files"
  assert_file "$target/fast-track-ai/handoffs/archive/2026-09-20-0900--0300-first.md"
  assert_contains "$target/fast-track-ai/handoffs/archive/2026-09-20-0900--0300-first.md" '> Preserve this exact instruction.'
  assert_not_matches "$repo_root/skills/fast-track-ai-handoff/SKILL.md" 'base `handoff`|base handoff skill|Run the base'
  "$index_script" "$target" >/dev/null
  assert_not_contains "$target/fast-track-ai/INDEX.md" '2026-09-20-0900--0300-first'
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

  write_plan "$ok/fast-track-ai/tracks/003-example/plan.md" "approved"
  expect_failure "gate with leftover plan.md" "$gate" --track 003-example --root "$ok"
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
  assert_contains "$intent_skill" "Track concluida. Nenhuma implementacao necessaria."
  assert_contains "$tasks_template" "## Group"
  assert_contains "$tasks_template" "(depends:"
  pass "flow"
}

run_contract() {
  contract="$repo_root/fast-track-ai/tracks/001-skill-standards/spec/contracts/skill-package.md"
  assert_contains "$contract" "Sibling owner paths"
  assert_contains "$contract" "../fast-track-ai-init/scripts/fast-track-ai-index.sh"
  assert_contains "$contract" "skills/fast-track-ai-*"
  assert_contains "$contract" "seven package skills"
  assert_contains "$contract" "Self-contained workflows"
  assert_contains "$contract" "Template ownership"
  assert_not_contains "$contract" "is forbidden; the owner copy path"
  pass "package contract"
}

run_case() {
  case "$1" in
    self) run_self ;;
    init) run_init ;;
    index) run_index ;;
    approval) run_approval ;;
    install) run_install ;;
    audit) run_audit ;;
    resources) run_resources ;;
    workflows) run_workflows ;;
    refs) run_refs ;;
    decisions) run_decisions ;;
    handoff) run_handoff ;;
    spec) run_spec ;;
    contract) run_contract ;;
    flow) run_flow ;;
    *) fail "unknown eval: $1" ;;
  esac
}

if [ "$mode" = "all" ]; then
  for eval_name in self init index approval install audit resources workflows refs decisions handoff spec contract flow; do
    run_case "$eval_name"
  done
  pass "all evals"
else
  run_case "$mode"
fi
