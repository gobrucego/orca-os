#!/usr/bin/env bash
set -euo pipefail

# Fast lane for design tweaks
# - Prepares an evidence folder
# - Adds helpful instructions
# - Runs finalize in Prototype profile (lower evidence threshold)

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

ORCH_DIR=".orchestration"
EVIDENCE_DIR="$ORCH_DIR/evidence"
IMPL_LOG="$ORCH_DIR/implementation-log.md"

cmd=${1:-prep}
arg=${2:-}

case "$cmd" in
  prep)
    ts=$(date -u '+%Y%m%dT%H%M%SZ')
    task="design-$ts"
    dir="$EVIDENCE_DIR/$task"
    mkdir -p "$dir"
    echo "Prepared evidence folder: $dir"
    echo "Suggested screenshot path: $dir/after.png"
    echo "Now: make your change, capture a screenshot to that path, and log tags in $IMPL_LOG"
    if ! rg -n "#SCREENSHOT_CLAIMED" "$IMPL_LOG" >/dev/null 2>&1; then
      cat >> "$IMPL_LOG" << EOF

#FILE_MODIFIED: [path/to/file]
  Lines: [e.g., 12, 24-32]
  Changes: [brief note]

#SCREENSHOT_CLAIMED: $dir/after.png
  Description: [what changed visually]
EOF
      echo "Seeded a tag block in $IMPL_LOG"
    fi
    ;;
  run)
    echo "Running QUICK CONFIRM (no screenshots required, guard warn-only)"
    bash scripts/quick-confirm.sh || true
    ;;
  finalize)
    echo "Running finalize in Prototype profile (min score=3)"
    FINALIZE_PROFILE=prototype bash scripts/finalize.sh || true
    ;;
  guard)
    case "$arg" in
      off)
        if [ -f "$ORCH_DIR/mode.json" ]; then
          tmp=$(mktemp)
          if grep -q '"tweak_ui_guard"' "$ORCH_DIR/mode.json"; then
            sed 's/"tweak_ui_guard"\s*:\s*"[^"]*"/"tweak_ui_guard": "off"/' "$ORCH_DIR/mode.json" > "$tmp"
          else
            sed 's/}/, "tweak_ui_guard": "off"}/' "$ORCH_DIR/mode.json" > "$tmp"
          fi
          mv "$tmp" "$ORCH_DIR/mode.json"
        else
          echo '{"tweak_ui_guard":"off"}' > "$ORCH_DIR/mode.json"
        fi
        echo "Tweak UI Guard set to off"
        ;;
      on|warn|"")
        if [ -f "$ORCH_DIR/mode.json" ]; then
          tmp=$(mktemp)
          if grep -q '"tweak_ui_guard"' "$ORCH_DIR/mode.json"; then
            sed 's/"tweak_ui_guard"\s*:\s*"[^"]*"/"tweak_ui_guard": "warn"/' "$ORCH_DIR/mode.json" > "$tmp"
          else
            sed 's/}/, "tweak_ui_guard": "warn"}/' "$ORCH_DIR/mode.json" > "$tmp"
          fi
          mv "$tmp" "$ORCH_DIR/mode.json"
        else
          echo '{"tweak_ui_guard":"warn"}' > "$ORCH_DIR/mode.json"
        fi
        echo "Tweak UI Guard set to warn"
        ;;
      *) echo "Usage: $0 guard [off|warn]"; exit 2 ;;
    esac
    ;;
  *)
    echo "Usage: $0 [prep|run|finalize|guard [off|warn]]"; exit 2 ;;
esac
