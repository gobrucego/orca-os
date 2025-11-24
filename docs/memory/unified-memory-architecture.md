# Unified Memory Architecture - Implementation Plan

## Problem Statement
Every Claude Code session starts blind, requiring manual context loading and burning massive tokens on repeated `query_context()` calls. Multiple sophisticated memory systems exist but don't communicate.

## Solution Architecture

### 1. Memory System Hierarchy

```
┌─────────────────────────────────────────────────────┐
│                  SESSION START                       │
│  Loads cached context automatically (zero tokens)    │
└──────────────┬──────────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────────┐
│              SHARED CONTEXT (Cache Layer)            │
│  - Caches ProjectContext results                     │
│  - 40-50% token reduction                           │
│  - Cross-session persistence                        │
└──────────────┬──────────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────────┐
│            PROJECT CONTEXT (When Cache Miss)         │
│  - Full project analysis                            │
│  - Standards, decisions, history                    │
│  - Updates SharedContext cache                      │
└──────────────┬──────────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────────┐
│           VIBE MEMORY (Local DB + Vectors)          │
│  - SQLite with FTS5 + embeddings                    │
│  - Semantic search across codebase                  │
│  - Response Awareness tracking                      │
└──────────────┬──────────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────────┐
│              WORKSHOP (Knowledge Base)               │
│  - Decisions, gotchas, preferences                  │
│  - Session summaries                                │
│  - Historical context                               │
└──────────────────────────────────────────────────────┘
```

### 2. Integration Points

#### A. Enhanced SessionStart Hook
```bash
#!/usr/bin/env bash
# ~/.claude/hooks/session-start.sh

# 1. Load Workshop context
workshop context

# 2. Check SharedContext cache
PROJECT_HASH=$(pwd | sha256sum | cut -c1-16)
CACHE_STATUS=$(check_shared_context "$PROJECT_HASH")

if [ "$CACHE_STATUS" = "hit" ]; then
    echo "Loading cached project context (zero tokens)..."
    # Context already in SharedContext, available to Claude
else
    echo "Cache miss - will load on first query_context call"
    # Mark for lazy loading
fi

# 3. Initialize vibe-memory if needed
if [ ! -f ".claude/memory/vibe.db" ]; then
    python3 ~/.claude/scripts/memory-index.py --init
fi

# 4. Write consolidated context
cat > .claude/orchestration/temp/session-context.md << EOF
# Session Context Loaded

## Workshop Knowledge
$(workshop recent --limit 10)

## Project Context
Cache Status: $CACHE_STATUS
Project: $(basename $(pwd))

## Available Memory Tools
- memory.search (vibe-memory MCP)
- query_context (ProjectContext MCP with caching)
- Workshop CLI commands
EOF
```

#### B. ProjectContext + SharedContext Integration
```python
# ~/.claude/scripts/integrate-context-cache.py
import json
from pathlib import Path
import hashlib

def get_project_hash(project_path: str) -> str:
    """Generate stable hash for project."""
    return hashlib.sha256(project_path.encode()).hexdigest()[:16]

def query_context_with_cache(domain: str, task: str, project_path: str):
    """Wrap query_context with SharedContext caching."""

    project_hash = get_project_hash(project_path)
    cache_key = f"{project_hash}:{domain}:{task}"

    # Try SharedContext first
    try:
        cached = shared_context.get_shared_context(project_id=cache_key)
        if cached and cached.get('version'):
            print(f"Cache hit! Using cached context (saved {cached['token_savings']} tokens)")
            return cached['context']
    except:
        pass

    # Cache miss - call ProjectContext
    result = project_context.query_context(
        domain=domain,
        task=task,
        projectPath=project_path
    )

    # Update SharedContext cache
    shared_context.update_shared_context(
        project_id=cache_key,
        context=result
    )

    return result
```

#### C. Memory-Aware ORCA Wrapper
```python
# ~/.claude/scripts/orca-with-memory.py
#!/usr/bin/env python3

import sys
import json
from pathlib import Path

def search_memory_first(query: str, mode: str = "all"):
    """Search local memory before calling expensive APIs."""

    # 1. Search vibe-memory (local DB)
    vibe_results = memory_search(query, mode="semantic")

    # 2. Search Workshop
    workshop_results = workshop_search(query)

    # 3. Combine and rank
    return {
        'local_matches': vibe_results,
        'decisions': workshop_results.get('decisions', []),
        'gotchas': workshop_results.get('gotchas', []),
        'used_cache': True
    }

def orca_with_memory(task: str, domain: str):
    """ORCA wrapper that uses memory first."""

    print(f"🧠 Searching memory for: {task}")

    # Search memory FIRST
    memory_context = search_memory_first(task)

    if memory_context['local_matches']:
        print(f"✅ Found {len(memory_context['local_matches'])} relevant memory items")
        # Inject into ORCA context

    # Then proceed with normal ORCA flow
    # but with memory context pre-loaded
```

### 3. Implementation Sequence

1. **Wire SharedContext caching** (scripts/integrate-context-cache.py)
2. **Enhance SessionStart hook** to check cache and load context
3. **Complete vibe-memory MCP** implementation
4. **Create unified memory search** that queries all systems
5. **Wrap ORCA commands** to use memory first
6. **Add vector embeddings** for semantic search

### 4. Expected Outcomes

- **Session starts with context loaded** - No manual prompting
- **Zero tokens for cached queries** - SharedContext handles repeats
- **Memory search before API calls** - Local DB first
- **Unified knowledge base** - All systems connected
- **Works for ALL sessions** - Not just ORCA

### 5. Token Savings Calculation

Current (broken):
- SessionStart: 0 tokens (doesn't load anything)
- First query_context: ~50k tokens
- Each repeat: ~50k tokens
- Total per session: 150k+ tokens

After integration:
- SessionStart: 0 tokens (loads from cache)
- First query_context: ~50k tokens (then cached)
- Each repeat: 0 tokens (from cache)
- Total per session: ~50k tokens

**Savings: ~66% reduction in token usage**