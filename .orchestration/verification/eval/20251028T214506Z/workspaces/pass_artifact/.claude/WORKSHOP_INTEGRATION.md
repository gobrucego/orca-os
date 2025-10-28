# Workshop Integration

**Status:** ✅ Complete and Active
**Version:** Workshop 2.8.0
**Last Updated:** 2025-10-26

---

## What is Workshop?

Workshop is a persistent context management system for Claude Code that automatically captures and recalls:

- 📝 **Decisions** with reasoning ("We chose X because Y")
- ⚠️ **Gotchas** and constraints discovered during work
- 👤 **User preferences** revealed in sessions
- 📋 **Session summaries** (what was worked on, files changed)

**Database:** SQLite with FTS5 full-text search
**Location:** `.workshop/workshop.db` (gitignored, per-project)
**Zero cost:** No APIs, no embeddings

---

## Integration Components

### 1. SessionStart Hook
**File:** `.claude/workshop-session-start.sh`
**Purpose:** Displays Workshop context at the beginning of each session

**What it shows:**
- Last activity timestamp
- Recent gotchas and warnings
- Available Workshop commands
- Current session context

### 2. SessionEnd Hook
**File:** `.claude/workshop-session-end.sh` (Python)
**Purpose:** Parses session transcript and stores summary

**What it captures:**
- Files modified during session
- Commands executed
- Workshop entries created
- User requests
- Session duration
- Git branch

### 3. PreCompact Hook
**File:** `.claude/workshop-pre-compact.sh` (Python)
**Purpose:** Preserves context before compaction

**What it does:**
- Records compaction event (auto vs manual)
- Saves current state
- Prevents information loss

---

## Workshop Commands

Available via CLI in any terminal:

```bash
# View current context
workshop context

# Search entries
workshop search <query>

# Add note
workshop note <text>

# Record decision with reasoning
workshop decision <text> -r <reasoning>

# Record gotcha/constraint
workshop gotcha <text>

# View recent entries
workshop recent --limit 10

# Search by type
workshop search --type decision
workshop search --type gotcha
```

---

## How It Works

### Memory Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                       CLAUDE.md                             │
│         (Static Rules - The Constitution)                   │
│  • Design-OCD standards (20/30/40/60 box widths)            │
│  • Evidence requirements (verification before claims)       │
│  • Communication preferences (DO/DON'T lists)               │
│  • Tool usage protocols (automatic, not on request)         │
│  • Quality gate definitions (verification-agent, etc.)      │
└─────────────────────────────────────────────────────────────┘
                            ↓
                    Loads every session
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    Workshop Context                         │
│        (Dynamic History - The Case Law)                     │
│  • Searchable decisions ("We chose X because Y")            │
│  • Gotchas discovered ("Watch out for...")                  │
│  • User preferences learned ("User prefers X over Y")       │
│  • Session history (files changed, what was worked on)      │
└─────────────────────────────────────────────────────────────┘
```

**CLAUDE.md = Static baselines**
**Workshop = Dynamic learned patterns**

### Session Lifecycle

```
Session Start
    ↓
workshop-session-start.sh runs
    ↓
Claude sees Workshop context in system reminder
    ↓
Work happens (files edited, decisions made)
    ↓
Context Compaction (if needed)
    ↓
workshop-pre-compact.sh preserves state
    ↓
Session End
    ↓
workshop-session-end.sh parses transcript
    ↓
Session summary stored in Workshop DB
```

---

## Installation

Workshop is already installed via pipx:

```bash
# Location
~/.local/bin/workshop

# Version
workshop --version  # 2.8.0

# Database
.workshop/workshop.db  # 1.7MB with imported history
```

**Hooks configured in:** `.claude/settings.local.json`

---

## Current Database Stats

```bash
$ workshop recent --limit 10
```

Shows entries from previous sessions including:
- Tool errors encountered
- User preferences migrated from USER_PROFILE.md
- Memory system decisions
- Session summaries

**Total entries:** 666 (imported from 46 historical session files)

---

## Integration with Existing Systems

### Complements ACE Playbook System

**Workshop captures:**
- Individual decisions and gotchas during work
- "Why did we do X?" questions
- Constraints discovered

**ACE Playbook learns:**
- Proven orchestration patterns
- Team compositions that work
- Anti-patterns that failed

**Together:** Workshop = session-level memory, ACE = pattern-level learning

### Works with Native Memory

**~/.claude/CLAUDE.md:**
- Design standards (ASCII diagram system: 20/30/40/60)
- Typography rules (GT Pantheon, Domaine Sans, Supreme LL, Unica77 Mono)
- Communication protocols (evidence over claims)
- Quality gates (verification-agent, design-reviewer)

**Workshop:**
- "We chose PostgreSQL over MySQL because of better JSONB support"
- "Watch out for: xcodebuild requires clean build after schema changes"
- "User prefers mathematical spacing systems over arbitrary values"

---

## Usage Examples

### During Session

Claude can query Workshop context:

```bash
# Check why a decision was made
workshop why "database choice"

# Search for specific gotchas
workshop search "xcodebuild"

# View recent work
workshop recent
```

### After Session

Workshop automatically stores:
- Session summary
- Files modified
- Duration
- Workshop entries created

### Before Compaction

Context is automatically preserved, preventing information loss.

---

## Files Modified

### Created
- `.claude/workshop-session-start.sh` (executable)
- `.claude/workshop-session-end.sh` (executable, Python)
- `.claude/workshop-pre-compact.sh` (executable, Python)
- `.claude/WORKSHOP_INTEGRATION.md` (this file)

### Modified
- `.claude/settings.local.json` (added SessionEnd and PreCompact hooks)

### Database
- `.workshop/workshop.db` (1.7MB, 666 entries)

---

## PATH Configuration

All Workshop hook scripts add `~/.local/bin` to PATH automatically:

**Bash script:**
```bash
export PATH="$HOME/.local/bin:$PATH"
```

**Python scripts:**
```python
os.environ['PATH'] = os.path.expanduser('~/.local/bin') + ':' + os.environ.get('PATH', '')
```

This ensures `workshop` command is available even when hooks run in minimal environments.

---

## Next Steps

Workshop is fully integrated and will:
1. ✅ Load context at every session start
2. ✅ Capture session summaries automatically
3. ✅ Preserve context before compaction
4. ✅ Provide searchable history via CLI

**No further action needed** - the system is live and learning.

---

## Verification

To verify integration is working:

```bash
# Test session-start hook
bash .claude/workshop-session-start.sh

# Check recent entries
~/.local/bin/workshop recent --limit 5

# Search for something
~/.local/bin/workshop search "memory"
```

Expected: JSON output from session-start, recent entries displayed, search results shown.

---

**Status:** All Workshop hooks integrated and tested ✅
