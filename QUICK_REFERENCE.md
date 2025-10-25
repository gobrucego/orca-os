# Quick Reference

**Fast lookup for commands, practical examples, and how systems work**

---

## ⚡ Commands (What You Type)

### /orca - Full Orchestration
**Use for:** Complex multi-step features, full implementations, architecture changes

**What it does:**
1. Detects your project type (iOS/React/Backend)
2. Dispatches specialist team automatically
3. Executes in parallel (3-5x faster)
4. Provides evidence (screenshots, tests, logs)

**Examples:**
```bash
/orca Add dark mode toggle to settings

/orca Build authentication with OAuth (Google + Apple)

/orca Implement shopping cart with local persistence

/orca Fix memory leak in ImageCache
```

**You get:** Complete implementation + proof it works

---

### /concept - Design Exploration
**Use for:** Before building UI/UX, when you need creative exploration

**What it does:**
1. Studies reference examples and design patterns
2. Extracts principles from your inspirations
3. Brainstorms approach specific to your project
4. Gets your approval BEFORE building

**Examples:**
```bash
/concept Premium dashboard with analytics and data visualizations

/concept Onboarding flow for meditation app

/concept Settings screen with nested categories
```

**Then:** Use `/orca` to build after you approve the concept

**You get:** Design proposal + rationale + visual direction

---

### /enhance - Quick Focused Changes
**Use for:** Small improvements, single-component work, quick iterations

**What it does:**
1. Transforms vague request into structured task
2. Executes with appropriate specialists
3. Tests automatically

**Examples:**
```bash
/enhance Make the calculator button text larger

/enhance Add loading spinner to submit button

/enhance Improve contrast on disabled form fields
```

**You get:** Implementation + automatic testing

---

### /visual-review - Visual QA
**Use for:** After implementing UI, before shipping to production

**What it does:**
1. Screenshots at multiple breakpoints (desktop/tablet/mobile)
2. Analyzes: hierarchy, spacing, typography, colors
3. Checks Design DNA rules (if your project has them)
4. "Eyes test" - does attention go to the right element?

**Examples:**
```bash
/visual-review http://localhost:3000/dashboard

/visual-review http://localhost:3000/checkout

/visual-review Check the new card component at localhost:8080/components
```

**You get:** Multi-device screenshots + visual analysis report + DNA violations (if applicable)

---

### /ultra-think - Deep Analysis
**Use for:** Understanding problems before solving, architectural decisions, performance investigations

**What it does:**
1. Multi-dimensional analysis (no code changes)
2. Identifies root causes and bottlenecks
3. Explores multiple solution approaches
4. Provides recommendations with trade-offs

**Examples:**
```bash
/ultra-think Why is the app slow on startup?

/ultra-think Should we use SwiftData or Core Data for this project?

/ultra-think How should we structure state management for this feature?

/ultra-think What's causing the memory leak in ImageLoader?
```

**Then:** Use `/orca` to implement the recommended fix

**You get:** Comprehensive analysis + recommendations

---

### /playbook-review - Reinforce Learning
**Use for:** After major /orca sessions when you want to explicitly teach the system

**What it does:**
1. Analyzes recent session outcomes
2. Extracts successful and failed patterns
3. Updates learned patterns (helpful_count, harmful_count)
4. Makes system smarter for next time

**Examples:**
```bash
/playbook-review

# After session where design-reviewer caught critical bugs:
# System learns: "design-reviewer prevents production bugs" → helpful_count++

# After session where wrong architecture chosen:
# System learns: "Pattern X failed for use case Y" → harmful_count++
```

**You get:** Updated playbooks (system gets smarter over time)

**Note:** This happens automatically after /orca sessions - manual use is optional

---

### /playbook-pause - Disable Learning
**Use for:** Testing, debugging, when you want clean slate behavior

**What it does:** Temporarily disables ACE playbook system so /orca doesn't use learned patterns

**Examples:**
```bash
/playbook-pause

# Then test /orca without pattern influence
# When done: Learning re-enables automatically next session
```

**Use case:** "I want to see how /orca behaves without historical patterns"

