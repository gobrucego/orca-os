import { spawn, ChildProcessWithoutNullStreams } from "node:child_process";
import { once } from "node:events";
import { setTimeout as delay } from "node:timers/promises";

export interface MemoryServerConfig {
  command: string;
  args?: string[];
  env?: Record<string, string>;
  cwd?: string;
  timeoutMs?: number; // per call
}

type Json = any;

interface RpcRequest {
  jsonrpc: "2.0";
  id: number;
  method: string;
  params?: Record<string, unknown>;
}

interface RpcResponse {
  jsonrpc: "2.0";
  id: number | null;
  result?: any;
  error?: { code: number; message: string; data?: any };
}

export class MCPClient {
  private proc: ChildProcessWithoutNullStreams | null = null;
  private nextId = 1;
  private pending = new Map<number, (res: RpcResponse) => void>();
  private buf = Buffer.alloc(0);
  private closed = false;

  constructor(private cfg: MemoryServerConfig) {}

  async start(): Promise<void> {
    if (this.proc) return;
    const { command, args = [], env, cwd } = this.cfg;
    const proc = spawn(command, args, {
      cwd,
      env: { ...process.env, ...env },
      stdio: ["pipe", "pipe", "pipe"],
    });
    this.proc = proc;
    proc.on("exit", () => {
      this.closed = true;
      for (const [, resolve] of this.pending) {
        resolve({ jsonrpc: "2.0", id: null, error: { code: -32000, message: "MCP server exited" } });
      }
      this.pending.clear();
    });
    proc.stdout.on("data", (chunk: Buffer) => this.onData(chunk));
    // consume stderr for logs, but don't spam console
    proc.stderr.on("data", () => {});

    // initialize handshake with simple backoff (2 attempts)
    let lastErr: any = null;
    for (let i = 0; i < 2; i++) {
      try {
        await this.call("initialize", { capabilities: {} });
        lastErr = null;
        break;
      } catch (e) {
        lastErr = e;
        await delay(200);
      }
    }
    if (lastErr) throw lastErr;
  }

  private onData(chunk: Buffer) {
    this.buf = Buffer.concat([this.buf, chunk]);
    for (;;) {
      const headerEnd = this.buf.indexOf("\r\n\r\n");
      if (headerEnd === -1) break;
      const header = this.buf.slice(0, headerEnd).toString("utf8");
      const m = /content-length:\s*(\d+)/i.exec(header);
      if (!m) {
        // drop invalid
        this.buf = this.buf.slice(headerEnd + 4);
        continue;
      }
      const len = parseInt(m[1], 10);
      const total = headerEnd + 4 + len;
      if (this.buf.length < total) break;
      const body = this.buf.slice(headerEnd + 4, total).toString("utf8");
      this.buf = this.buf.slice(total);
      try {
        const msg: RpcResponse = JSON.parse(body);
        if (msg && typeof msg.id === "number" && this.pending.has(msg.id)) {
          const resolve = this.pending.get(msg.id)!;
          this.pending.delete(msg.id);
          resolve(msg);
        }
      } catch (_) {
        // ignore
      }
    }
  }

  async call(method: string, params?: Record<string, unknown>): Promise<any> {
    if (!this.proc || this.closed) throw new Error("MCP server not running");
    const id = this.nextId++;
    const req: RpcRequest = { jsonrpc: "2.0", id, method, params };
    const data = Buffer.from(JSON.stringify(req), "utf8");
    const header = Buffer.from(`Content-Length: ${data.length}\r\n\r\n`);
    const fut = new Promise<RpcResponse>((resolve) => this.pending.set(id, resolve));
    this.proc.stdin.write(header);
    this.proc.stdin.write(data);
    const timeout = this.cfg.timeoutMs ?? 5000;
    const res = await Promise.race([
      fut,
      (async () => {
        await delay(timeout);
        return { jsonrpc: "2.0", id, error: { code: -32000, message: "Timeout" } } satisfies RpcResponse;
      })(),
    ]);
    if ((res as RpcResponse).error) {
      const e = (res as RpcResponse).error!;
      throw new Error(`MCP error ${e.code}: ${e.message}`);
    }
    return (res as RpcResponse).result;
  }

  async listTools(): Promise<{ tools: { name: string }[] }> {
    return await this.call("tools/list");
  }

  async callTool(name: string, args: Record<string, unknown>): Promise<any> {
    const result = await this.call("tools/call", { name, arguments: args });
    // Standardize: expect content array with json part
    if (result && Array.isArray(result.content)) {
      const jsonPart = result.content.find((p: any) => p.type === "json");
      return jsonPart?.json ?? result;
    }
    return result;
  }

  stop() {
    if (!this.proc) return;
    try {
      this.proc.kill();
    } catch {}
    this.proc = null;
    this.closed = true;
  }
}

export async function ensureMemoryClient(cfg: MemoryServerConfig): Promise<{ client: MCPClient; hasMemoryTool: boolean }>
{
  const client = new MCPClient(cfg);
  await client.start();
  const list = await client.listTools();
  const hasMemoryTool = !!(list?.tools || []).find((t) => t.name === "memory.search");
  return { client, hasMemoryTool };
}
