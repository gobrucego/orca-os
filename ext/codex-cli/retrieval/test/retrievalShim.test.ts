// Pseudo-tests (Jest-style) for retrievalShim behavior.
// In Codex CLI repo, wire into the existing test runner.

import { searchCode } from "../src/retrievalShim";

describe("retrievalShim", () => {
  it("falls back to rg when no MCP config provided", async () => {
    const hits = await searchCode("package.json|README.md", 3, {});
    expect(Array.isArray(hits)).toBe(true);
  });

  it("uses MCP when available (mock server)", async () => {
    // For CI, mock ensureMemoryClient and callTool
    // Here we just assert the function runs without throwing with dummy config
    const hits = await searchCode("query", 3, {
      preferMCP: true,
      memoryServer: { command: "python3", args: [".claude/mcp/memory_server.py"], cwd: process.cwd(), timeoutMs: 1000 },
    } as any);
    expect(Array.isArray(hits)).toBe(true);
  });
});

