#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash scripts/port-to-codex-cli.sh /path/to/codex-cli/repo
#
# Copies the minimal MCP memory integration into the target repo under ext/codex-cli/* (or suggest packages/ placement).

TARGET_DIR=${1:-}
if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 /path/to/codex-cli/repo" >&2
  exit 2
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "Target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SRC_DIR="$ROOT_DIR/ext/codex-cli"

if [ ! -d "$SRC_DIR" ]; then
  echo "Source folder missing: $SRC_DIR" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR/ext/codex-cli"
cp -R "$SRC_DIR"/* "$TARGET_DIR/ext/codex-cli/"

echo "Copied ext/codex-cli into: $TARGET_DIR/ext/codex-cli" >&2
echo "Next steps in target repo:" >&2
cat >&2 << 'EOF'
1) Move code into your preferred package layout (e.g., packages/mcp-client, packages/retrieval)
2) Wire retrieval to use retrievalShim.searchCode(query,k,cfg)
3) Add config surface: retrieval.preferMCP, retrieval.memoryServer { command, args, cwd, timeoutMs }
4) (Optional) Add statusline badge using retrieval/src/status.ts
5) (Optional) Integrate patch-preflight summary
EOF

