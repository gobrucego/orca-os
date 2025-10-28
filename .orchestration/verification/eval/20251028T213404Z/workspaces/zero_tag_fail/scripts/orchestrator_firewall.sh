#!/usr/bin/env bash
set -euo pipefail

# Orchestrator Firewall (Phase 5)
# Prevents workflow-orchestrator from performing write/edit/delete actions.
# Allows specialists and benign reads. Mode and bypass controlled via .orchestration/mode.json and env.

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

MODE_FILE=".orchestration/mode.json"

ACTOR="${ORCHESTRATION_ACTOR:-unknown}"
ACTION="${1:-}"
TARGET="${2:-}"

# Default mode
FIREWALL_STATE="on"

if [ -f "$MODE_FILE" ]; then
  # Parse simple key from JSON without jq
  FIREWALL_STATE=$(sed -n 's/.*"firewall"\s*:\s*"\([^"]*\)".*/\1/p' "$MODE_FILE" | head -1 || true)
  FIREWALL_STATE=${FIREWALL_STATE:-on}
fi

log() { echo "[orchestrator_firewall] $*"; }
deny() { echo "[orchestrator_firewall] DENY: $*" >&2; exit 78; }

if [ "$FIREWALL_STATE" = "off" ]; then
  exit 0
fi

# Allow if actor is not orchestrator
if [ "$ACTOR" != "workflow-orchestrator" ]; then
  exit 0
fi

# Allow benign or unspecified action
case "${ACTION}" in
  read|ls|grep|rg|cat|stat|view|preview|none|"") exit 0 ;;
esac

# Block dangerous actions for orchestrator unless explicit bypass token provided
if [ -z "${CONFIRM_TOKEN:-}" ]; then
  deny "actor=$ACTOR action=$ACTION target=${TARGET:-n/a} — Set CONFIRM_TOKEN to bypass (not recommended)."
fi

log "BYPASS: actor=$ACTOR action=$ACTION target=${TARGET:-n/a}"
exit 0

