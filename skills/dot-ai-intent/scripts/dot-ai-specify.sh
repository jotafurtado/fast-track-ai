#!/usr/bin/env bash
# dot-ai-specify.sh resolves a track into a Spec Kit command. It validates and emits, never executes.
# Usage: dot-ai-specify.sh --track NNN-slug [-- extra args for specify]
set -euo pipefail

track=""
while [ $# -gt 0 ]; do
  case "$1" in
    --track) track="${2:-}"; shift 2;;
    --) shift; break;;
    *) break;;
  esac
done

[ -n "$track" ] || { echo "ERROR: pass --track NNN-slug" >&2; exit 1; }
[ -f "dot-ai/tracks/$track/intent.md" ] || { echo "ERROR: dot-ai/tracks/$track/intent.md does not exist" >&2; exit 1; }
[ -e "specs" ] || { echo "ERROR: specs/ symlink missing. Run dot-ai-init.sh." >&2; exit 1; }

num="${track%%-*}"
short="${track#*-}"
number=$((10#$num))

echo "Run in the agent:"
echo "/speckit-specify --number $number --short-name $short $*"
echo "Expected spec at: dot-ai/tracks/$track/spec/"
