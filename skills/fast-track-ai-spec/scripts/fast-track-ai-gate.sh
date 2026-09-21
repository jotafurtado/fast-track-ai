#!/usr/bin/env bash
# fast-track-ai-gate.sh is the structural gate of a track. PASS only with intact, approved, completed artifacts.
# Usage: fast-track-ai-gate.sh --track NNN-slug [--root DIR]
set -euo pipefail

track=""
root="."
while [ $# -gt 0 ]; do
  case "$1" in
    --track) track="${2:-}"; shift 2;;
    --root) root="${2:-.}"; shift 2;;
    *) echo "FAIL: unknown argument: $1"; exit 1;;
  esac
done
[ -n "$track" ] || { echo "FAIL: pass --track NNN-slug"; exit 1; }

frontmatter_field() {
  awk '/^---$/{section++; next} section==1' "$1" |
    sed -n -E "s/^$2:[[:space:]]*//p" |
    head -n 1
}

require_approved() {
  file="$1"
  label="$2"
  [ -f "$file" ] || { echo "FAIL: $track missing $label"; exit 1; }
  status="$(frontmatter_field "$file" status)"
  [ "$status" = "approved" ] || { echo "FAIL: $label status must be approved, got ${status:-missing}"; exit 1; }
}

require_closed_tasks() {
  file="$1"
  open="$(grep -c -- "^- \[ \]" "$file" || true)"
  [ "$open" = "0" ] || { echo "FAIL: $open open task(s) in ${file#"$root"/}"; exit 1; }
}

base="$root/fast-track-ai/tracks/$track"
intent="$base/intent.md"
[ -f "$intent" ] || { echo "FAIL: $track missing intent.md"; exit 1; }
grep -q "^id:" "$intent" || { echo "FAIL: intent without id"; exit 1; }

if [ -e "$base/plan.md" ]; then
  echo "FAIL: $track has plan.md; live tracks must not keep plan.md"
  exit 1
fi

allowed="intent.md spec.md tasks.md decisions.md spec assets"
offenders=""
for entry in "$base"/*; do
  [ -e "$entry" ] || continue
  name="$(basename "$entry")"
  ok=0
  for allowed_name in $allowed; do
    if [ "$name" = "$allowed_name" ]; then ok=1; break; fi
  done
  if [ "$ok" = "0" ]; then offenders="$offenders $name"; fi
done
[ -z "$offenders" ] || { echo "FAIL: loose files outside assets/:$offenders"; exit 1; }

spec="$base/spec.md"
tasks="$base/tasks.md"
[ -f "$spec" ] || { echo "FAIL: $track missing spec.md"; exit 1; }
grep -q "Files:" "$spec" || { echo "FAIL: spec without Files:"; exit 1; }
grep -q "Accept:" "$spec" || { echo "FAIL: spec without Accept:"; exit 1; }
[ -f "$tasks" ] || { echo "FAIL: $track missing tasks.md"; exit 1; }
grep -q "Files:" "$tasks" || { echo "FAIL: tasks without Files:"; exit 1; }
grep -q "Validate:" "$tasks" || { echo "FAIL: tasks without Validate:"; exit 1; }
require_approved "$spec" "spec.md"
require_approved "$tasks" "tasks.md"
require_closed_tasks "$tasks"
echo "PASS: $track cycle intact"
