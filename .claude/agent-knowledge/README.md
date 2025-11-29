# Agent Knowledge System

This directory contains learned patterns for OS 2.4 agents. Patterns are discovered during task execution and promoted based on success rates.

## Structure

```
.claude/agent-knowledge/
├── README.md                    # This file
├── nextjs-builder/
│   └── patterns.json           # Patterns for Next.js builder
├── ios-builder/
│   └── patterns.json           # Patterns for iOS builder
├── expo-builder-agent/
│   └── patterns.json           # Patterns for Expo builder
├── research-lead-agent/
│   └── patterns.json           # Patterns for research
└── shopify-liquid-specialist/
    └── patterns.json           # Patterns for Shopify
```

## Pattern Schema

```json
{
  "patterns": [
    {
      "id": "pattern-001",
      "description": "Human-readable description of the pattern",
      "category": "css|architecture|performance|security|...",
      "successCount": 0,
      "failureCount": 0,
      "successRate": 0,
      "status": "candidate|promoted|deprecated",
      "lastUsed": "2025-11-28",
      "examples": ["code example 1", "code example 2"]
    }
  ],
  "metadata": {
    "agentName": "agent-name",
    "created": "2025-11-28",
    "lastUpdated": "2025-11-28",
    "totalPatterns": 0,
    "promotedPatterns": 0,
    "promotionThreshold": {
      "successRate": 0.85,
      "minOccurrences": 10
    }
  }
}
```

## Pattern Lifecycle

1. **Discovery**: Agent finds effective pattern during task
2. **Candidate**: Pattern added with `status: "candidate"`
3. **Tracking**: Success/failure counts updated each use
4. **Promotion**: When `successRate >= 0.85` AND `successCount >= 10`, status becomes `"promoted"`
5. **Deprecation**: If success rate drops below 0.5, flag for review

## How Agents Use This

### At Task Start
```markdown
1. Check if `.claude/agent-knowledge/{agent-name}/patterns.json` exists
2. If exists, read and apply relevant patterns to your work
3. Track which patterns you apply during this task
```

### At Task End
```markdown
1. If you discovered a new effective pattern: add it
2. If you applied an existing pattern successfully: increment successCount
3. If a pattern failed: increment failureCount
```

## Categories

- `css` - Styling patterns
- `architecture` - Code organization, component structure
- `performance` - Optimization patterns
- `security` - Security best practices
- `concurrency` - Async/threading patterns
- `design-system` - Token usage, theming
- `liquid` - Shopify Liquid patterns
- `citations` - Research citation patterns
- `methodology` - Process patterns

## Notes

- Patterns are agent-specific but can be shared across similar agents
- User feedback is the primary signal for pattern success/failure
- Promoted patterns should eventually be considered for promotion to skills
