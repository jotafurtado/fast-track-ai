#!/usr/bin/env bash
# dot-ai-specify.sh prepares the canonical track spec view and emits the Spec Kit OMP command.
# It validates an active completa intent, creates spec/ plus the specs symlink and feature.json,
# then prints the /speckit.specify command for the agent (never executes it).
# Usage: dot-ai-specify.sh --track NNN-slug [-- extra args for /speckit.specify]
set -euo pipefail

track=""
while [ $# -gt 0 ]; do
  case "$1" in
    --track) track="${2:-}"; shift 2;;
    --) shift; break;;
    *) break;;
  esac
done

field() {
  awk '/^---$/{c++; next} c==1' "$1" | grep -E "^$2:" | head -n 1 | sed -E "s/^$2:[[:space:]]*//"
}

[ -n "$track" ] || { echo "ERROR: pass --track NNN-slug" >&2; exit 1; }
if ! [[ "$track" =~ ^[0-9]{3}-[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "ERROR: track must match NNN-slug: $track" >&2
  exit 1
fi

num="${track%%-*}"
short="${track#*-}"
number=$((10#$num))

intent="dot-ai/tracks/$track/intent.md"
[ -f "$intent" ] || { echo "ERROR: $intent does not exist" >&2; exit 1; }

specs="specs"
if [ -L "$specs" ]; then
  specs_target="$(readlink "$specs")"
  [ "$specs_target" = "dot-ai/specs" ] || {
    echo "ERROR: $specs points to $specs_target; expected dot-ai/specs." >&2
    exit 1
  }
elif [ -e "$specs" ]; then
  echo "ERROR: $specs already exists and is not the dot-ai specs view." >&2
  exit 1
else
  echo "ERROR: specs/ symlink missing. Run dot-ai-init.sh." >&2
  exit 1
fi

[ -d "dot-ai/specs" ] || { echo "ERROR: dot-ai/specs missing. Run dot-ai-init.sh." >&2; exit 1; }

id="$(field "$intent" id || true)"
status="$(field "$intent" status || true)"
via="$(field "$intent" via || true)"

[ -n "$id" ] || { echo "ERROR: intent missing id field" >&2; exit 1; }
[ -n "$status" ] || { echo "ERROR: intent missing status field" >&2; exit 1; }
[ -n "$via" ] || { echo "ERROR: intent missing via field" >&2; exit 1; }
[ "$id" = "$track" ] || { echo "ERROR: intent id mismatch: $id" >&2; exit 1; }
[ "$status" = "active" ] || { echo "ERROR: intent status must be active (got: $status)" >&2; exit 1; }
[ "$via" = "completa" ] || { echo "ERROR: intent via must be completa (got: $via)" >&2; exit 1; }

track_spec="dot-ai/tracks/$track/spec"
specs_link="dot-ai/specs/$track"
expected_link="../tracks/$track/spec"

if [ -e "$track_spec" ] && [ ! -d "$track_spec" ]; then
  echo "ERROR: $track_spec exists but is not a directory." >&2
  exit 1
fi

if [ -L "$specs_link" ]; then
  actual="$(readlink "$specs_link")"
  [ "$actual" = "$expected_link" ] || {
    echo "ERROR: $specs_link points to $actual; expected $expected_link." >&2
    exit 1
  }
elif [ -e "$specs_link" ]; then
  echo "ERROR: $specs_link already exists and is not a symlink." >&2
  exit 1
fi

mkdir -p "$track_spec"
if [ ! -e "$specs_link" ]; then
  ln -s "$expected_link" "$specs_link"
fi

mkdir -p .specify
printf '{"feature_directory":"specs/%s"}' "$track" > .specify/feature.json

echo "Run in the agent:"
echo "/speckit.specify --number $number --short-name $short --allow-existing-branch $*"
