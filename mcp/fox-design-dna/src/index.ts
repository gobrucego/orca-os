import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from '@modelcontextprotocol/sdk/types.js';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

type DesignDna = {
  version: string;
  tokens?: any;
  components?: any;
  rules?: {
    cardinal_laws?: string[];
  };
};

function loadDesignDna(): DesignDna {
  const customPath = process.env.FOX_DESIGN_DNA_PATH;
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);

  const defaultPath = path.resolve(
    __dirname,
    '../../_explore/design/peptidefox-design-dna-v7.0.json'
  );

  const jsonPath = customPath || defaultPath;

  if (!fs.existsSync(jsonPath)) {
    throw new Error(
      `Fox Design DNA JSON not found at ${jsonPath}. ` +
        `Set FOX_DESIGN_DNA_PATH env var or ensure the file exists.`
    );
  }

  const raw = fs.readFileSync(jsonPath, 'utf8');
  return JSON.parse(raw) as DesignDna;
}

export class FoxDesignDnaServer {
  private server: Server;
  private dna: DesignDna;

  constructor() {
    this.server = new Server(
      {
        name: 'fox-design-dna',
        version: '1.0.0',
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.dna = loadDesignDna();
    this.setupHandlers();
  }

  private setupHandlers(): void {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: this.getTools(),
    }));

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      switch (name) {
        case 'get_tokens':
          return this.handleGetTokens(args as any);
        case 'list_components':
          return this.handleListComponents();
        case 'get_component_blueprint':
          return this.handleGetComponentBlueprint(args as any);
        case 'list_cardinal_laws':
          return this.handleListCardinalLaws();
        default:
          throw new Error(`Unknown tool: ${name}`);
      }
    });
  }

  private getTools(): Tool[] {
    return [
      {
        name: 'get_tokens',
        description:
          'Return PeptideFox design tokens (typography, colors, spacing, radius, motion).',
        inputSchema: {
          type: 'object',
          properties: {
            kind: {
              type: 'string',
              enum: ['typography', 'colors', 'spacing', 'radius', 'motion', 'all'],
              description:
                'Token group to return. Defaults to "all" if omitted.',
            },
          },
          required: [],
        },
      },
      {
        name: 'list_components',
        description:
          'List known PeptideFox components and basic metadata (cards, nav, buttons).',
        inputSchema: {
          type: 'object',
          properties: {},
          required: [],
        },
      },
      {
        name: 'get_component_blueprint',
        description:
          'Get the blueprint for a specific PeptideFox component (e.g., "peptide-card").',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description:
                'Component name, e.g. "peptide-card", "tool-panel", "primary-nav", "primary".',
            },
          },
          required: ['name'],
        },
      },
      {
        name: 'list_cardinal_laws',
        description:
          'List PeptideFox cardinal law categories with short descriptions.',
        inputSchema: {
          type: 'object',
          properties: {},
          required: [],
        },
      },
    ];
  }

  private handleGetTokens(args: { kind?: string } | undefined) {
    const kind = args?.kind ?? 'all';
    const tokens = this.dna.tokens || {};

    let result: any;

    switch (kind) {
      case 'typography':
        result = { typography: tokens.typography ?? {} };
        break;
      case 'colors':
        result = { colors: tokens.colors ?? {} };
        break;
      case 'spacing':
        result = { spacing: tokens.spacing ?? {} };
        break;
      case 'radius':
        result = { radius: tokens.radius ?? {} };
        break;
      case 'motion':
        result = { motion: tokens.motion ?? {} };
        break;
      case 'all':
      default:
        result = tokens;
        break;
    }

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  }

  private handleListComponents() {
    const components = this.dna.components || {};
    const list: any[] = [];

    // Flatten a few known groups for convenience
    const addGroup = (groupName: string) => {
      const group = components[groupName] || {};
      for (const [name, value] of Object.entries(group)) {
        list.push({
          id: `${groupName}.${name}`,
          group: groupName,
          name,
          description: (value as any).description ?? '',
        });
      }
    };

    addGroup('cards');
    addGroup('navigation');
    addGroup('buttons');

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(list, null, 2),
        },
      ],
    };
  }

  private handleGetComponentBlueprint(args: { name: string }) {
    const name = args.name;
    const components = this.dna.components || {};

    const groups = ['cards', 'navigation', 'buttons'];
    let found: any = null;
    let id: string | null = null;

    for (const group of groups) {
      const groupObj = components[group] || {};
      for (const [key, value] of Object.entries(groupObj)) {
        if (key === name) {
          found = value;
          id = `${group}.${key}`;
          break;
        }
      }
      if (found) break;
    }

    if (!found) {
      throw new Error(
        `Component "${name}" not found in design DNA (known groups: ${groups.join(
          ', '
        )}).`
      );
    }

    const result = {
      id,
      name,
      blueprint: found,
    };

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  }

  private handleListCardinalLaws() {
    const laws = this.dna.rules?.cardinal_laws ?? [];

    // Minimal descriptions for now; can be expanded later.
    const descriptions: Record<string, string> = {
      grid_alignment: 'Grid and structural alignment (no auto 1fr auto, consistent row structures).',
      comparison_cards: 'Comparison card alignment and equal height constraints.',
      optical_alignment: 'Optical alignment for icons, headings, bullets, and badges.',
      lines_borders: 'Use of hairlines instead of thick borders; left-border accent rules.',
      hierarchy: 'Visual hierarchy via value, type, lines, and rhythm (not spacing alone).',
      wrapper_nesting: 'Wrapper/container nesting rules; meaningful structure only.',
      color_accents: 'Color and accent usage (blue as primary, lavender as atmospheric only).',
      dark_mode: 'Dark mode base colors and restrictions (no pure black, no neon).',
    };

    const result = laws.map((id: string) => ({
      id,
      description: descriptions[id] ?? '',
    }));

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  }

  async run(): Promise<void> {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('FoxDesignDnaServer v1.0.0 started');
  }
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const server = new FoxDesignDnaServer();
  server.run().catch(console.error);
}

