# Statusline Integration (Tiny)

Show MCP memory status in your statusline UI.

Example (Node/Electron/Web):

```ts
import { getMemoryStatus } from "../retrieval/src/status";

async function memoryBadge() {
  const status = await getMemoryStatus({
    command: "python3",
    args: [".claude/mcp/memory_server.py"],
    cwd: process.cwd(),
    timeoutMs: 1500,
  });
  if (status.connected && status.hasTool) return "MCP mem: on";
  return "MCP mem: off";
}

// Render in your statusline component; refresh every ~30–60s or on toolchain changes
```