---

### /clarify - Quick Focused Questions
**Use for:** Mid-workflow questions without full orchestration

**What it does:** Answers specific questions without launching full agent teams

**Examples:**
```bash
/clarify What's the difference between SwiftData and Core Data?

/clarify How do I use Design DNA for a new project?

/clarify When should I use /concept vs /orca?
```

**You get:** Direct answer without orchestration overhead

---

### /session-save - Save Context
**Use for:** End of session to preserve state for next time

**What it does:** Saves current session context for automatic resumption

**Example:**
```bash
/session-save

# Next session: Context auto-loads via SessionStart hook
```

**Note:** Usually not needed - SessionStart hook loads context automatically

---

### /session-resume - Reload Context
**Use for:** Manually reload session context if auto-load failed

**What it does:** Reloads saved session context

**Example:**
```bash
/session-resume

# Loads: .claude-session-context.md
```

**Note:** Rarely needed - SessionStart hook does this automatically

---

### /completion-drive - Track Assumptions
**Use for:** Meta-cognitive awareness during complex work

**What it does:** Two-tier assumption tracking for preventing false completions

**Example:**
```bash
/completion-drive

# System prompts you to tag assumptions:
# #COMPLETION_DRIVE: Assuming theme.colors exists
# #FILE_CREATED: src/Calculator.tsx
```

**Use case:** When you need explicit assumption tracking for quality gates

**Note:** Response Awareness system does this automatically - manual use is rare

---

## 🎯 Practical Examples (I Want To...)

### I want to build a feature
```bash
# Just describe it naturally (no command needed)
"Add authentication with OAuth"

# Or use /orca explicitly
/orca Add shopping cart with local storage
```
→ System detects project → Dispatches team → Builds → Tests → Provides evidence

---

### I want to fix a bug
```bash
# Describe the problem
"Login button doesn't work on mobile"

# Or for complex debugging
/ultra-think Why does the app crash on launch?
# Then: /orca [implement the fix]
```
→ System investigates → Identifies root cause → Fixes → Tests → Provides proof

---

### I want to explore a design idea
```bash
/concept Dashboard with analytics and real-time data

# After approval:
/orca Build the approved dashboard design
```
→ Explores references → Proposes approach → Gets approval → Then builds

---

### I want to improve something visually
```bash
/enhance Make the buttons more prominent

/enhance Improve spacing in the card layout

/enhance Add subtle animation to the menu
```
→ Quick focused changes with automatic testing

---

### I want to verify UI quality
```bash
/visual-review http://localhost:3000/checkout

# After implementing new UI
/visual-review Check the new premium card component
```
→ Screenshots + visual analysis + Design DNA checks (if applicable)

---

### I want to understand a problem deeply
```bash
/ultra-think Why is the app slow on first load?

/ultra-think Should we use Redux or Zustand for state?

/ultra-think How do we scale this to handle 10x users?
```
→ Deep analysis → Recommendations → Then use /orca to implement

---

### I want to teach the system
```bash
# After a great session with design-reviewer catching bugs:
/playbook-review

# System learns: "design-reviewer prevents bugs" → helpful_count++
```
→ System gets smarter for future sessions

---

### I want to ask a quick question
```bash
/clarify When should I use SwiftData vs Core Data?

/clarify How do I add Design DNA to a new project?
```
→ Direct answer without full orchestration

---

## 🧬 How Systems Work (Automatically)

### Auto-Orchestration (Always Active)

**What it does:** Detects your project type → Loads appropriate team → You just describe intent

**When it triggers:** Every code change request

**How it works:**
- SessionStart hook checks for: `*.xcodeproj` (iOS), `package.json` (React/Next.js), `requirements.txt` (Python)
- Loads team: 8-18 agents for iOS, 10-17 for Frontend, 6-12 for Backend
- You never specify agents or project type

**Example:**
```
You: "Add authentication"
System: [Detects Next.js] → Dispatches nextjs-14-specialist, backend-engineer, etc.
You: [Get complete auth implementation]
```

---

