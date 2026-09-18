#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../../../.." && pwd)"
mode="${1:-all}"
work="$(mktemp -d "${TMPDIR:-/tmp}/dot-ai-skill-standards.XXXXXX")"
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
  via="${4:-rapida}"
  mkdir -p "$root/dot-ai/tracks/$track"
  cat >"$root/dot-ai/tracks/$track/intent.md" <<EOF
---
id: $track
status: $status
via: $via
via_motivo: fixture
research: []
decisions: []
---
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

run_self() {
  bash -n "$repo_root/install.sh"
  bash -n "$repo_root/skills/dot-ai-init/scripts/dot-ai-init.sh"
  bash -n "$repo_root/skills/dot-ai-init/scripts/dot-ai-index.sh"
  bash -n "$repo_root/skills/dot-ai-intent/scripts/dot-ai-specify.sh"
  bash -n "$repo_root/skills/dot-ai-plan/scripts/sdd-gate.sh"
  assert_not_matches "$repo_root/AGENTS.md" 'sdd-gate\.sh.*\|\|[[:space:]]*true'
  pass "runner self-check"
}

run_init() {
  target="$work/init-target"
  "$repo_root/skills/dot-ai-init/scripts/dot-ai-init.sh" "$target" >/dev/null
  "$repo_root/skills/dot-ai-init/scripts/dot-ai-init.sh" "$target" >/dev/null

  for directory in research refs handoffs/archive assessments decisions tracks specs; do
    assert_dir "$target/dot-ai/$directory"
  done
  [ -L "$target/specs" ] || fail "specs view is not a symlink"
  [ "$(readlink "$target/specs")" = "dot-ai/specs" ] || fail "specs view has the wrong target"
  [ ! -e "$target/scripts" ] || fail "target received a scripts directory"
  [ ! -e "$target/templates" ] || fail "target received a templates directory"
  [ "$(grep -c 'BEGIN MANAGED BLOCK: dot-ai' "$target/AGENTS.md")" -eq 1 ] || fail "managed block is not idempotent"

  collision="$work/init-collision"
  mkdir -p "$collision/specs"
  printf 'keep\n' >"$collision/specs/sentinel"
  expect_failure "init with an existing specs directory" "$repo_root/skills/dot-ai-init/scripts/dot-ai-init.sh" "$collision"
  assert_file "$collision/specs/sentinel"
  [ ! -e "$collision/dot-ai" ] || fail "init changed target after specs collision"
  pass "init"
}

run_index() {
  target="$work/index-target"
  "$repo_root/skills/dot-ai-init/scripts/dot-ai-init.sh" "$target" >/dev/null
  write_intent "$target" "001-example" "active"
  "$repo_root/skills/dot-ai-init/scripts/dot-ai-index.sh" "$target" >/dev/null
  assert_contains "$target/dot-ai/INDEX.md" "| 001-example | active | rapida |"
  sed -i.bak 's/^status: active$/status: unknown/' "$target/dot-ai/tracks/001-example/intent.md"
  rm -f "$target/dot-ai/tracks/001-example/intent.md.bak"
  expect_failure "index with invalid status" "$repo_root/skills/dot-ai-init/scripts/dot-ai-index.sh" "$target"
  assert_contains "$work/failure.err" "invalid status: unknown"
  pass "index"
}

run_constitution() {
  constitution="$repo_root/.specify/memory/constitution.md"
  assert_contains "$constitution" "Each script and template has one owner skill"
  assert_not_contains "$constitution" 'the `shared` link is load-bearing'
  assert_contains "$constitution" "Version change: 1.0.0"
  pass "constitution"
}

run_approval() {
  gate="$repo_root/skills/dot-ai-plan/scripts/sdd-gate.sh"
  short="$work/gate-short"
  write_intent "$short" "001-example" "draft"
  write_plan "$short/dot-ai/tracks/001-example/plan.md" "approved"
  write_tasks "$short/dot-ai/tracks/001-example/tasks.md" "approved" "x"
  expect_failure "gate with draft intent" "$gate" --track 001-example --root "$short"

  sed -i.bak 's/^status: draft$/status: active/' "$short/dot-ai/tracks/001-example/intent.md"
  rm -f "$short/dot-ai/tracks/001-example/intent.md.bak"
  write_plan "$short/dot-ai/tracks/001-example/plan.md" "draft"
  expect_failure "gate with unapproved plan" "$gate" --track 001-example --root "$short"

  write_plan "$short/dot-ai/tracks/001-example/plan.md" "approved"
  write_tasks "$short/dot-ai/tracks/001-example/tasks.md" "draft" "x"
  expect_failure "gate with unapproved tasks" "$gate" --track 001-example --root "$short"

  write_tasks "$short/dot-ai/tracks/001-example/tasks.md" "approved" " "
  expect_failure "gate with open short-cycle task" "$gate" --track 001-example --root "$short"

  write_tasks "$short/dot-ai/tracks/001-example/tasks.md" "approved" "x"
  "$gate" --track 001-example --root "$short" >/dev/null

  full="$work/gate-full"
  write_intent "$full" "002-example" "active" "completa"
  mkdir -p "$full/dot-ai/tracks/002-example/spec"
  printf '# Spec\n' >"$full/dot-ai/tracks/002-example/spec/spec.md"
  write_plan "$full/dot-ai/tracks/002-example/spec/plan.md" "approved"
  write_tasks "$full/dot-ai/tracks/002-example/spec/tasks.md" "approved" " "
  expect_failure "gate with open full-cycle task" "$gate" --track 002-example --root "$full"

  write_tasks "$full/dot-ai/tracks/002-example/spec/tasks.md" "approved" "x"
  "$gate" --track 002-example --root "$full" >/dev/null
  pass "approval gate"
}

