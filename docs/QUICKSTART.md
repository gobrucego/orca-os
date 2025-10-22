# Quick Start Guide

**Learn the essential commands with real examples**

---

## Table of Contents

- [Core Commands](#core-commands)
- [Real Examples](#real-examples)
- [Common Workflows](#common-workflows)
- [Command Combinations](#command-combinations)

---

## Core Commands

### `/enhance` - Auto-Detect & Execute

**What it does:** Analyzes your task, detects the appropriate workflow, and executes it with the right agents.

**When to use:** Any development task (frontend, backend, iOS, debugging, etc.)

**Example:**
```bash
# You type this:
/enhance "Build a React dashboard with user table and analytics charts"
```

**System responds:**
```
🔍 ANALYZING TASK
   Task type: Frontend development
   Complexity: Medium
   Workflow: ui-ux-design
   Agents needed: frontend-developer, design-master

📋 EXECUTION PLAN
   Wave 1: Architecture (frontend-developer)
   Wave 2: Implementation (frontend-developer + design-master in parallel)
   Wave 3: Quality Gate (code-reviewer-pro)

   Estimated time: 45-60 minutes

   Ready to proceed? (yes/no)

# You type: yes

📋 WAVE 1 - ARCHITECTURE
   Agent: frontend-developer
   Task: Component structure and state management

   ✓ Created components/Dashboard.tsx
   ✓ Created components/UserTable.tsx
   ✓ Created components/AnalyticsChart.tsx
   ✓ Defined data flow and props

   Duration: 8 minutes

🎨 WAVE 2 - IMPLEMENTATION (Parallel Execution)

   frontend-developer:
   ✓ Building components with TDD
   ✓ Writing tests first (RED)
   ✓ Implementing features (GREEN)
   ✓ Refactoring for clarity

   design-master:
   ✓ Applying spacing system (8px grid)
   ✓ Typography hierarchy
   ✓ Visual layout optimization

   Duration: 25 minutes

🛡️ QUALITY GATE - code-reviewer-pro

   Checks:
   ✓ Build passes
   ✓ All tests pass (12/12)
   ✓ TypeScript strict mode
   ✓ Accessibility verified
   ✓ Performance optimized
   ✓ Security reviewed

   Result: ✅ APPROVED

✅ COMPLETE
   Total time: 45 minutes
   Files created: 3 components, 3 test files
   Tests: 12 passing
   Quality: Production-ready
```

---

### `/concept` - Explore Before Building

**What it does:** Brainstorms approaches and creates a concept brief BEFORE writing code.

**When to use:** Design work, complex features, anything that needs creative exploration

**Example:**
```bash
# You type this:
/concept "redesign the navigation to be more intuitive"
```

**System responds:**
```
🎨 CONCEPT EXPLORATION
   Agent: design-master
   Skill: brainstorming (Socratic questioning)

Question 1: What problems does the current navigation have?
   → User feedback: "Can't find settings", "Too many clicks"

Question 2: Who is the primary user?
   → Internal team tools, technical users

Question 3: What navigation patterns resonate with your users?
   → Prefer keyboard shortcuts, minimal chrome

Question 4: Mobile or desktop focus?
   → Desktop-first (90% of usage)

🧠 ANALYZING RESPONSES

Based on your input, I'm exploring 3 approaches:

APPROACH A: Sidebar Navigation
   Pros: Persistent access, keyboard shortcuts
   Cons: Takes screen space
   Best for: Complex apps with many sections

APPROACH B: Command Palette
   Pros: Keyboard-first, minimal UI
   Cons: Requires learning
   Best for: Power users, technical tools

APPROACH C: Hybrid (Sidebar + Command Palette)
   Pros: Best of both worlds
   Cons: More complexity
   Best for: Your use case (technical users + desktop)

📋 RECOMMENDATION: Approach C

Why:
- Technical users appreciate keyboard shortcuts
- Sidebar provides visual navigation for discovery
- Cmd+K palette for power users
- Desktop-first allows sidebar without compromise

Would you like me to create a detailed design brief for Approach C?

# You type: yes

✅ CONCEPT BRIEF CREATED

   File: docs/design-briefs/navigation-redesign-20251021.md

   Includes:
   - User research summary
   - Design rationale
   - Component breakdown
   - Keyboard shortcuts map
   - Implementation notes

   Ready to implement? Use /enhance to build it.
```

---

### `/agentfeedback` - Process Multiple Items

**What it does:** Parses feedback, prioritizes, assigns agents, executes in parallel waves.

**When to use:** Multiple bugs/features from testing, code review feedback, user reports

**Example:**
```bash
# You type this:
/agentfeedback "
1. Login button doesn't work on mobile
2. Dashboard charts load slowly
3. Typography is inconsistent across pages
4. Dark mode toggle broken
5. Search results pagination missing
6. User table sort doesn't persist
7. Footer links are wrong color
"
```

**System responds:**
```
📊 PARSING FEEDBACK

   Received: 7 items
   Categorizing by severity and type...

🔴 CRITICAL (Must fix immediately)
   1. Login button doesn't work on mobile
   4. Dark mode toggle broken

🟡 IMPORTANT (Fix soon)
   2. Dashboard charts load slowly
   6. User table sort doesn't persist
   5. Search results pagination missing

🟢 POLISH (Nice to have)
   3. Typography is inconsistent across pages
   7. Footer links are wrong color

🎯 AGENT ASSIGNMENT

   Critical issues → frontend-developer (parallel)
   Performance → frontend-developer
   Design issues → design-master

📋 EXECUTION PLAN

   Wave 1 (Critical): 2 agents in parallel
   Wave 2 (Important): 1 agent, 3 tasks
   Wave 3 (Polish): 1 agent, 2 tasks
   Quality Gate: code-reviewer-pro

   Estimated time: 45 minutes

# System executes automatically...

🏃 WAVE 1 - CRITICAL FIXES (Parallel)

   Agent 1 (frontend-developer):
   ✓ Fixed: Login button mobile tap target
   ✓ Added: Touch event handlers
   ✓ Tested: iOS Safari, Android Chrome
   Duration: 12 min

   Agent 2 (frontend-developer):
   ✓ Fixed: Dark mode toggle state persistence
   ✓ Added: localStorage sync
   ✓ Tested: All browsers
   Duration: 10 min

🏃 WAVE 2 - IMPORTANT FIXES

   Agent: frontend-developer
   ✓ Optimized chart rendering (lazy load)
   ✓ Added table sort persistence (URL state)
   ✓ Implemented pagination component
   Duration: 18 min

🏃 WAVE 3 - POLISH

   Agent: design-master
   ✓ Unified typography scale across pages
   ✓ Fixed footer link colors (design system)
   Duration: 8 min

🛡️ QUALITY GATE

   Agent: code-reviewer-pro
   ✓ All 7 items addressed
   ✓ Build passes
   ✓ No regressions introduced
   ✓ 14 new tests passing

   Result: ✅ APPROVED

✅ COMPLETE

   Fixed: 7/7 items (100%)
   Time: 48 minutes
   Regressions: 0
   Quality: Production-ready
```

---

### `/nav` - View Your Setup

**What it does:** Shows your installed agents, skills, plugins, and suggests optimizations.

**Example:**
```bash
# You type this:
/nav
```

**System responds:**
```
🔍 CLAUDE CODE SETUP OVERVIEW

📁 Location: ~/.claude/

🤖 AGENTS (19 installed)

   Design & UI:
   ✓ design-master       - Pixel-perfect UI/UX
   ✓ ui-designer         - Interface design
   ✓ ux-designer         - User experience

   Development:
   ✓ frontend-developer  - React/Next.js
   ✓ ios-dev            - Swift/SwiftUI
   ✓ mobile-developer   - Cross-platform
   ✓ python-pro         - Python development

   Quality & Review:
   ✓ code-reviewer-pro  - Quality gates
   ✓ debugger           - Systematic debugging
   ✓ security-auditor   - Security analysis

   [+ 9 more agents]

📚 SKILLS (40+ installed)

   Process:
   ✓ test-driven-development
   ✓ systematic-debugging
   ✓ brainstorming
   ✓ verification-before-completion

   [+ 36 more skills]

🔌 PLUGINS

   ✓ superpowers        - Core skills
   ✓ elements-of-style  - Writing clarity

💡 OPTIMIZATION SUGGESTIONS

   Model Distribution:
   - Opus: 40% (creative work)
   - Sonnet: 60% (deterministic)
   ✓ Well balanced for cost/quality

   Cost Estimate: $50-75/month

   Token Usage: Optimized
   ✓ Context caching enabled
   ✓ Agent compression active

🎯 QUICK ACTIONS

   View details: /nav --details
   Check for updates: /nav --check-updates
   Analyze usage: /nav --analytics
```

---

### `/visual-review` - QA Design Work

**What it does:** Takes screenshots, analyzes design quality, compares to design system.

**When to use:** After implementing UI, before shipping design changes

**Example:**
```bash
# You type this:
/visual-review "http://localhost:3000/dashboard"
```

**System responds:**
```
📸 CAPTURING SCREENSHOTS

   ✓ Desktop (1440x900)
   ✓ Tablet (768x1024)
   ✓ Mobile (375x667)

🔍 VISUAL ANALYSIS (design-master)

   Analyzing against design system...

SPACING:
   ✓ Grid adherence: 95% (8px base)
   ⚠️ Issue: Header padding is 12px (should be 16px)
   ⚠️ Issue: Card margins inconsistent (16px vs 24px)

TYPOGRAPHY:
   ✓ Scale compliance: 100%
   ✓ Line height: Correct (1.5)
   ✓ Font weights: Consistent

LAYOUT:
   ✓ Responsive breakpoints working
   ✓ Content max-width: 1200px ✓
   ⚠️ Issue: Mobile nav overlaps content on small screens

COLOR:
   ✓ Contrast ratios: WCAG AAA compliant
   ✓ Design tokens used correctly
   ✓ Dark mode: Working

COMPONENTS:
   ✓ Button sizes consistent
   ✓ Input fields aligned
   ⚠️ Issue: Card shadows don't match design system

📋 ISSUES FOUND: 4

   Priority: 2 medium, 2 low

   Recommendations:
   1. Fix header padding (line 24, Header.tsx)
   2. Standardize card margins to 24px
   3. Add mobile nav z-index fix
   4. Update card shadow to --shadow-md token

Would you like me to fix these issues?

# You type: yes

✅ FIXES APPLIED

   Modified:
   - components/Header.tsx
   - components/Card.tsx
   - components/MobileNav.tsx

   Re-running visual review...

   ✓ All issues resolved
   ✓ 100% design system compliance

   Ready to ship!
```

---

## Common Workflows

### Workflow 1: Build New Feature

```bash
# Step 1: Explore concept
/concept "add user profile page with avatar upload"

# Step 2: Implement
/enhance "build user profile page based on concept brief"

# Step 3: Review
/visual-review "http://localhost:3000/profile"

# Result: Production-ready feature in 60-90 minutes
```

---

### Workflow 2: Fix Multiple Bugs

```bash
# After testing, you have a list of issues:
/agentfeedback "
1. Search doesn't work
2. Images load slowly
3. Buttons too small on mobile
4. Sort broken on table
5. Colors don't match design
"

# System automatically:
# - Prioritizes (critical vs polish)
# - Assigns agents (frontend-developer, design-master)
# - Executes in parallel waves
# - Quality gate review
# - Ships fixes

# Result: All bugs fixed in 30-45 minutes
```

---

### Workflow 3: Redesign Existing Feature

```bash
# Step 1: Concept exploration
/concept "make the checkout flow more intuitive"

# This will:
# - Ask clarifying questions
# - Explore multiple approaches
# - Create detailed brief

# Step 2: Implement redesign
/enhance "implement checkout redesign from concept brief"

# Step 3: Visual QA
/visual-review "http://localhost:3000/checkout"

# Result: Thoughtful redesign in 90-120 minutes
```

---

## Command Combinations

### Combination 1: Concept → Enhance

**Use case:** You want to explore approaches before building

```bash
# 1. Brainstorm approaches
/concept "add real-time notifications"

# Output: Concept brief saved to docs/design-briefs/

# 2. Build based on concept
/enhance "implement notifications from concept brief"

# System will:
# - Load concept brief automatically
# - Use recommended approach
# - Follow design decisions
```

**Why this works:** Concept ensures you're building the RIGHT thing, enhance ensures you build it WELL.

---

### Combination 2: Enhance → Visual Review

**Use case:** Build feature, then QA design before shipping

```bash
# 1. Build feature
/enhance "add settings page with theme picker"

# 2. Visual QA
/visual-review "http://localhost:3000/settings"

# System will:
# - Take screenshots
# - Analyze spacing, typography, colors
# - Check design system compliance
# - Suggest fixes

# 3. If issues found, fix automatically or manually
```

**Why this works:** Catches design issues BEFORE shipping, maintains consistency.

---

### Combination 3: Agentfeedback → Visual Review

**Use case:** Fix bugs, then verify design didn't break

```bash
# 1. Fix bugs
/agentfeedback "
1. Login button broken
2. Dark mode toggle issues
3. Chart loading slowly
"

# 2. Visual QA to catch regressions
/visual-review "http://localhost:3000"

# System ensures:
# - Bugs are fixed
# - Design still looks good
# - No visual regressions
```

**Why this works:** Quality gate prevents "fixed the bug but broke the design" scenarios.

---

## Tips for Success

### 1. Be Specific in Prompts

**❌ Vague:**
```bash
/enhance "make it better"
```

**✅ Specific:**
```bash
/enhance "add user search with autocomplete, debouncing, and keyboard navigation"
```

---

### 2. Use /concept for Complex Work

**When to use:**
- Redesigns (changes to existing features)
- Complex features (multiple moving parts)
- Creative work (needs exploration)

**When to skip:**
- Simple bug fixes
- Straightforward features
- Minor tweaks

---

### 3. Let Agents Work in Parallel

The system automatically runs agents in parallel when possible. Trust it.

```bash
/agentfeedback "10 different bugs"

# System will:
# - Wave 1: 3 critical bugs (3 agents in parallel)
# - Wave 2: 5 important bugs (2 agents in parallel)
# - Wave 3: 2 polish items (1 agent)

# Much faster than sequential!
```

---

### 4. Review Before Shipping

Always use the quality gate:

```bash
# After /enhance or /agentfeedback:

# System automatically runs code-reviewer-pro

# If approved ✅: Ship it
# If changes requested ❌: Agent fixes, then re-reviews
```

---

## Next Steps

**Want detailed scenario walkthroughs?**
→ [WORKFLOWS.md](WORKFLOWS.md)

**Need to install the system?**
→ [SETUP.md](SETUP.md)

**Want to optimize costs?**
→ [OPTIMIZATION.md](OPTIMIZATION.md)

**Having issues?**
→ [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
