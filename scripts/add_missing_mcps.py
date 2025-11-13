#!/usr/bin/env python3
"""
Add missing MCPs (playwright, context7, sequential-thinking) to global config.
"""
import json
from datetime import datetime
from pathlib import Path


def main():
    home = Path.home()
    cfg_path = home / ".claude.json"
    backup_path = home / f".claude.json.backup-{datetime.now().strftime('%Y%m%d-%H%M%S')}"

    # Read current config
    cfg = json.loads(cfg_path.read_text(encoding="utf-8"))

    # Get or create mcpServers
    mcps = cfg.get("mcpServers", {})

    # Add missing MCPs
    missing = {
        "playwright": {
            "type": "stdio",
            "command": "npx",
            "args": ["-y", "@playwright/mcp@latest"],
            "env": {}
        },
        "context7": {
            "type": "stdio",
            "command": "npx",
            "args": ["-y", "@context7/mcp@latest"],
            "env": {}
        },
        "sequential-thinking": {
            "type": "stdio",
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
            "env": {}
        }
    }

    # Add each missing MCP
    for name, config in missing.items():
        if name not in mcps:
            mcps[name] = config
            print(f"✅ Added {name}")
        else:
            print(f"⚠️  {name} already exists, skipping")

    cfg["mcpServers"] = mcps

    # Backup and write
    if cfg_path.exists():
        cfg_path.replace(backup_path)
        print(f"\n📦 Backed up to {backup_path}")

    cfg_path.write_text(json.dumps(cfg, indent=2) + "\n", encoding="utf-8")
    print(f"\n✅ Updated {cfg_path}")
    print(f"\nConfigured MCPs: {', '.join(mcps.keys())}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
