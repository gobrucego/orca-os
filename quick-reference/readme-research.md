# OS 2.4 Research Lane Quick Reference

**Lane:** Research
**Domain:** `research`
**Entrypoint:** `/research [--deep] [--time N] <question>`

---

## 1. When to Use Research

Use `/research` when you need:
- Deep, cited answers to complex questions
- Multi-source verification
- Academic or technical research
- Competitive analysis requiring multiple sources

**Not for:** Simple factual lookups (just ask directly).

---

## 2. Command Usage

```bash
# Standard research (quick, 2-3 sources)
/research What are the best practices for React Server Components?

# Deep research (thorough, 5+ sources, fact-checked)
/research --deep How do leading companies implement feature flags at scale?

# Time-bounded research
/research --time 30 Compare Rust vs Go for CLI tools
```

**Flags:**
| Flag | Effect |
|------|--------|
| `--deep` | Enables deep-writer + fact-checker + citation-gate |
| `--time N` | Sets time budget in minutes |

---

## 3. Agents (8 total)

### Lead & Coordination
| Agent | Role |
|-------|------|
| `research-lead-agent` | Orchestrates research pipeline, coordinates subagents |

### Search & Crawl
| Agent | Role |
|-------|------|
| `research-web-search-subagent` | Executes web searches via Firecrawl |
| `research-site-crawler-subagent` | Deep crawls specific sites for comprehensive data |

### Writing
| Agent | Role |
|-------|------|
| `research-answer-writer` | Standard research answers (quick mode) |
| `research-deep-writer` | Long-form, comprehensive answers (--deep mode) |

### Quality Gates
| Agent | Role |
|-------|------|
| `research-consistency-gate` | Ensures answer consistency across sources |
| `research-citation-gate` | Validates all claims have proper citations |
| `research-fact-checker` | Cross-references facts against multiple sources |

---

## 4. Pipeline Flow

```
/research <question>
    │
    ▼
┌─────────────────────┐
│  research-lead-agent │  ← Coordinates everything
└─────────────────────┘
    │
    ├──► research-web-search-subagent (parallel searches)
    ├──► research-site-crawler-subagent (if specific sites needed)
    │
    ▼
┌─────────────────────┐
│  research-answer-writer │  ← Quick mode
│  OR                      │
│  research-deep-writer    │  ← --deep mode
└─────────────────────┘
    │
    ▼ (--deep only)
┌─────────────────────┐
│  research-fact-checker   │
│  research-consistency-gate│
│  research-citation-gate  │
└─────────────────────┘
    │
    ▼
   Final Report
```

---

## 5. Output Location

Research artifacts are saved to:

```
.claude/research/
├── evidence/       ← Source notes from subagents
├── reports/        ← Final and draft reports
└── cache/          ← Cached search results
```

**Note:** Unlike `.claude/orchestration/temp/`, research artifacts persist across sessions for follow-up queries.

---

## 6. MCP Dependencies

- **Firecrawl MCP** - `mcp__firecrawl__*` for web search and crawling
- **Sequential Thinking MCP** - For structured reasoning in lead agent

---

## 7. Tips

1. **Be specific** - "React Server Components best practices 2024" beats "RSC tips"
2. **Use --deep for decisions** - When the answer matters, pay for thoroughness
3. **Check .claude/research/reports/** - Reports are reusable across sessions
4. **Cite your sources** - All research outputs include source URLs

---

_Version: OS 2.4.1_
