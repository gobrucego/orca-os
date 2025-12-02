# Agent Roster – OS 2.4

**Total: 85 agents** across 9 domains + cross-cutting specialists.

## Agent Enrichment (v2.4.1)

All agents have been enriched with patterns extracted from competitor system prompts:

**Universal Skills (all 85 agents reference these):**
- `cursor-code-style` - Variable naming, control flow, comments
- `lovable-pitfalls` - 7 common mistakes to avoid
- `search-before-edit` - Mandatory grep before modifying files
- `linter-loop-limits` - 3-strike rule for linter loops
- `debugging-first` - Debug tools before code changes

**Lane-Specific Patterns:**
- Next.js: V0/Lovable design rules (color limits, component sizes, contrast ratios)
- iOS: Swift-agents patterns (iOS version checks, @MainActor usage)
- Expo: React Native best practices (FlatList, StyleSheet.create, platform conventions)
- Research: Perplexity citation format (inline citations, 10K word reports)

**Agent-Level Learning:**
- Agents can discover and record patterns to `.claude/agent-knowledge/{agent}/patterns.json`
- Patterns promoted when success rate ≥85% with 10+ occurrences
- Builder agents have Knowledge Persistence footers for self-improvement

## iOS Lane (19 agents)

| Agent | Role |
|-------|------|
| `ios-grand-architect` | Opus orchestrator, coordinates full pipeline |
| `ios-light-orchestrator` | Fast path for simple tasks |
| `ios-architect` | Planning and architecture |
| `ios-builder` | Primary implementation |
| `ios-standards-enforcer` | Standards gate |
| `ios-verification` | Verification gate |
| `ios-swiftui-specialist` | SwiftUI implementation |
| `ios-uikit-specialist` | UIKit implementation |
| `ios-accessibility-specialist` | Accessibility compliance |
| `ios-performance-specialist` | Performance optimization |
| `ios-security-specialist` | Security review |
| `ios-persistence-specialist` | Data persistence (SwiftData, Core Data) |
| `ios-networking-specialist` | Networking and API integration |
| `ios-testing-specialist` | Swift Testing and test design |
| `ios-ui-testing-specialist` | UI testing |
| `ios-spm-config-specialist` | SPM and Xcode config |
| `ios-fastlane-specialist` | Fastlane and CI/CD |
| `ios-ui-reviewer` | UI/UX review |
| `design-dna-guardian` | Design system compliance |

## Next.js Lane (14 agents)

| Agent | Role |
|-------|------|
| `nextjs-grand-architect` | Opus orchestrator |
| `nextjs-light-orchestrator` | Fast path for simple tasks |
| `nextjs-architect` | Planning and architecture |
| `nextjs-builder` | Primary implementation |
| `nextjs-standards-enforcer` | Standards gate |
| `nextjs-css-architecture-gate` | CSS/layout architecture gate (refactor mode) |
| `nextjs-verification-agent` | Verification gate |
| `nextjs-typescript-specialist` | TypeScript patterns |
| `nextjs-tailwind-specialist` | Tailwind CSS |
| `nextjs-layout-specialist` | Layout and structure |
| `nextjs-layout-analyzer` | Layout analysis |
| `nextjs-performance-specialist` | Performance optimization |
| `nextjs-accessibility-specialist` | Accessibility compliance |
| `nextjs-seo-specialist` | SEO optimization |
| `nextjs-design-reviewer` | Design review |

## Expo Lane (11 agents)

| Agent | Role |
|-------|------|
| `expo-grand-orchestrator` | Opus orchestrator |
| `expo-light-orchestrator` | Fast path for simple tasks |
| `expo-architect-agent` | Planning and architecture |
| `expo-builder-agent` | Primary implementation |
| `expo-verification-agent` | Verification gate |
| `expo-aesthetics-specialist` | Design and aesthetics |
| `api-guardian` | API contracts and integration |
| `bundle-assassin` | Bundle size optimization |
| `impact-analyzer` | Change impact analysis |
| `refactor-surgeon` | Safe refactoring |
| `test-generator` | Test generation |

## Shopify Lane (8 agents)

