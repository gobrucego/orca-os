#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

OUT_DIR="out/codex-cli-mcp-memory"
PKG_ZIP="out/codex-cli-mcp-memory.zip"
PKG_TGZ="out/codex-cli-mcp-memory.tar.gz"

rm -rf "$OUT_DIR" "$PKG_ZIP" "$PKG_TGZ" 2>/dev/null || true
mkdir -p "$OUT_DIR"

# Copy deliverables
mkdir -p "$OUT_DIR/ext/codex-cli"
cp -R ext/codex-cli/* "$OUT_DIR/ext/codex-cli/" 2>/dev/null || true
mkdir -p "$OUT_DIR/docs/proposals"
cp docs/proposals/codex-cli-mcp-memory.md "$OUT_DIR/docs/proposals/" 2>/dev/null || true

# Write a short README for the package
cat > "$OUT_DIR/README-PACKAGE.md" << 'EOF'
# Codex CLI – MCP memory.search Package

Contents:
- ext/codex-cli/mcp-client/src/index.ts — minimal MCP stdio client
- ext/codex-cli/retrieval/src/retrievalShim.ts — prefers memory.search, fallback to ripgrep
- ext/codex-cli/retrieval/src/status.ts — small status probe for statusline
- ext/codex-cli/patch-preflight/src/index.ts — tiny patch preflight (optional)
- docs/proposals/codex-cli-mcp-memory.md — PR-ready proposal

How to use:
1) Copy ext/codex-cli/* into your Codex CLI repo under appropriate packages (e.g., packages/)
2) Wire retrieval to call retrievalShim.searchCode(query,k,cfg)
3) Add config: retrieval.preferMCP (default true), retrieval.memoryServer { command, args, cwd, timeoutMs }
4) (Optional) Expose statusline badge via retrieval/src/status.ts
5) (Optional) Integrate patch preflight summary

Local demo: see ext/codex-cli/README.md
EOF

# Create archives
mkdir -p out
tar -C out -czf "$PKG_TGZ" "$(basename "$OUT_DIR")"
(
  cd out
  zip -qr "$(basename "$PKG_ZIP")" "$(basename "$OUT_DIR")"
)

echo "Created package: $PKG_TGZ"
echo "Created package: $PKG_ZIP"

