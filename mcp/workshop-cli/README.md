# claude-workshop

Persistent project memory CLI for Claude Code sessions.

## Installation

```bash
# Development install
pip install -e .

# Verify installation
claude-workshop --version
```

## Usage

### Initialize database

```bash
claude-workshop init
```

### Record decisions

```bash
claude-workshop decision "Use SQLite for storage" -r "Simple, portable, no server needed"
claude-workshop decision "[nextjs] Use App Router" -r "Better performance, recommended by Next.js" -t routing -t architecture
```

### Record gotchas

```bash
claude-workshop gotcha "Don't use localStorage for auth tokens" -t security
claude-workshop gotcha "[ios] Always test on real devices for haptics"
```

### Record notes

```bash
claude-workshop note "User prefers minimal dependencies"
```

### Query decisions (the killer feature)

```bash
claude-workshop why "authentication"
claude-workshop why "database" --json
```

### Search all entries

```bash
claude-workshop search "routing"
claude-workshop search "security" --type gotcha
```

### Show recent entries

```bash
claude-workshop recent
claude-workshop recent --limit 20
```

### Get session context

```bash
claude-workshop context
```

### Import from JSONL transcripts

```bash
claude-workshop import           # Preview what would be imported
claude-workshop import --execute # Actually import
```

## Storage

Data is stored in `.claude/memory/workshop.db` (SQLite) in each project directory.

Use `--workspace` to specify a different location:

```bash
claude-workshop --workspace /path/to/.claude/memory context
```

## JSON Output

Add `--json` flag for machine-readable output:

```bash
claude-workshop why "auth" --json
claude-workshop search "config" --json
```