### Design DNA (Active for OBDN + Projects with DNA)

**What it does:** Programmatic taste enforcement - prevents "looks like shit" first iterations

**When it triggers:** Any UI/design work in projects with `.claude/design-dna/*.json` files

**The pipeline:**
```
Your Request ("Build premium card")
    ↓
style-translator: Request → Design DNA tokens
    ↓
design-compiler: Generates code using tokens as constraints
    ↓
design-dna-linter: Checks spacing, fonts, colors, forbidden patterns
    ↓
Implementation: ui-engineer, swiftui-developer, etc.
    ↓
visual-reviewer-v2: Screenshots + "eyes test" + DNA validation
    ↓
Result: Code that matches your taste (80-90% first-iteration acceptance)
```

**How to use:**
- **If project has DNA:** Just build UI normally - pipeline auto-injects
- **Add DNA to new project:** Create `.claude/design-dna/project-name.json` with rules

**Example DNA rules:**
```json
{
  "typography": {
    "card_titles": "Domaine Sans Display / 28px minimum",
    "labels": "Supreme LL 400 / UPPERCASE / NEVER italic"
  },
  "spacing": {
    "base_grid": 4,
    "rule": "ALL spacing must be 4px multiples - NO EXCEPTIONS"
  },
  "colors": {
    "gold_accent": "#C9A961",
    "usage_limit": "<10% of elements"
  },
  "forbidden": ["gradients", "random_spacing", "gold_overuse"]
}
```

**Result:** First iteration matches your taste - no iteration loops

**Files:**
- `.claude/design-dna/obdn.json` - OBDN project rules
- `.claude/design-dna/universal-taste.json` - Cross-project principles

**Full guide:** `docs/DESIGN_DNA_SYSTEM.md`

---

### ACE Playbooks (Learning System)

**What it does:** System learns from outcomes → Gets better over time

**When it triggers:** Automatically after every /orca session

**What gets learned:**
- ✓ **Helpful patterns:** "SwiftUI + SwiftData works" → helpful_count++
- ✗ **Harmful patterns:** "Skipping design-reviewer causes bugs" → harmful_count++
- 💀 **Apoptosis:** If harmful > helpful × 3 → Pattern deleted (after 7-day grace)

**How to reinforce learning:**
1. **Automatic (default):** System logs outcomes after every session
2. **Explicit:** `/playbook-review` to manually trigger reflection
3. **See what's learned:** Check `.orchestration/playbooks/*.json`

**Example learned pattern:**
```json
{
  "pattern_id": "ios-pattern-012",
  "title": "SwiftUI + SwiftData for iOS 17+",
  "helpful_count": 15,
  "harmful_count": 0,
  "confidence": 0.95,
  "strategy": "Use swiftui-developer + swiftdata-specialist"
}
```

**Result:** Session 50 is smarter than Session 1

**Playbook templates:** `.orchestration/playbooks/` (59 seed patterns)

**Full guide:** `.orchestration/playbooks/README.md`

---

### Response Awareness (Quality Gates)

**What it does:** Prevents false completions by separating generation from verification

**The problem:** LLMs can't stop mid-generation to verify files exist - they must complete responses even if uncertain

**The solution:** Agents tag assumptions → verification-agent checks with grep/bash

**Example:**
```
Implementation agent: "I created Calculator.tsx"
  Tags: #FILE_CREATED: src/Calculator.tsx

verification-agent: ls src/Calculator.tsx
  Result: ✅ EXISTS (verified)

quality-validator: All tags verified → Approve delivery
```

**Meta-cognitive tags:**
- `#FILE_CREATED:` - Claims file was created
- `#SCREENSHOT_CLAIMED:` - Claims screenshot exists
- `#COMPLETION_DRIVE:` - Making an assumption
- `#PLAN_UNCERTAINTY:` - Needs clarification

**Result:** <5% false completion rate (down from ~80% without verification)

**Full guide:** `docs/RESPONSE_AWARENESS_TAGS.md`

---

## 🤖 Agents (Auto-Selected by /orca)

You don't pick agents - /orca does it automatically based on your project type.

