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
  cat >"$target/fast-track-ai/refs/code-review-skill.md" <<'EOF'
---
type: pointer
source: https://example.com/code-review-skill
captured: 2026-09-20
owner: maintainer
pin: fixture
sha256: abcdef
---
EOF
  "$index_script" "$target" >/dev/null
  assert_contains "$target/fast-track-ai/INDEX.md" "| 001-example | active |"
  assert_not_contains "$target/fast-track-ai/INDEX.md" "| via |"
  sed -i.bak 's/^type: pointer$/type: unknown/' "$target/fast-track-ai/refs/code-review-skill.md"
  rm -f "$target/fast-track-ai/refs/code-review-skill.md.bak"
  expect_failure "index with invalid ref type" "$index_script" "$target"
  assert_contains "$work/failure.err" "invalid type: unknown"
  sed -i.bak 's/^type: unknown$/type: pointer/' "$target/fast-track-ai/refs/code-review-skill.md"
  rm -f "$target/fast-track-ai/refs/code-review-skill.md.bak"
  sed -i.bak 's/^status: active$/status: unknown/' "$target/fast-track-ai/tracks/001-example/intent.md"
  rm -f "$target/fast-track-ai/tracks/001-example/intent.md.bak"
  expect_failure "index with invalid status" "$index_script" "$target"
  assert_contains "$work/failure.err" "invalid status: unknown"
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
  count=0
  for skill in "$repo_root"/skills/fast-track-ai-*; do
    name="$(basename "$skill")"
    [ -d "$agents_dir/$name" ] || fail "agent skill does not resolve: $agents_dir/$name"
    [ -d "$claude_dir/$name" ] || fail "Claude mirror does not resolve: $claude_dir/$name"
    count=$((count + 1))
  done
  [ "$count" -eq 6 ] || fail "expected 6 installed skills, got $count"
  [ ! -e "$agents_dir/shared" ] || fail "shared link was installed"
  [ ! -e "$claude_dir/shared" ] || fail "shared Claude mirror was installed"
}

run_install() {
  custom="$work/install-custom"
  mkdir -p "$custom/claude"
  "$repo_root/install.sh" --agents-dir "$custom/agents/skills" --claude-dir "$custom/claude/skills" >/dev/null
  assert_installed_layout "$custom/agents/skills" "$custom/claude/skills"

  default="$work/install-default"
  mkdir -p "$default/home/.claude"
  HOME="$default/home" "$repo_root/install.sh" >/dev/null
  assert_installed_layout "$default/home/.agents/skills" "$default/home/.claude/skills"
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

  for resource in './scripts/fast-track-ai-init.sh' './scripts/fast-track-ai-index.sh' './assets/AGENTS-snippet.md' './assets/refs.md'; do
    assert_contains "$init_skill" "$resource"
  done
  for resource in './assets/intent.md'; do
    assert_contains "$intent_skill" "$resource"
  done
  for resource in './assets/spec.md' './assets/tasks.md' './assets/decisions.md' './scripts/fast-track-ai-gate.sh'; do
    assert_contains "$spec_skill" "$resource"
  done
  pass "resource guidance"
}

run_spec() {
  missing="$work/spec-missing"
  write_intent "$missing" "001-example" "active"
  write_tasks "$missing/fast-track-ai/tracks/001-example/tasks.md" "approved" "x"
  expect_failure "gate without spec.md" "$gate" --track 001-example --root "$missing"

  leftover="$work/spec-leftover-dir"
  write_intent "$leftover" "002-example" "active"
  mkdir -p "$leftover/fast-track-ai/tracks/002-example/spec"
  printf '# Spec\n' >"$leftover/fast-track-ai/tracks/002-example/spec/spec.md"
  write_tasks "$leftover/fast-track-ai/tracks/002-example/spec/tasks.md" "approved" "x"
  expect_failure "gate with spec/ and no root spec.md" "$gate" --track 002-example --root "$leftover"

  ok="$work/spec-ok"
  write_intent "$ok" "003-example" "active"
  write_spec "$ok/fast-track-ai/tracks/003-example/spec.md" "approved"
  write_tasks "$ok/fast-track-ai/tracks/003-example/tasks.md" "approved" "x"
  "$gate" --track 003-example --root "$ok" >/dev/null

  write_plan "$ok/fast-track-ai/tracks/003-example/plan.md" "approved"
  expect_failure "gate with leftover plan.md" "$gate" --track 003-example --root "$ok"
  pass "spec cycle"
}

run_contract() {
  contract="$repo_root/fast-track-ai/tracks/001-skill-standards/spec/contracts/skill-package.md"
  assert_contains "$contract" "Sibling owner paths"
  assert_contains "$contract" "../fast-track-ai-init/scripts/fast-track-ai-index.sh"
  assert_contains "$contract" "skills/fast-track-ai-*"
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
    spec) run_spec ;;
    contract) run_contract ;;
    *) fail "unknown eval: $1" ;;
  esac
}

if [ "$mode" = "all" ]; then
  for eval_name in self init index approval install audit resources spec contract; do
    run_case "$eval_name"
  done
  pass "all evals"
else
  run_case "$mode"

fi
