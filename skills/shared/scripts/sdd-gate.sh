#!/usr/bin/env bash
# sdd-gate.sh is the structural gate of a track. PASS only with intact artifacts.
# Usage: sdd-gate.sh --track NNN-slug [--root DIR]
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

base="$root/dot-ai/tracks/$track"
[ -f "$base/intent.md" ] || { echo "FAIL: $track missing intent.md"; exit 1; }
grep -q "^id:" "$base/intent.md" || { echo "FAIL: intent without id"; exit 1; }
grep -q "^status:" "$base/intent.md" || { echo "FAIL: intent without status"; exit 1; }
allowed="intent.md plan.md tasks.md decisions.md spec assets"
offenders=""
for entry in "$base"/*; do
  [ -e "$entry" ] || continue
  name="$(basename "$entry")"
  ok=0
  for a in $allowed; do
    if [ "$name" = "$a" ]; then ok=1; break; fi
  done
  if [ "$ok" = "0" ]; then offenders="$offenders $name"; fi
done
[ -z "$offenders" ] || { echo "FAIL: loose files outside assets/:$offenders"; exit 1; }

if [ -d "$base/spec" ]; then
  [ -f "$base/spec/spec.md" ] || { echo "FAIL: spec/ without spec.md"; exit 1; }
  echo "PASS: $track full cycle intact"
  exit 0
fi

[ -f "$base/plan.md" ] || { echo "FAIL: short cycle without plan.md"; exit 1; }
grep -q "Files:" "$base/plan.md" || { echo "FAIL: plan without Files:"; exit 1; }
grep -q "Accept:" "$base/plan.md" || { echo "FAIL: plan without Accept:"; exit 1; }
[ -f "$base/tasks.md" ] || { echo "FAIL: missing tasks.md"; exit 1; }
open=$(grep -c -- "- \[ \]" "$base/tasks.md" || true)
[ "$open" = "0" ] || { echo "FAIL: $open open task(s)"; exit 1; }
echo "PASS: $track short cycle intact"