| Agent | Role |
|-------|------|
| `shopify-grand-architect` | Opus orchestrator |
| `shopify-light-orchestrator` | Fast path for simple tasks |
| `shopify-css-specialist` | CSS and design tokens |
| `shopify-liquid-specialist` | Liquid templates |
| `shopify-section-builder` | Sections and schemas |
| `shopify-js-specialist` | JavaScript and Web Components |
| `shopify-ui-reviewer` | Visual validation with Playwright MCP |
| `shopify-theme-checker` | Theme Check verification |

**Visual Validation:** The Shopify lane now includes Playwright MCP integration via `shopify-ui-reviewer` for responsive screenshot validation at breakpoints (375px, 768px, 1280px).

## OS-Dev Lane (5 agents) – LOCAL ONLY

| Agent | Role |
|-------|------|
| `os-dev-grand-architect` | Opus orchestrator |
| `os-dev-architect` | Planning OS changes |
| `os-dev-builder` | Implement OS changes |
| `os-dev-standards-enforcer` | Standards gate |
| `os-dev-verification` | Verification gate |

**Note:** OS-Dev agents are LOCAL to claude-vibe-config repo only.

## Data Lane (4 agents)

| Agent | Role |
|-------|------|
| `python-analytics-expert` | Python data analysis |
| `data-researcher` | Data research |
| `research-specialist` | General research |
| `competitive-analyst` | Competitive analysis |

## Research Lane (8 agents)

| Agent | Role |
|-------|------|
| `research-lead-agent` | Lead researcher, plans multi-agent research |
| `research-web-search-subagent` | Firecrawl-first web search & scraping |
| `research-site-crawler-subagent` | Firecrawl site mapping & crawling |
| `research-answer-writer` | Structured answer writer (standard mode) |
| `research-deep-writer` | Long-form academic writer (deep mode) |
| `research-citation-gate` | Citation insertion and audit |
| `research-consistency-gate` | Consistency and limitations gate |
| `research-fact-checker` | Optional fact validation gate |

## OBDN Lane (4 agents) – KG Research

| Agent | Role |
|-------|------|
| `kg-lead-agent` | Lead researcher, KG-first planning |
| `kg-query-subagent` | KG tool queries (find, show, neighbors) |
| `kg-mechanism-subagent` | Mechanism path mapping |
| `kg-answer-writer` | KG-grounded report writing |

**Note:** OBDN agents use the Knowledge Graph (`docs/meta/kg.json`) as primary
evidence for peptide/protocol/mechanism research.

## SEO Lane (4 agents)

| Agent | Role |
|-------|------|
| `seo-research-specialist` | SEO research |
| `seo-brief-strategist` | Content briefs |
| `seo-draft-writer` | SEO content writing |
| `seo-quality-guardian` | SEO quality review |

## Cross-Cutting Specialists (6 agents)

| Agent | Role |
|-------|------|
| `a11y-enforcer` | Accessibility enforcement |
| `performance-enforcer` | Performance checks |
| `performance-prophet` | Performance prediction |
| `security-specialist` | Security audit |
| `design-token-guardian` | Design token compliance |
| `design-system-architect` | Design system architecture |

## Agent Roles

### Orchestrators (Never Write Code)
- Grand architects (Opus 4.5)
- Light orchestrators (Opus 4.5, fast path)
- Coordinate via `Task` tool only
- Classify complexity, gather context, delegate

### Specialists (Implement Changes)
- Domain experts
- Use `Read`, `Edit`, `Write` tools
- Report changes back to orchestrator
- Tag assumptions with RA tags

### Gates (Validate Only)
- Standards enforcers
- Verification agents
- Use `Read`, `Bash` for checks
- Report PASS/CAUTION/FAIL
- Never fix issues

## Agent Definition Location

Agent definitions live in `agents/`:
```
agents/
 iOS/              # iOS specialists
 dev/              # Next.js + OS-Dev
 expo/             # Expo specialists
 shopify/          # Shopify specialists
 research/         # Research specialists
 OBDN/             # KG research specialists
 data/             # Data specialists
 seo/              # SEO specialists
 *.md              # Cross-cutting specialists
```

Each agent is a markdown file with YAML frontmatter:
```yaml
---
name: agent-name
description: What the agent does
tools: Read, Edit, MultiEdit, Grep, Glob, Bash
---

# Agent Title

Agent instructions...
```

**Note:** All agents use Opus 4.5 (default). No model line needed. Tools MUST be comma-separated strings, NOT YAML arrays.
