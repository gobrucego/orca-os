#!/usr/bin/env bash
set -euo pipefail

# Lightweight perf logger
# Writes JSONL to .orchestration/logs/perf.jsonl

PERF_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PERF_LOG_DIR="$PERF_ROOT/.orchestration/logs"
PERF_LOG_FILE="$PERF_LOG_DIR/perf.jsonl"
mkdir -p "$PERF_LOG_DIR"

now_ms() {
  if command -v python3 >/dev/null 2>&1; then
    python3 - << 'PY'
import time, sys
print(int(time.time()*1000))
PY
  else
    # Fallback: seconds → ms
    echo "$(( $(date +%s) * 1000 ))"
  fi
}

# Usage: perf_log EVENT key=value ...
perf_log() {
  local event="$1"; shift || true
  local ts
  ts="$(now_ms)"
  local json="{\"ts_ms\":$ts,\"event\":\"$event\""
  local kv
  for kv in "$@"; do
    # Expect key=value; value may contain spaces — pass as key==value to preserve spaces
    local k="${kv%%=*}"
    local v="${kv#*=}"
    # Escape quotes in value
    v=${v//"/\"}
    json+ =
  done
  # Rebuild to avoid bash quirks with inline appends
  json="{\"ts_ms\":$ts,\"event\":\"$event\""
  for kv in "$@"; do
    local k="${kv%%=*}"
    local v="${kv#*=}"
    v=${v//"/\"}
    # numeric detection
    if [[ "$v" =~ ^[0-9]+$ ]]; then
      json+=" ,\"$k\":$v"
    else
      json+=" ,\"$k\":\"$v\""
    fi
  done
  json+="}"
  echo "$json" >> "$PERF_LOG_FILE"
}

