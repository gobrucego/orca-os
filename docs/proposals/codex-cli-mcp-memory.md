# Proposal: Prefer MCP memory.search for Retrieval in Codex CLI

Status: Draft (PR-ready)
Owner: You
Scope: Codex CLI (open-source harness)

## Goal

Make retrieval deterministic, fast, and private by preferring an MCP `memory.search` tool (when available) for file targeting. Fall back to local heuristics (e.g., `rg`) when MCP is absent. This reduces repo-wide scans, accelerates agent steps, and grounds actions with file:line citations.

## Outcomes

- A thin MCP client in Codex CLI that can:
  - Start/connect to stdio MCP servers
  - Call `initialize`, `tools/list`, `tools/call`
- A retrieval shim used by agents/tools that:
  - If `preferMCP` and `memory.search` is present → call it
  - Else → fallback to `rg`/native search
- Config surface (CLI/config file):
  - `retrieval.preferMCP`: boolean (default: true)
  - `retrieval.memoryServer`: { command, args?, env?, cwd?, timeoutMs? }
- Tests + docs

## API (TypeScript)

```ts
export interface MemoryServerConfig {
  command: string;
  args?: string[];
  env?: Record<string, string>;
  cwd?: string;
  timeoutMs?: number; // per call
}

export interface RetrievalConfig {
  preferMCP?: boolean; // default true
  memoryServer?: MemoryServerConfig; // optional; if omitted, rely on already running server via config
}

export interface RetrievalHit {
  path: string;
  start: number; // 1-based
  end: number;   // 1-based
  score?: number;
  snippet?: string;
}

export async function searchCode(query: string, k: number, cfg: RetrievalConfig): Promise<RetrievalHit[]>;
```

Behavior:
- Try MCP if `preferMCP` and `memory.search` available within `timeoutMs`.
- On MCP error/unavailable → log once; fallback to `rg`.
- `rg` fallback returns matches (path, line, snippet) with conservative defaults for start/end.

## Integration Points

- Retrieval entry (used by agents for “find file/snippet”): call `searchCode(query,k,cfg)`.
- Add a runtime toggle to switch preferMCP on/off.
- Expose MCP status indicator (connected/tool present).

## Tests

- MCP client framing: initialize → tools/list → tools/call (mock server or echo server)
- Retrieval shim:
  - When MCP present: returns MCP results
  - When MCP absent/timeout: uses `rg`; verifies parsing and ordering
  - Edge cases: empty results; non-UTF8; big outputs (truncate safely)

## Troubleshooting

- Timeouts: increase `timeoutMs` (defaults to 3000–5000ms)
- Framing: ensure server prints nothing to stdout except framed messages; logs to stderr
- Server path: use absolute paths or set `cwd` accordingly

## Rollout Plan

1) Land client + shim + tests behind flag
2) Default `preferMCP=true` for new installs; respect existing configs
3) Announce in CHANGELOG with docs and a short demo

---

## Local Demo (this repo)

- You already have a minimal MCP server: `.claude/mcp/memory_server.py`
- A TypeScript client and retrieval shim are in `ext/codex-cli/`
- Try the sample usage in `ext/codex-cli/README.md`

