#!/usr/bin/env bash
# kiro-adapter.sh runs ordered user turns as headless Kiro sessions in one
# target workspace and records machine-readable evidence for every turn.
#
# Usage: kiro-adapter.sh --workspace DIR --turns-dir DIR --out DIR
#                        [--model MODEL] [--effort EFFORT] [--timeout SECONDS]
#
# Turns are the files turn-NN.txt in --turns-dir, run in lexical order. Turn 1
# starts a new session; every later turn resumes the previous turn's session
# with --resume-id. A turn that does not succeed stops the sequence.
#
# Output under --out:
#   turns.jsonl                one record per executed turn
#   turn-NN.events.jsonl       raw stream-json events from Kiro
#   turn-NN.stderr             Kiro stderr
#   turn-NN.actions.jsonl      normalized ordered tool-call actions
#   checkpoints/turn-NN/       workspace snapshot after the turn (turn-00 = before turn 1)
#   checkpoints/turn-NN.manifest  sha256 manifest of that snapshot
# Snapshots exclude .git and .kiro. Agent response text stays only in the raw
# events; no record field carries it.
#
# Exit codes: 0 evidence recorded (inspect turns.jsonl for outcomes), 2 usage error.
set -euo pipefail

kiro_cli="${KIRO_CLI:-kiro-cli}"
workspace=""
turns_dir=""
out=""
model=""
effort=""
timeout_seconds=900

usage() {
  echo "ERROR: $1" >&2
  echo "Usage: kiro-adapter.sh --workspace DIR --turns-dir DIR --out DIR [--model MODEL] [--effort EFFORT] [--timeout SECONDS]" >&2
  exit 2
}

while [ $# -gt 0 ]; do
  case "$1" in
    --workspace) workspace="${2:-}"; shift 2;;
    --turns-dir) turns_dir="${2:-}"; shift 2;;
    --out) out="${2:-}"; shift 2;;
    --model) model="${2:-}"; shift 2;;
    --effort) effort="${2:-}"; shift 2;;
    --timeout) timeout_seconds="${2:-}"; shift 2;;
    *) usage "unknown argument: $1";;
  esac
done

[ -d "$workspace" ] || usage "workspace is not a directory: $workspace"
[ -d "$turns_dir" ] || usage "turns dir is not a directory: $turns_dir"
[ -n "$out" ] || usage "--out is required"
case "$timeout_seconds" in ''|*[!0-9]*) usage "timeout must be a positive integer: $timeout_seconds";; esac
[ "$timeout_seconds" -gt 0 ] || usage "timeout must be a positive integer: $timeout_seconds"

mkdir -p "$out/checkpoints"
out="$(cd "$out" && pwd)"
turns_dir="$(cd "$turns_dir" && pwd)"
workspace_logical="$(cd "$workspace" && pwd)"
workspace_real="$(cd "$workspace" && pwd -P)"

checkpoint() {
  name="$1"
  snapshot="$out/checkpoints/$name"
  mkdir -p "$snapshot"
  rsync -a --delete --exclude /.git --exclude /.kiro "$workspace_real/" "$snapshot/"
  (cd "$snapshot" && find . -type f -exec shasum -a 256 {} + | sed 's|  \./|  |' | LC_ALL=C sort -k2) >"$out/checkpoints/$name.manifest"
}

# Runs the command with a wall-clock bound; writes the marker file on timeout.
run_bounded() {
  seconds="$1"; stdout_file="$2"; stderr_file="$3"; marker="$4"; shift 4
  "$@" >"$stdout_file" 2>"$stderr_file" </dev/null &
  pid=$!
  (
    sleep "$seconds"
    if kill -0 "$pid" 2>/dev/null; then
      : >"$marker"
      kill -TERM "$pid" 2>/dev/null || true
      sleep 5
      kill -KILL "$pid" 2>/dev/null || true
    fi
  ) &
  watcher=$!
  rc=0
  wait "$pid" || rc=$?
  pkill -P "$watcher" 2>/dev/null || true
  kill "$watcher" 2>/dev/null || true
  wait "$watcher" 2>/dev/null || true
  return "$rc"
}

