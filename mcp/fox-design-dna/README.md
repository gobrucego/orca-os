# Fox Design DNA MCP Server

MCP server that exposes **PeptideFox Design DNA v7.0** as tools for OS 2.0
agents. It allows frontend/expo/ios/design agents to:

- Inspect **tokens** (typography, colors, spacing, radius, motion).
- Discover **components** (e.g. `peptide-card`, `tool-panel`, nav, buttons).
- List **cardinal laws** enforced by the design system.

Source design DNA:
- `_explore/design/peptidefox-design-dna-v7.0.json`

## Tools

### `get_tokens`

Return design tokens grouped by kind.

**Input schema:**

```jsonc
{
  "kind": "typography" | "colors" | "spacing" | "radius" | "motion" | "all" // optional, default: "all"
}
```

**Output:** JSON object containing the requested token groups.

---

### `list_components`

List available components and basic metadata.

**Input schema:** `{}`  
**Output:** Array of component descriptors with path, description, and key properties.

---

### `get_component_blueprint`

Return the blueprint for a specific component.

**Input schema:**

```jsonc
{
  "name": "peptide-card" | "tool-panel" | "primary-nav" | "primary"
}
```

**Output:** The component entry from `components` plus any inferred metadata.

---

### `list_cardinal_laws`

Return the list of cardinal law categories defined in the design DNA, with
short descriptions.

**Input schema:** `{}`  
**Output:** Array of `{ id, description }`.

## Running the server

From `mcp/fox-design-dna`:

```bash
npm install
npm run build
npm start
```

By default the server reads:

- `_explore/design/peptidefox-design-dna-v7.0.json` relative to the repo root.

You can override the JSON path via the `FOX_DESIGN_DNA_PATH` environment
variable.

## MCP Client Configuration (Claude Code)

In `~/.claude.json`:

```jsonc
{
  "projects": {
    "/Users/adilkalam/Desktop/peptidefox": {
      "mcpServers": {
        "fox-design-dna": {
          "command": "node",
          "args": [
            "/Users/adilkalam/claude-vibe-config/mcp/fox-design-dna/dist/index.js"
          ],
          "env": {
            "FOX_DESIGN_DNA_PATH": "/Users/adilkalam/claude-vibe-config/_explore/design/peptidefox-design-dna-v7.0.json"
          }
        }
      }
    }
  }
}
```

