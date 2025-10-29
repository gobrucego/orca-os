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