normalize_actions() {
  events_file="$1"; turn="$2"
  jq -R -s -c --arg ws "$workspace_logical" --arg wsr "$workspace_real" --argjson turn "$turn" '
    def rel: if type == "string" then (ltrimstr($wsr + "/") | ltrimstr($ws + "/") | ltrimstr("./")) else empty end;
    [split("\n")[] | select(length > 0) | (fromjson? // null)] | to_entries as $all
    | (reduce ($all[] | .value | select(type == "object" and .type == "sessionUpdate" and .data.update.sessionUpdate == "tool_call_update") | .data.update) as $u
        ({}; if $u.status then .[$u.toolCallId] = $u.status else . end)) as $status
    | $all[]
    | select(.value | type == "object" and .type == "sessionUpdate" and .data.update.sessionUpdate == "tool_call")
    | .key as $seq | .value.data.update as $u
    | {
        turn: $turn,
        seq: $seq,
        toolCallId: $u.toolCallId,
        kind: ($u.kind // null),
        tool: ($u._meta.kiro.toolName // null),
        paths: ([($u.locations // [])[]?.path, (($u.content // []) | map(select(.type == "diff")) | .[].path), ($u.rawInput.path // empty)] | map(rel) | unique),
        command: (if $u.kind == "execute" then ($u.rawInput.command // null) else null end),
        input: ($u.rawInput // null),
        status: ($status[$u.toolCallId] // null)
      }
  ' "$events_file"
}

turn_record() {
  turn="$1"; name="$2"; outcome="$3"; exit_code="$4"; duration="$5"; events_file="$6"; actions_file="$7"
  jq -R -s -c --argjson turn "$turn" --arg checkpoint "$name" --arg outcome "$outcome" \
    --argjson exitCode "$exit_code" --argjson duration "$duration" --argjson actions "$(wc -l <"$actions_file" | tr -d ' ')" '
    [split("\n")[] | select(length > 0) | (fromjson? // null) | select(type == "object")] as $events
    | ($events | map(select(.type == "runFinished")) | last) as $finished
    | {
        turn: $turn,
        checkpoint: $checkpoint,
        outcome: $outcome,
        exitCode: $exitCode,
        durationSeconds: $duration,
        sessionId: ([$events[] | .data.sessionId? // empty] | first // null),
        runStatus: ($finished.data.status // null),
        stopReason: ($finished.data.stopReason // null),
        ordered: (($events | any(.type == "runStarted")) and ($finished != null)),
        eventCount: ($events | length),
        actionCount: $actions,
        credits: ([$events[] | select(.type == "metadata") | .data.meteringUsage[]?.value] | add // 0)
      }
  ' "$events_file"
}

classify() {
  exit_code="$1"; events_file="$2"; stderr_file="$3"; marker="$4"
  if [ -e "$marker" ]; then
    echo timeout
  elif [ "$exit_code" -eq 0 ] && jq -e -R -s '[split("\n")[] | select(length > 0) | (fromjson? // null)] | any(.[]; type == "object" and .type == "runFinished" and .data.status == "success")' "$events_file" >/dev/null 2>&1; then
    echo success
  elif grep -Eiq 'not logged in|login required|kiro-cli login|unauthori[sz]ed|authentication (failed|required)|token (has )?expired|expired token' "$stderr_file" 2>/dev/null; then
    # Only CLI stderr is inspected; agent response text never classifies a turn.
    echo auth-failure
  else
    echo error
  fi
}

: >"$out/turns.jsonl"
checkpoint turn-00
cd "$workspace_real"

session_id=""
turn=0
for turn_file in "$turns_dir"/turn-*.txt; do
  [ -f "$turn_file" ] || continue
  turn=$((turn + 1))
  name="$(printf 'turn-%02d' "$turn")"
  events_file="$out/$name.events.jsonl"
  stderr_file="$out/$name.stderr"
  actions_file="$out/$name.actions.jsonl"
  marker="$out/$name.timeout"

  args=(chat --output-format stream-json --trust-all-tools)
  [ -n "$model" ] && args+=(--model "$model")
  [ -n "$effort" ] && args+=(--effort "$effort")
  if [ "$turn" -gt 1 ]; then
    if [ -z "$session_id" ]; then
      jq -n -c --argjson turn "$turn" --arg checkpoint "$name" \
        '{turn: $turn, checkpoint: $checkpoint, outcome: "not-run", reason: "previous turn reported no session id"}' >>"$out/turns.jsonl"
      break
    fi
    args+=(--resume-id "$session_id")
  fi
  args+=("$(cat "$turn_file")")

  started="$(date +%s)"
  exit_code=0
  run_bounded "$timeout_seconds" "$events_file" "$stderr_file" "$marker" "$kiro_cli" "${args[@]}" || exit_code=$?
  duration=$(( $(date +%s) - started ))

  checkpoint "$name"
  normalize_actions "$events_file" "$turn" >"$actions_file" 2>/dev/null || : >"$actions_file"
  outcome="$(classify "$exit_code" "$events_file" "$stderr_file" "$marker")"
  record="$(turn_record "$turn" "$name" "$outcome" "$exit_code" "$duration" "$events_file" "$actions_file")"
  printf '%s\n' "$record" >>"$out/turns.jsonl"

  [ "$outcome" = "success" ] || break
  session_id="$(printf '%s' "$record" | jq -r '.sessionId // empty')"
done

exit 0
