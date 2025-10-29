import { spawn } from "node:child_process";
import { once } from "node:events";
import { EOL } from "node:os";
import { ensureMemoryClient, MemoryServerConfig } from "../../mcp-client/src/index";

export interface RetrievalConfig {
  preferMCP?: boolean;
  memoryServer?: MemoryServerConfig;
}

export interface RetrievalHit {
  path: string;
  start: number;
  end: number;
  score?: number;
  snippet?: string;
}

function parseRgOutput(out: string): RetrievalHit[] {
  // Default rg format: path:line:match
  const hits: RetrievalHit[] = [];
  const lines = out.split(/\r?\n/);
  for (const line of lines) {
    if (!line) continue;
    const m = /^(.+?):(\d+):(.*)$/.exec(line);
    if (!m) continue;
    const [, path, s, snippet] = m;
    const start = parseInt(s, 10) || 1;
    hits.push({ path, start, end: start, snippet: snippet.trim() });
    if (hits.length >= 50) break;
  }
  return hits;
}

async function searchWithRg(query: string, k: number): Promise<RetrievalHit[]> {
  // Use rg for speed; rely on default ripgrep installation.
  // Flags: -n (line numbers), --no-heading, --hidden (optional)
  const args = ["-n", "--no-heading", query];
  const proc = spawn("rg", args, { stdio: ["ignore", "pipe", "pipe"] });
  let out = "";
  let err = "";
  proc.stdout.on("data", (b) => (out += b.toString("utf8")));
  proc.stderr.on("data", (b) => (err += b.toString("utf8")));
  await once(proc, "close");
  if (proc.exitCode !== 0 && !out) {
    // No matches or error
    return [];
  }
  const hits = parseRgOutput(out);
  return hits.slice(0, k);
}

export async function searchCode(query: string, k: number, cfg: RetrievalConfig = {}): Promise<RetrievalHit[]> {
  const preferMCP = cfg.preferMCP !== false; // default true
  if (preferMCP && cfg.memoryServer) {
    try {
      const { client, hasMemoryTool } = await ensureMemoryClient(cfg.memoryServer);
      if (hasMemoryTool) {
        const res = await client.callTool("memory.search", { query, k });
        client.stop();
        if (res && Array.isArray(res.results)) {
          return (res.results as any[]).map((r) => ({
            path: String(r.path),
            start: Number(r.start || 1),
            end: Number(r.end || r.start || 1),
            score: typeof r.score === "number" ? r.score : undefined,
            snippet: typeof r.snippet === "string" ? r.snippet : undefined,
          })).slice(0, k);
        }
      } else {
        client.stop();
      }
    } catch (e) {
      // Swallow and fallback
    }
  }
  return await searchWithRg(query, k);
}

