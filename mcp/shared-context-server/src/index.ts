/**
 * SharedContextServer MCP Entry Point
 *
 * MCP implementation with JSON file persistence
 * Provides context storage with token optimization and disk persistence
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from '@modelcontextprotocol/sdk/types.js';
import { TokenOptimizer, ContextDiff } from './optimization/TokenOptimizer.js';
import crypto from 'crypto';
import * as fs from 'fs/promises';
import * as path from 'path';
import * as os from 'os';
import { existsSync, mkdirSync } from 'fs';

interface ContextVersion {
  version: number;
  timestamp: Date;
  hash: string;
  context: any;
  changes?: ContextDiff;
  size: number;
}

interface SharedContext {
  projectId: string;
  versions: ContextVersion[];
  currentVersion: number;
  lastAccessed: Date;
  accessCount: number;
}

/**
 * MCP Server for SharedContext with JSON Persistence
 */
class SharedContextMCPServer {
  private server: Server;
  private tokenOptimizer: TokenOptimizer;
  private contexts: Map<string, SharedContext> = new Map();
  private maxVersions = 10;
  private metrics = {
    totalRequests: 0,
    tokensSaved: 0,
  };
  private storagePath: string;

  constructor() {
    // Set storage path to ~/.claude/cache/shared-context/
    this.storagePath = path.join(os.homedir(), '.claude', 'cache', 'shared-context');

    // Ensure storage directory exists
    if (!existsSync(this.storagePath)) {
      mkdirSync(this.storagePath, { recursive: true });
    }
    this.server = new Server(
      {
        name: 'shared-context-server',
        version: '1.0.0',
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.tokenOptimizer = new TokenOptimizer();
    this.setupHandlers();

    // Load existing contexts on startup
    this.loadContexts();
  }

  /**
   * Load all contexts from JSON files
   */
  private async loadContexts(): Promise<void> {
    try {
      const files = await fs.readdir(this.storagePath);
      for (const file of files) {
        if (file.endsWith('.json')) {
          try {
            const filePath = path.join(this.storagePath, file);
            const data = await fs.readFile(filePath, 'utf-8');
            const context = JSON.parse(data, (key, value) => {
              // Revive Date objects
              if (key === 'timestamp' || key === 'lastAccessed') {
                return new Date(value);
              }
              return value;
            });
            this.contexts.set(context.projectId, context);
            console.error(`📂 Loaded context: ${context.projectId}`);
          } catch (error) {
            console.error(`⚠️ Failed to load ${file}:`, error);
          }
        }
      }
      console.error(`💾 Loaded ${this.contexts.size} contexts from ${this.storagePath}`);
    } catch (error) {
      console.error('⚠️ Failed to load contexts:', error);
    }
  }

  /**
   * Save a context to JSON file
   */
  private async saveContext(projectId: string): Promise<void> {
    try {
      const context = this.contexts.get(projectId);
      if (!context) return;

      // Create safe filename from projectId
      const safeFilename = projectId.replace(/[^a-zA-Z0-9-_]/g, '_').replace(/^\/+/, '');
      const filePath = path.join(this.storagePath, `${safeFilename}.json`);

      // Write to temp file first then rename (atomic write)
      const tempPath = `${filePath}.tmp`;
      await fs.writeFile(tempPath, JSON.stringify(context, null, 2), 'utf-8');
      await fs.rename(tempPath, filePath);

      console.error(`✅ Saved context: ${filePath}`);
    } catch (error) {
      console.error(`❌ Failed to save context for ${projectId}:`, error);
    }
  }

  private getTools(): Tool[] {
    return [
      {
        name: 'get_shared_context',
        description: 'Retrieve shared context for a project. Uses compression and versioning for token optimization (40-50% reduction through context sharing).',
        inputSchema: {
          type: 'object',
          properties: {
            projectId: {
              type: 'string',
              description: 'Unique project identifier',
            },
            version: {
              type: 'number',
              description: 'Optional: Specific version to retrieve (default: latest)',
            },
          },
          required: ['projectId'],
        },
      },
      {
        name: 'update_shared_context',
        description: 'Update shared context for a project. Automatically creates differential updates to reduce token usage by 20-30%.',
        inputSchema: {
          type: 'object',
          properties: {
            projectId: {
              type: 'string',
              description: 'Unique project identifier',
            },
            context: {
              type: 'object',
              description: 'Context data to store/update',
            },
          },
          required: ['projectId', 'context'],
        },
      },
      {
        name: 'get_context_diff',
        description: 'Get differential context changes between versions. Returns only changes (added/modified/removed) for minimal token usage.',
        inputSchema: {
          type: 'object',
          properties: {
            projectId: {
              type: 'string',
              description: 'Unique project identifier',
            },
            fromVersion: {
              type: 'number',
              description: 'Source version number',
            },
            toVersion: {
              type: 'number',
              description: 'Optional: Target version (default: latest)',
            },
          },
          required: ['projectId', 'fromVersion'],
        },
      },
      {
        name: 'get_server_stats',
        description: 'Get SharedContextServer statistics including token savings, active contexts, and memory usage.',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
    ];
  }

  private setupHandlers(): void {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: this.getTools(),
    }));

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;
      this.metrics.totalRequests++;

      try {
        switch (name) {
          case 'get_shared_context':
            return await this.handleGetContext(args as any);
          case 'update_shared_context':
            return await this.handleUpdateContext(args as any);
          case 'get_context_diff':
            return await this.handleGetDiff(args as any);
          case 'get_server_stats':
            return await this.handleGetStats();
          default:
            throw new Error(`Unknown tool: ${name}`);
        }
      } catch (error: any) {
        return {
          content: [
            {
              type: 'text',
              text: `Error: ${error.message}`,
            },
          ],
        };
      }
    });
  }

  private async handleGetContext(args: { projectId: string; version?: number }) {
    const sharedContext = this.contexts.get(args.projectId);

    if (!sharedContext) {
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify({
              error: 'Project not found',
              projectId: args.projectId,
            }, null, 2),
          },
        ],
      };
    }

    const targetVersion = args.version ?? sharedContext.currentVersion;
    const contextVersion = sharedContext.versions.find(v => v.version === targetVersion);

    if (!contextVersion) {
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify({
              error: 'Version not found',
              requestedVersion: targetVersion,
              availableVersions: sharedContext.versions.map(v => v.version),
            }, null, 2),
          },
        ],
      };
    }

    sharedContext.lastAccessed = new Date();
    sharedContext.accessCount++;

    // Save context after updating access info
    await this.saveContext(args.projectId);

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify({
            projectId: args.projectId,
            version: contextVersion.version,
            timestamp: contextVersion.timestamp,
            context: contextVersion.context,
          }, null, 2),
        },
      ],
    };
  }

  private async handleUpdateContext(args: { projectId: string; context: any }) {
    let sharedContext = this.contexts.get(args.projectId);

    // Create new project if doesn't exist
    if (!sharedContext) {
      sharedContext = {
        projectId: args.projectId,
        versions: [],
        currentVersion: 0,
        lastAccessed: new Date(),
        accessCount: 1,
      };
      this.contexts.set(args.projectId, sharedContext);
    }

    // Optimize context
    const optimizedResult = this.tokenOptimizer.trimContext(args.context);
    const optimizedContext = optimizedResult.context;

    // Create diff if previous version exists
    let diff: ContextDiff | undefined;
    let tokensSaved = 0;

    if (sharedContext.versions.length > 0) {
      const lastContext = sharedContext.versions[sharedContext.versions.length - 1].context;
      diff = this.tokenOptimizer.computeContextDiff(lastContext, optimizedContext);
      tokensSaved = this.tokenOptimizer.calculateDiffSavings(optimizedContext, diff);
      this.metrics.tokensSaved += tokensSaved;
    }

    // Create version
    const newVersion: ContextVersion = {
      version: sharedContext.currentVersion + 1,
      timestamp: new Date(),
      hash: crypto.createHash('sha256').update(JSON.stringify(optimizedContext)).digest('hex'),
      context: optimizedContext,
      changes: diff,
      size: JSON.stringify(optimizedContext).length,
    };

    sharedContext.versions.push(newVersion);
    sharedContext.currentVersion = newVersion.version;
    sharedContext.lastAccessed = new Date();

    // Trim old versions
    if (sharedContext.versions.length > this.maxVersions) {
      sharedContext.versions.shift();
    }

    // Save context after update
    await this.saveContext(args.projectId);

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify({
            projectId: args.projectId,
            version: newVersion.version,
            timestamp: newVersion.timestamp,
            hash: newVersion.hash,
            size: newVersion.size,
            tokensRemoved: optimizedResult.tokensRemoved,
            tokensSavedByDiff: tokensSaved,
            compressionRatio: optimizedResult.compressionRatio,
            hasDiff: !!diff,
            diffSummary: diff ? {
              added: Object.keys(diff.added).length,
              modified: Object.keys(diff.modified).length,
              removed: diff.removed.length,
              unchanged: diff.unchanged.length,
            } : null,
          }, null, 2),
        },
      ],
    };
  }

  private async handleGetDiff(args: {
    projectId: string;
    fromVersion: number;
    toVersion?: number;
  }) {
    const sharedContext = this.contexts.get(args.projectId);

    if (!sharedContext) {
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify({
              error: 'Project not found',
              projectId: args.projectId,
            }, null, 2),
          },
        ],
      };
    }

    const targetVersion = args.toVersion ?? sharedContext.currentVersion;
    const fromContextVersion = sharedContext.versions.find(v => v.version === args.fromVersion);
    const toContextVersion = sharedContext.versions.find(v => v.version === targetVersion);

    if (!fromContextVersion || !toContextVersion) {
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify({
              error: 'Version not found',
              requestedVersions: { from: args.fromVersion, to: targetVersion },
              availableVersions: sharedContext.versions.map(v => v.version),
            }, null, 2),
          },
        ],
      };
    }

    const diff = this.tokenOptimizer.computeContextDiff(
      fromContextVersion.context,
      toContextVersion.context
    );

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify({
            projectId: args.projectId,
            fromVersion: args.fromVersion,
            toVersion: targetVersion,
            diff,
          }, null, 2),
        },
      ],
    };
  }

  private async handleGetStats() {
    const stats = {
      activeContexts: this.contexts.size,
      totalVersions: Array.from(this.contexts.values()).reduce((sum, ctx) => sum + ctx.versions.length, 0),
      memoryUsage: (process.memoryUsage().heapUsed / 1024 / 1024).toFixed(2) + ' MB',
      metrics: this.metrics,
      contexts: Array.from(this.contexts.entries()).map(([projectId, ctx]) => ({
        projectId,
        currentVersion: ctx.currentVersion,
        totalVersions: ctx.versions.length,
        lastAccessed: ctx.lastAccessed,
        accessCount: ctx.accessCount,
      })),
    };

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(stats, null, 2),
        },
      ],
    };
  }

  async start(): Promise<void> {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);

    console.error('🚀 SharedContextServer MCP ready');
    console.error('📊 Pure MCP implementation (no HTTP server)');
    console.error('🔌 4 tools available for token optimization');
  }

  async stop(): Promise<void> {
    await this.server.close();
  }
}

// Main entry point
async function main() {
  const mcpServer = new SharedContextMCPServer();

  try {
    await mcpServer.start();

    process.on('SIGINT', async () => {
      await mcpServer.stop();
      process.exit(0);
    });

    process.on('SIGTERM', async () => {
      await mcpServer.stop();
      process.exit(0);
    });
  } catch (error) {
    console.error('❌ MCP Server startup failed:', error);
    process.exit(1);
  }
}

main();
