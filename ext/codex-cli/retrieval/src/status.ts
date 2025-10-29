import { ensureMemoryClient, MemoryServerConfig } from "../../mcp-client/src/index";

export interface MemoryStatus {
  connected: boolean;
  hasTool: boolean;
  error?: string;
}

export async function getMemoryStatus(cfg?: MemoryServerConfig): Promise<MemoryStatus> {
  if (!cfg) return { connected: false, hasTool: false };
  try {
    const { client, hasMemoryTool } = await ensureMemoryClient(cfg);
    client.stop();
    return { connected: true, hasTool: hasMemoryTool };
  } catch (e: any) {
    return { connected: false, hasTool: false, error: e?.message || String(e) };
  }
}

