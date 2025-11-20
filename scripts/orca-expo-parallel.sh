#!/usr/bin/env bash
#
# Simple helper to run multiple /orca-expo tasks in parallel for a project.
# Example (from your Expo repo root):
#   ./scripts/orca-expo-parallel.sh \
#     "My Protocols: Wire components + glass chrome" \
#     "Protocol Builder: Wire components + glass chrome" \
#     "Schedule: Restructure data grouping" \
#     "Inventory: Polish empty state + glass chrome"
#
# Each argument becomes a separate `/orca-expo` invocation running concurrently.

set -euo pipefail

CLI_BIN="${CLAUDE_CLI_BIN:-claude}"

if ! command -v "$CLI_BIN" >/dev/null 2>&1; then
  echo "Error: CLI binary '$CLI_BIN' not found in PATH." >&2
  echo "Set CLAUDE_CLI_BIN to your CLI (e.g. 'claude' or 'codex') and retry." >&2
  exit 1
fi

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 \"task 1\" \"task 2\" ..." >&2
  echo "Each argument is passed to /orca-expo as the request string." >&2
  exit 1
fi

echo "Launching $#/orca-expo tasks in parallel using '$CLI_BIN'..."

pids=()
for arg in "$@"; do
  echo "▶ /orca-expo \"$arg\""
  "$CLI_BIN" /orca-expo "$arg" &
  pids+=("$!")
done

status=0
for pid in "${pids[@]}"; do
  if ! wait "$pid"; then
    status=1
  fi
done

if [ "$status" -eq 0 ]; then
  echo "✅ All /orca-expo tasks completed."
else
  echo "⚠️ One or more /orca-expo tasks exited with errors."
fi

exit "$status"