### Your Project Determines Available Specialists

**iOS Project** (21 iOS specialists)
- Auto-detected: `*.xcodeproj` found
- Team size: 8-18 agents (dynamic)
- **You just:** Describe iOS feature → /orca picks team

**Frontend Project** (5 frontend + 12 design specialists)
- Auto-detected: `package.json` with "react" or "next"
- Team size: 10-17 agents (dynamic)
- **You just:** Describe frontend feature → /orca picks team

**Backend Project** (3 base specialists)
- Auto-detected: `requirements.txt`, `*.py`, or `package.json` with backend deps
- Team size: 6-12 agents (6 base, +design if admin UI)
- **You just:** Describe backend feature → /orca picks team

### Specialist Categories (52 Total)

- **iOS** (21): SwiftUI, SwiftData, networking, testing, architecture, performance, security
- **Frontend** (5): React 18, Next.js 14, state management, performance, testing
- **Design** (12): Design systems, UX, Tailwind v4, CSS, accessibility, Design DNA
- **Planning** (3): Requirements, architecture, plan synthesis
- **Quality** (3): Testing, verification, validation
- **Implementation** (3): Backend, Android, cross-platform mobile
- **Orchestration & Learning** (5): Workflow orchestration, meta-orchestration, reflection, curation

**How it works:**
```
You: "Build iOS calculator app"
    ↓
Auto-detection: Finds *.xcodeproj
    ↓
system-architect recommends: swiftui-developer, state-architect, swift-testing-specialist
    ↓
Team dispatched in parallel
    ↓
You: [Get complete implementation]
```

**Full agent catalog:** See `agents/` directory (for deep reference only - you rarely need this)

---

## 📖 Quick Decision Trees

### Which Command Should I Use?

```
Is it a question?
├─ Yes → Just ask directly (no command)
└─ No → Is it code/design work?
    ├─ Need to explore first?
    │   ├─ Design exploration → /concept
    │   └─ Problem analysis → /ultra-think
    ├─ Simple focused change?
    │   └─ /enhance
    └─ Complex multi-step work?
        └─ /orca
```

### When Does Design DNA Apply?

```
Does .claude/design-dna/{project}.json exist?
├─ Yes → Design DNA auto-active
│   └─ First iteration: 80-90% acceptance
└─ No → Standard design
    └─ First iteration: ~20% acceptance
    └─ To add DNA: Create {project}.json
```

### How Do I Make the System Learn?

```
After /orca session:
├─ Automatic → Reflection + curation happen automatically
├─ Explicit → /playbook-review (optional)
└─ See learning → cat .orchestration/playbooks/*.json
```

---

## 💡 Pro Tips

1. **Commands are muscle memory** - `/orca` for features, `/concept` before design, `/visual-review` after UI
2. **Trust auto-detection** - Don't specify agents or project type
3. **Design DNA prevents iteration loops** - 80-90% first-iteration acceptance vs 20% without
4. **System learns over time** - Session 50 > Session 1 (ACE playbooks)
5. **Evidence always required** - No "it's done" without screenshots/tests/logs
6. **Parallel execution** - /orca runs multiple agents simultaneously (3-5x faster)

---

## 🔍 Where To Find More

| Topic | Location |
|-------|----------|
| Full documentation | `docs/` directory |
| Agent specifications | `agents/` directory (52 total) |
| Design DNA guide | `docs/DESIGN_DNA_SYSTEM.md` |
| ACE system details | `.orchestration/playbooks/README.md` |
| Quality gates | `docs/RESPONSE_AWARENESS_TAGS.md` |
| Troubleshooting | `docs/TROUBLESHOOTING.md` |
| Agent taxonomy | `docs/AGENT_TAXONOMY.md` |

---

## 🎯 Remember

**Your workflow:**
1. Describe what you want (natural language)
2. System detects project → Picks team automatically
3. Implementation with evidence (screenshots, tests, logs)
4. System learns from outcome (ACE)

**You don't:** Pick agents, specify project type, configure teams

**You just:** Describe intent → System handles complexity