assert_installed_layout() {
  agents_dir="$1"
  claude_dir="$2"
  count=0
  for skill in "$repo_root"/skills/dot-ai-*; do
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
  audit="$repo_root/dot-ai/tracks/001-skill-standards/spec/audit.md"
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
  init_skill="$repo_root/skills/dot-ai-init/SKILL.md"
  intent_skill="$repo_root/skills/dot-ai-intent/SKILL.md"
  plan_skill="$repo_root/skills/dot-ai-plan/SKILL.md"

  for resource in './scripts/dot-ai-init.sh' './scripts/dot-ai-index.sh' './assets/AGENTS-snippet.md'; do
    assert_contains "$init_skill" "$resource"
  done
  for resource in './assets/intent.md' './scripts/dot-ai-specify.sh'; do
    assert_contains "$intent_skill" "$resource"
  done
  for resource in './assets/plan.md' './assets/tasks.md' './assets/decisions.md' './scripts/sdd-gate.sh'; do
    assert_contains "$plan_skill" "$resource"
  done
  assert_contains "$plan_skill" 'spec/plan.md'
  assert_contains "$plan_skill" 'spec/tasks.md'
  assert_contains "$plan_skill" 'set frontmatter `status: approved` in both files'
  pass "resource guidance"
}

run_specify() {
  wrapper="$repo_root/skills/dot-ai-intent/scripts/dot-ai-specify.sh"
  target="$work/specify-active"
  mkdir -p "$target/dot-ai/specs" "$target/.specify"
  ln -s dot-ai/specs "$target/specs"
  write_intent "$target" "001-example" "active" "completa"
  output="$(cd "$target" && "$wrapper" --track 001-example -- Build the example)"

  printf '%s\n' "$output" | grep -Fq '/speckit.specify --number 1 --short-name example --allow-existing-branch Build the example' || fail "wrapper emitted the wrong OMP command"
  assert_dir "$target/dot-ai/tracks/001-example/spec"
  [ -L "$target/dot-ai/specs/001-example" ] || fail "wrapper did not create the specs view"
  [ "$(readlink "$target/dot-ai/specs/001-example")" = "../tracks/001-example/spec" ] || fail "specs view has the wrong target"
  assert_contains "$target/.specify/feature.json" '"feature_directory":"specs/001-example"'

  draft="$work/specify-draft"
  mkdir -p "$draft/dot-ai/specs" "$draft/.specify"
  ln -s dot-ai/specs "$draft/specs"
  write_intent "$draft" "002-example" "draft" "completa"
  if (cd "$draft" && "$wrapper" --track 002-example -- Build the example) >"$work/specify-draft.out" 2>"$work/specify-draft.err"; then
    fail "wrapper accepted a draft intent"
  fi
  [ ! -e "$draft/dot-ai/tracks/002-example/spec" ] || fail "wrapper changed a draft track"

  if (cd "$target" && "$wrapper" --track 01-Invalid -- Build the example) >"$work/specify-invalid.out" 2>"$work/specify-invalid.err"; then
    fail "wrapper accepted an invalid track id"
  fi
  pass "specify bridge"
}

run_contract() {
  contract="$repo_root/dot-ai/tracks/001-skill-standards/spec/contracts/skill-package.md"
  assert_contains "$contract" "Sibling owner paths"
  assert_contains "$contract" "../dot-ai-init/scripts/dot-ai-index.sh"
  assert_not_contains "$contract" "is forbidden; the owner copy path"
  pass "package contract"
}

run_case() {
  case "$1" in
    self) run_self ;;
    init) run_init ;;
    index) run_index ;;
    constitution) run_constitution ;;
    approval) run_approval ;;
    install) run_install ;;
    audit) run_audit ;;
    resources) run_resources ;;
    specify) run_specify ;;
    contract) run_contract ;;
    *) fail "unknown eval: $1" ;;
  esac
}

if [ "$mode" = "all" ]; then
  for eval_name in self init index constitution approval install audit resources specify contract; do
    run_case "$eval_name"
  done
  pass "all evals"
else
  run_case "$mode"
fi
