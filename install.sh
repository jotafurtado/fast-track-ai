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

relpath() {
  local from_dir to result
  from_dir="$(cd "${1%/}" && pwd)"
  if [ -d "${2%/}" ]; then
    to="$(cd "${2%/}" && pwd)"
  else
    to="$(cd "$(dirname "${2%/}")" && pwd)/$(basename "${2%/}")"
  fi
  result=""
  while [ "$from_dir" != "/" ] && [ "${to#"$from_dir"/}" = "$to" ]; do
    from_dir="$(dirname "$from_dir")"
    result="${result}../"
  done
  if [ "$from_dir" = "/" ]; then
    printf '%s%s' "$result" "${to#/}"
  else
    printf '%s%s' "$result" "${to#"$from_dir"/}"
  fi
}

mkdir -p "$agents_dir"
for skill in "$method_root"/skills/dot-ai-*; do
  [ -d "$skill" ] || continue
  ln -sfn "$skill" "$agents_dir/$(basename "$skill")"
  echo "linked $(basename "$skill") -> $agents_dir"
done

if [ -d "$(dirname "$claude_dir")" ]; then
  mkdir -p "$claude_dir"
  for link in "$agents_dir"/dot-ai-*; do
    [ -e "$link" ] || continue
    ln -sfn "$(relpath "$claude_dir" "$link")" "$claude_dir/$(basename "$link")"
  done
  echo "claude mirrors updated in $claude_dir"
fi
