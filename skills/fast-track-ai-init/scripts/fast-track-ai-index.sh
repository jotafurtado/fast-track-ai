#!/usr/bin/env bash
# fast-track-ai-index.sh generates fast-track-ai/INDEX.md from frontmatter and validates.
# Usage: fast-track-ai-index.sh [repo-root]. Fails with an objective message on invalid input.
set -euo pipefail

export LC_ALL=C

root="${1:-.}"
ai="$root/fast-track-ai"
errors=0
track_rows=""
ref_rows=""
research_rows=""
assessment_rows=""
decision_rows=""
handoff_rows=""

fail() { echo "ERROR: $1" >&2; errors=$((errors + 1)); }

field() {
  awk '/^---$/{c++; next} c==1' "$1" | grep -E "^$2:" | head -n 1 | sed -E "s/^$2:[[:space:]]*//"
}

require_heading() {
  local file="$1"
  local heading="$2"
  grep -Fqx "$heading" "$file" || fail "$(basename "$file") missing heading: $heading"
}

require_heading_prefix() {
  local file="$1"
  local prefix="$2"
  grep -Fq "$prefix" "$file" || fail "$(basename "$file") missing heading prefix: $prefix"
}

sha256_text() {
  printf '%s' "$1" | shasum -a 256 | awk '{print $1}'
}

inline_source_hash() {
  awk '
    found && !started && $0 == "" { started=1; next }
    found && started { sub(/\r$/, ""); print }
    /^## Source content$/ { found=1 }
  ' "$1" | shasum -a 256 | awk '{print $1}'
}

if [ ! -d "$ai/tracks" ]; then
  echo "ERROR: $ai/tracks missing. Run fast-track-ai-init.sh first." >&2
  exit 1
fi

