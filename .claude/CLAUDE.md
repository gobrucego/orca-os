# Workshop CLI Integration

This project uses Workshop, a persistent context tool for maintaining institutional knowledge across sessions.

**Note for Windows:** Workshop hooks are currently disabled on Windows due to Claude Code freezing issues. You'll need to manually run Workshop commands to load context and capture sessions. Start each session with `claude-workshop context` to load existing knowledge.

## Workshop Commands

**At the start of each session (especially on Windows):**
- Run `claude-workshop context` to load project knowledge
- Run `claude-workshop recent` to see what was worked on recently
- Run `claude-workshop why "<topic>"` if you need to understand past decisions

**Use Workshop liberally throughout the session to:**
- Record decisions: `claude-workshop decision "<text>" -r "<reasoning>"`
- Document gotchas: `claude-workshop gotcha "<text>" -t tag1 -t tag2`
- Add notes: `claude-workshop note "<text>"`

**Query context (use these frequently!):**
- `claude-workshop why "<topic>"` - THE KILLER FEATURE! Answers "why did we do X?" - prioritizes decisions with reasoning
- `claude-workshop context` - View session summary
- `claude-workshop search "<query>"` - Find relevant entries
- `claude-workshop recent` - Recent activity
- `claude-workshop info` - Database statistics

**Important:** Workshop helps maintain continuity across sessions. Document architectural decisions, failed approaches, user preferences, and gotchas as you discover them.

**Best Practice:** When you wonder "why did we choose X?" or "why is this implemented this way?", run `claude-workshop why "X"` first before asking the user!

## Importing Past Sessions

Workshop can import context from past Claude Code sessions stored in JSONL transcript files:

- **When to suggest:** If the user mentions wanting context from previous sessions, or asks "why" questions that might be answered by historical context, suggest running `claude-workshop import --execute`
- **First-time import:** Always ask the user before running import for the first time - it can extract hundreds of entries from historical sessions
- **What it does:** Analyzes JSONL transcripts and automatically extracts decisions, gotchas, and preferences from past conversations
- **Command:** `claude-workshop import --execute` (without --execute it's just a preview)
- **Location:** By default, imports from the current project's JSONL files in `~/.claude/projects/`

**Important:** You have permission to run `claude-workshop import --execute`, but always ask the user first, especially if import has never been run in this project. Let them decide if they want to import historical context.
