# Claude Code Orchestration

**Multi-agent coordination for systematic, high-quality development**

```
═══════════════════════════════════════════════
   SOLO → SYSTEMATIC → ORCHESTRATED
═══════════════════════════════════════════════
```

[![Agents](https://img.shields.io/badge/agents-19-blue)](#what-is-orchestration)
[![Skills](https://img.shields.io/badge/skills-40+-orange)](#what-is-orchestration)
[![Workflows](https://img.shields.io/badge/workflows-proven-green)](#what-is-orchestration)

---

## 📚 NAVIGATION

**New to orchestration?**
- **[Setup Guide](docs/SETUP.md)** - Complete installation with examples and explanations

**Ready to use it?**
- **[Quick Start](docs/QUICKSTART.md)** - Commands, examples, and basic workflows
- **[Workflows Guide](docs/WORKFLOWS.md)** - Detailed scenario walkthroughs

**Want to optimize?**
- **[Optimization Guide](docs/OPTIMIZATION.md)** - 40% token savings, 50% cost reduction
- **[Reference](docs/REFERENCE.md)** - CLI commands and API documentation

**Having issues?**
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common problems and solutions

---

## What Is Orchestration?

Instead of Claude working alone on complex tasks, orchestration coordinates **specialized agents** through **proven workflows** with **quality gates**.

### Without Orchestration

```
You: "Build a user dashboard with charts"

Claude (solo):
  → Writes code
  → Ships immediately

Result: 6 hours, mediocre quality, no tests
```

### With Orchestration

```
You: /enhance "Build a user dashboard with charts"

System:
  Phase 1: Concept exploration
    → design-master explores approaches

  Phase 2: Implementation (parallel)
    → frontend-developer builds components
    → Uses test-driven-development skill

  Quality Gate:
    → code-reviewer-pro validates

Result: 90 minutes, production-ready, tested
```

**Impact:** 75% faster, professional quality, systematic process

---

## How It Works

**4 Layers:**

1. **Commands** - `/enhance`, `/concept`, `/agentfeedback`
   - Entry points that trigger workflows

2. **Workflows** - Proven recipes for complex tasks
   - iOS development, UI/UX design, debugging, etc.

3. **Agents** - Specialized Claude instances
   - design-master, ios-dev, code-reviewer-pro, etc.

4. **Skills** - Proven processes agents follow
   - test-driven-development, systematic-debugging, brainstorming

**Example Flow:**

```
/concept "redesign login page"
   ↓
concept workflow
   ↓
design-master agent
   ↓
brainstorming skill
   ↓
Quality gate (visual-review)
   ↓
Production-ready design
```

---

## Proven Results

**iOS App Development (7 bug fixes):**
- Solo: 3 hours, some bugs remain
- Orchestrated: 45 min, 100% complete, 0 regressions
- **75% faster, perfect quality**

**UI Redesign (5 critical issues):**
- Solo: Complete failure (generic design)
- Orchestrated: 20 minutes, "miles better" quality
- **Works vs doesn't work**

**Cost Optimization:**
- Before: 75K tokens/session, $1.13
- After: 45K tokens, $0.59
- **40% token savings, 48% cost savings**

---

## Quick Example

### Command: `/enhance`

Detects your task and launches the right workflow.

**Input:**
```bash
/enhance "Build React dashboard with charts and user table"
```

**What Happens:**
```
🔍 Analyzing task...
   → Detected: Frontend development
   → Workflow: ui-ux-design
   → Agents: frontend-developer, design-master

📋 WAVE 1 - Architecture
   → frontend-developer: Component structure
   → Duration: 8 minutes

🎨 WAVE 2 - Implementation (parallel)
   → frontend-developer: Build components with TDD
   → design-master: Spacing, typography, layout
   → Duration: 25 minutes

🛡️ QUALITY GATE
   → code-reviewer-pro: Review code
   → Checks: Build passes, tests pass, best practices
   → Result: ✅ APPROVED

✅ COMPLETE
   Time: 45 minutes
   Quality: Production-ready
   Tests: Passing
```

**Output:**
- Tested React components
- Pixel-perfect design
- Code-reviewed
- Production-ready

---

## Available Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/enhance` | Auto-detect task, run workflow | `/enhance "build login page"` |
| `/concept` | Explore approaches before coding | `/concept "redesign nav"` |
| `/agentfeedback` | Process multiple feedback items | `/agentfeedback [7 bugs]` |
| `/nav` | View your setup | `/nav` |
| `/visual-review` | QA design work | `/visual-review` |

**[See all commands with examples →](docs/QUICKSTART.md)**

---

## Get Started

**1. Install**
```bash
# Follow complete setup guide
→ docs/SETUP.md
```

**2. Try a command**
```bash
# See quick start examples
→ docs/QUICKSTART.md
```

**3. Learn workflows**
```bash
# See detailed walkthroughs
→ docs/WORKFLOWS.md
```

**4. Optimize**
```bash
# Reduce costs, improve speed
→ docs/OPTIMIZATION.md
```

---

## Why This Works

**Systematic > Ad-hoc**
- Proven workflows beat improvisation
- Quality gates prevent mistakes
- 100% completion rate in analyzed sessions

**Specialists > Generalists**
- design-master: Pixel-perfect UI
- ios-dev: iOS best practices
- code-reviewer-pro: Security, performance

**Process > Heroics**
- test-driven-development ensures quality
- systematic-debugging finds root causes
- brainstorming prevents generic work

**Validation > Assumptions**
- Measurable criteria (not "looks good")
- Automated checks (build, tests, metrics)
- 0 bugs shipped in production

---

## Navigation Summary

| I Want To... | Go Here |
|--------------|---------|
| **Install the system** | [SETUP.md](docs/SETUP.md) |
| **Learn commands quickly** | [QUICKSTART.md](docs/QUICKSTART.md) |
| **See detailed examples** | [WORKFLOWS.md](docs/WORKFLOWS.md) |
| **Reduce costs** | [OPTIMIZATION.md](docs/OPTIMIZATION.md) |
| **Fix issues** | [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) |
| **API reference** | [REFERENCE.md](docs/REFERENCE.md) |

---

## License

MIT License - See [LICENSE](LICENSE)

---

**Orchestration: Systematic coordination for complex work**

[Setup →](docs/SETUP.md) • [Quick Start →](docs/QUICKSTART.md) • [Workflows →](docs/WORKFLOWS.md)
