# Agents and Teams Overview

ORCA assembles small, focused teams from 65 specialist agents. User confirms before dispatch.

## Agent Categories

### Planning (2 agents)
- `requirement-analyst` — Elicit requirements, user stories, acceptance criteria
- `system-architect` — Technical design, API specs, data models

### Implementation (15+ agents)
- **iOS**: `swiftui-developer`, `swiftdata-specialist`, `state-architect`, `ios-performance-engineer`
- **Frontend**: `react-18-specialist`, `nextjs-14-specialist`, `css-specialist`, `state-management-specialist`
- **Backend**: `backend-engineer`, `infrastructure-engineer`
- **Mobile**: `android-engineer`, `cross-platform-mobile`

### Quality (3 agents)
- `verification-agent` — Evidence collection (builds, tests, screenshots)
- `test-engineer` — Test creation and execution
- `quality-validator` — Final quality gates

### Specialists (40+ agents)
- **iOS** (20): `combine-networking`, `coredata-expert`, `tca-specialist`, `ios-security-tester`
- **Frontend** (15): `frontend-performance-specialist`, `tailwind-specialist`, `frontend-testing-specialist`
- **Data** (7): `ads-creative-analyst`, `bf-sales-analyst`, `merch-lifecycle-analyst`

## Typical Teams by Task

### iOS Feature (5-6 agents)
```
requirement-analyst → system-architect → swiftui-developer
                                      → swiftdata-specialist
                                      → verification-agent
```

### React Feature (4-5 agents)
```
system-architect → react-18-specialist → css-specialist
                                       → test-engineer
```

### Full Stack (6-8 agents)
```
Planning: requirement-analyst, system-architect
Backend: backend-engineer, infrastructure-engineer
Frontend: nextjs-14-specialist, state-management-specialist
Quality: verification-agent, quality-validator
```

## Team Selection Rules

1. **Start minimal** — 3-5 agents for most tasks
2. **Add specialists for risks** — security, performance, migrations
3. **User confirms always** — No blind dispatch
4. **Evidence required** — Every team includes verification

## Directory Structure
```
agents/
├── core/                 # Orchestrators
├── planning/            # Requirements & architecture
├── implementation/      # Builders
├── quality/            # Verification
└── specialists/        # Platform-specific
    ├── ios/           # 20 iOS specialists
    ├── frontend/      # 15 frontend specialists
    └── data/          # 7 data analysts
```