for intent in "$ai"/tracks/*/intent.md; do
  [ -f "$intent" ] || continue
  track="$(basename "$(dirname "$intent")")"
  id="$(field "$intent" id || true)"
  status="$(field "$intent" status || true)"
  [[ "$track" =~ ^[0-9]{3}-[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "$track invalid track directory name"
  [ -n "$id" ] || { fail "$track missing id field"; continue; }
  [ -n "$status" ] || { fail "$track missing status field"; continue; }
  [ "$id" = "$track" ] || fail "$track id mismatch: $id"
  case "$status" in draft|active|shipped|dropped|superseded) ;; *) fail "$track invalid status: $status";; esac
  if [ "$status" = "superseded" ]; then
    superseded_by="$(field "$intent" superseded_by || true)"
    [ -n "$superseded_by" ] || fail "$track superseded without superseded_by"
  fi
  track_rows="$track_rows| $track | $status |"$'\n'
done

if [ -d "$ai/refs" ]; then
  for ref in "$ai"/refs/*; do
    [ -f "$ref" ] || continue
    name="$(basename "$ref")"
    stem="${name%.md}"
    size="$(wc -c < "$ref" | tr -d ' ')"
    ref_type="$(field "$ref" type || true)"
    captured="$(field "$ref" captured || true)"
    owner="$(field "$ref" owner || true)"
    sha256="$(field "$ref" sha256 || true)"
    content_license="$(field "$ref" content_license || true)"
    source="$(field "$ref" source || true)"
    pin="$(field "$ref" pin || true)"
    retrieved_at="$(field "$ref" retrieved_at || true)"
    status="$(field "$ref" status || true)"

    [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*\.md$ ]] || fail "$name invalid ref filename; expected slug.md"
    [ "$size" -le 512000 ] || fail "$name over 500 KB ($size bytes)"
    [ -n "$captured" ] || fail "$name missing captured field"
    [ -n "$owner" ] || fail "$name missing owner field"
    [ -n "$content_license" ] || fail "$name missing content_license field"
    [[ "$sha256" =~ ^[0-9a-f]{64}$ ]] || fail "$name invalid sha256; expected 64 lowercase hex characters"
    [ -z "$status" ] || fail "$name must not have a status field"

    case "$ref_type" in
      inline)
        [ -z "$source" ] || fail "$name inline ref must not have source"
        [ -z "$pin" ] || fail "$name inline ref must not have pin"
        [ -z "$retrieved_at" ] || fail "$name inline ref must not have retrieved_at"
        require_heading "$ref" "## Source content"
        calculated_inline_hash="$(inline_source_hash "$ref")"
        [ "$sha256" = "$calculated_inline_hash" ] || fail "$name sha256 does not match normalized inline source content"
        ;;
      pointer)
        [ -n "$source" ] || fail "$name pointer ref missing source field"
        if [ -n "$pin" ] && [ -n "$retrieved_at" ]; then
          fail "$name pointer ref must use pin or retrieved_at, not both"
        elif [ -z "$pin" ] && [ -z "$retrieved_at" ]; then
          fail "$name pointer ref requires pin or retrieved_at"
        fi
        if [ -n "$source" ] && [ "$sha256" = "$(sha256_text "$source")" ]; then
          fail "$name sha256 hashes the source locator instead of observed content"
        fi
        ;;
      *) fail "$name invalid type: ${ref_type:-missing}";;
    esac

    for earlier_ref in "$ai"/refs/*; do
      [ -f "$earlier_ref" ] || continue
      [ "$earlier_ref" = "$ref" ] && break
      earlier_hash="$(field "$earlier_ref" sha256 || true)"
      if [ -n "$sha256" ] && [ "$sha256" = "$earlier_hash" ]; then
        fail "$name duplicates content hash from $(basename "$earlier_ref")"
        break
      fi
    done

    ref_rows="$ref_rows| $stem | ${ref_type:-missing} | $captured |"$'\n'
  done
fi

if [ -d "$ai/research" ]; then
  for research in "$ai"/research/*; do
    [ -f "$research" ] || continue
    name="$(basename "$research")"
    stem="${name%.md}"
    captured="$(field "$research" captured || true)"
    owner="$(field "$research" owner || true)"
    status="$(field "$research" status || true)"
    singular_source="$(field "$research" source || true)"

    [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*\.md$ ]] || fail "$name invalid research filename; expected slug.md"
    [ -n "$captured" ] || fail "$name missing captured field"
    [ -n "$owner" ] || fail "$name missing owner field"
    [ -z "$status" ] || fail "$name must not have a status field"
    [ -z "$singular_source" ] || fail "$name must not have a singular source field"
    require_heading "$research" "## Question"
    require_heading "$research" "## Conclusion"
    require_heading "$research" "## Conflicts"
    require_heading "$research" "## Limitations"
    require_heading_prefix "$research" "## Sources"
    research_rows="$research_rows| $stem | $captured |"$'\n'
  done
fi

if [ -d "$ai/assessments" ]; then
  for assessment in "$ai"/assessments/*; do
    [ -f "$assessment" ] || continue
    name="$(basename "$assessment")"
    stem="${name%.md}"
    captured="$(field "$assessment" captured || true)"
    owner="$(field "$assessment" owner || true)"
    scope="$(field "$assessment" scope || true)"
    evaluator="$(field "$assessment" evaluator || true)"
    tracks="$(field "$assessment" tracks || true)"
    status="$(field "$assessment" status || true)"

    [[ "$name" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9]+(-[a-z0-9]+)*\.md$ ]] || fail "$name invalid assessment filename; expected YYYY-MM-DD-slug.md"
    [ -n "$captured" ] || fail "$name missing captured field"
    [ -n "$owner" ] || fail "$name missing owner field"
    [ -n "$scope" ] || fail "$name missing scope field"
    [ -n "$evaluator" ] || fail "$name missing evaluator field"
    [ -n "$tracks" ] || fail "$name missing tracks field"
    [ -z "$status" ] || fail "$name must not have a status field"
    file_date="${stem:0:10}"
    [ -z "$captured" ] || [ "$captured" = "$file_date" ] || fail "$name captured $captured does not match filename date $file_date"
    require_heading "$assessment" "## Conclusion"
    require_heading "$assessment" "## Scope and basis"
    require_heading "$assessment" "## Criteria"
    require_heading "$assessment" "## Findings"
    require_heading "$assessment" "## Evidence against conclusion"
    require_heading "$assessment" "## Limitations"
    require_heading "$assessment" "## Recommendations"
    assessment_rows="$assessment_rows| $stem | $captured |"$'\n'
  done
fi

if [ -d "$ai/decisions" ]; then
  for decision in "$ai"/decisions/*; do
    [ -f "$decision" ] || continue
    name="$(basename "$decision")"
    stem="${name%.md}"
    id="$(field "$decision" id || true)"
    status="$(field "$decision" status || true)"
    date="$(field "$decision" date || true)"
    owner="$(field "$decision" owner || true)"

    [[ "$name" =~ ^[0-9]{3}-[a-z0-9]+(-[a-z0-9]+)*\.md$ ]] || fail "$name invalid decision filename; expected NNN-slug.md"
    [ -n "$id" ] || fail "$name missing id field"
    [ -n "$status" ] || fail "$name missing status field"
    [ -n "$date" ] || fail "$name missing date field"
    [ -n "$owner" ] || fail "$name missing owner field"
    [ -z "$id" ] || [ "$id" = "$stem" ] || fail "$name id mismatch: $id"
    case "$status" in
      accepted|superseded) ;;
      *) fail "$name invalid status: ${status:-missing}";;
    esac
    if [ "$status" = "superseded" ]; then
      superseded_by="$(field "$decision" superseded_by || true)"
      [ -n "$superseded_by" ] || fail "$name superseded without superseded_by"
    fi
    require_heading "$decision" "## Context"
    require_heading "$decision" "## Decision"
    require_heading "$decision" "## Rationale"
    require_heading "$decision" "## Alternatives considered"
    require_heading "$decision" "## Consequences"
    decision_rows="$decision_rows| $stem | $status |"$'\n'
  done
fi

if [ -d "$ai/handoffs" ]; then
  for handoff in "$ai"/handoffs/*; do
    [ -f "$handoff" ] || continue
    name="$(basename "$handoff")"
    stem="${name%.md}"
    captured="$(field "$handoff" captured || true)"
    owner="$(field "$handoff" owner || true)"
    focus="$(field "$handoff" focus || true)"
    status="$(field "$handoff" status || true)"

    [[ "$name" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{4}-(Z|[+-][0-9]{4})-[a-z0-9]+(-[a-z0-9]+)*\.md$ ]] || fail "$name invalid handoff filename; expected YYYY-MM-DD-HHmm-OFFSET-slug.md"
    [[ "$captured" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(Z|[+-][0-9]{2}:[0-9]{2})$ ]] || fail "$name invalid captured timestamp"
    [ -n "$owner" ] || fail "$name missing owner field"
    [ -n "$focus" ] || fail "$name missing focus field"
    [ -z "$status" ] || fail "$name must not have a status field"
    require_heading "$handoff" "## Objective"
    require_heading "$handoff" "## Active user instructions, verbatim"
    require_heading "$handoff" "## Current state"
    require_heading "$handoff" "## Completed"
    require_heading "$handoff" "## P0 next actions"
    require_heading "$handoff" "## P1 next actions"
    require_heading "$handoff" "## Unresolved decisions"
    require_heading "$handoff" "## Relevant paths and durable artifacts"
    require_heading "$handoff" "## Observed command results"
    require_heading "$handoff" "## Blockers and risks"
    require_heading "$handoff" "## First next action"
    handoff_rows="$handoff_rows| $stem | $captured |"$'\n'
  done
fi

{
  printf '# INDEX\n\nGenerated by fast-track-ai-index. Do not edit by hand.\n\n'
  printf '| track | status |\n|---|---|\n%s' "$track_rows"
  printf '\n| ref | type | captured |\n|---|---|---|\n%s' "$ref_rows"
  printf '\n| research | captured |\n|---|---|\n%s' "$research_rows"
  printf '\n| assessment | captured |\n|---|---|\n%s' "$assessment_rows"
  printf '\n| decision | status |\n|---|---|\n%s' "$decision_rows"
  printf '\n| handoff | captured |\n|---|---|\n%s' "$handoff_rows"
} > "$ai/INDEX.md"

if [ "$errors" -gt 0 ]; then
  echo "INDEX generated with $errors error(s)." >&2
  exit 1
fi

echo "INDEX ok at $ai/INDEX.md"
