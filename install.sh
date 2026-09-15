#!/usr/bin/env bash
# install.sh links the dot-ai skills into a harness skills directory.
# Usage: install.sh [--agents-dir DIR] [--claude-dir DIR]
# Defaults: ~/.agents/skills and ~/.claude/skills. Works on any machine.
set -euo pipefail

method_root="$(cd "$(dirname "$0")" && pwd)"
agents_dir="$HOME/.agents/skills"
claude_dir="$HOME/.claude/skills"

while [ $# -gt 0 ]; do
  case "$1" in
    --agents-dir) agents_dir="${2:-}"; shift 2;;
    --claude-dir) claude_dir="${2:-}"; shift 2;;
    *) echo "ERROR: unknown argument: $1" >&2; exit 1;;
  esac
done

mkdir -p "$agents_dir"
for skill in "$method_root"/skills/dot-ai-* "$method_root"/skills/shared; do
  [ -d "$skill" ] || continue
  ln -sfn "$skill" "$agents_dir/$(basename "$skill")"
  echo "linked $(basename "$skill") -> $agents_dir"
done

if [ -d "$(dirname "$claude_dir")" ]; then
  mkdir -p "$claude_dir"
  for link in "$agents_dir"/dot-ai-* "$agents_dir"/shared; do
    [ -e "$link" ] || continue
    ln -sfn "../../.agents/skills/$(basename "$link")" "$claude_dir/$(basename "$link")"
  done
  echo "claude mirrors updated in $claude_dir"
fi
