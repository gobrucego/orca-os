# Agent Roster – OS 2.3

**Total: 62 agents** across 7 domains + cross-cutting specialists.

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
| `nextjs-verification-agent` | Verification gate |
| `nextjs-typescript-specialist` | TypeScript patterns |
| `nextjs-tailwind-specialist` | Tailwind CSS |
| `nextjs-layout-specialist` | Layout and structure |
| `nextjs-layout-analyzer` | Layout analysis |
| `nextjs-performance-specialist` | Performance optimization |
| `nextjs-accessibility-specialist` | Accessibility compliance |
| `nextjs-seo-specialist` | SEO optimization |
| `nextjs-design-reviewer` | Design review |

## Expo Lane (10 agents)

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

## Shopify Lane (7 agents)

| Agent | Role |
|-------|------|
| `shopify-grand-architect` | Opus orchestrator |
| `shopify-light-orchestrator` | Fast path for simple tasks |
| `shopify-css-specialist` | CSS and design tokens |
| `shopify-liquid-specialist` | Liquid templates |
| `shopify-section-builder` | Sections and schemas |
| `shopify-js-specialist` | JavaScript and Web Components |
| `shopify-theme-checker` | Theme Check verification |

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
- Grand architects (Opus model)
- Light orchestrators (Sonnet model, fast path)
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
├── iOS/              # iOS specialists
├── dev/              # Next.js + OS-Dev
├── expo/             # Expo specialists
├── shopify/          # Shopify specialists
├── data/             # Data specialists
├── seo/              # SEO specialists
└── *.md              # Cross-cutting specialists
```

Each agent is a markdown file with YAML frontmatter:
```yaml
---
name: agent-name
description: What the agent does
model: opus|sonnet|inherit
tools:
  - Tool1
  - Tool2
---

# Agent Title

Agent instructions...
```
