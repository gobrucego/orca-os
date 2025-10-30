## Phase 2: Agent Team Selection

Based on detection, select the appropriate predefined team:

### 📱 iOS Team

**When to Use**: iOS/SwiftUI apps, native iOS development

**Team Composition**: Dynamic (7-15 agents as needed)

#### Base Team (Always Included - 4 agents):

1. **requirement-analyst** → Requirements analysis ONLY
   - Analyzes user request
   - Creates user stories with acceptance criteria
   - Defines scope and constraints
   - Hands off to: system-architect

2. **system-architect** → Architecture design ONLY
   - Designs iOS app architecture (state-first vs TCA)
   - Defines data models and navigation patterns
   - Makes tech decisions (SwiftUI vs UIKit, SwiftData vs Core Data)
   - Creates API contracts and service boundaries
   - **Analyzes requirements** → recommends iOS specialists
   - **Optional**: May recommend ux-strategist for complex UX flows
   - Hands off to: iOS specialists (in parallel)

3. **verification-agent** → Tag verification ONLY (MANDATORY)
   - Searches for meta-cognitive tags (#COMPLETION_DRIVE, #FILE_CREATED, etc.)
   - Runs actual verification commands (ls, grep, xcodebuild)
   - Creates verification-report.md
   - Blocks if any verification fails
   - Hands off to: quality-validator

4. **quality-validator** → Final validation ONLY (MANDATORY)
   - Reads user-request.md to verify ALL requirements met
   - Reviews verification-report.md for evidence
   - **Runs /visual-review BEFORE final validation** (MANDATORY for UI work)
   - **Runs Reference Parity Gate if reference exists** (web app, design guide)
   - Checks all acceptance criteria
   - Blocks if <100% complete OR Reference Parity <70%
   - Approves delivery to user

#### iOS Specialists (Choose 2-10 as needed):

**Category 1: UI Implementation (choose 1-2)**
- **swiftui-developer** → Modern SwiftUI (iOS 15+), @Observable, default MainActor isolation
- **ios-accessibility-tester** → WCAG 2.1 AA compliance, VoiceOver, accessibility audit

**Category 2: Data Persistence (choose 0-2)**
- **swiftdata-specialist** → SwiftData for iOS 17+ (@Model, ModelContext, @Query)
- **coredata-expert** → Core Data for iOS 16 and earlier, CloudKit sync, complex models

**Category 3: Networking (choose 0-2)**
- **urlsession-expert** → URLSession with async/await for REST APIs
- **combine-networking** → Combine for reactive patterns, complex data flows
- **ios-api-designer** → Design mobile-optimized APIs (pagination, caching, offline-first)

**Category 4: Architecture (choose 1)**
- **state-architect** → State-first architecture (default), @Observable, unidirectional flow
- **tca-specialist** → The Composable Architecture for complex apps
- **observation-specialist** → @Observable optimization, performance tuning

**Category 5: Testing (choose 1-2)**
- **swift-testing-specialist** → Swift Testing framework (default for Swift 6.2)
- **xctest-pro** → XCTest for legacy support (iOS 16 and earlier)
- **ui-testing-expert** → XCUITest for UI automation

**Category 6: Quality & Debugging (choose 0-2)**
- **swift-code-reviewer** → Code quality, Swift 6.2 concurrency safety
- **ios-debugger** → LLDB, Instruments, memory/performance debugging

**Category 7: DevOps (choose 0-2)**
- **xcode-cloud-expert** → Xcode Cloud CI/CD, TestFlight automation
- **fastlane-specialist** → Fastlane for complex deployments, screenshots

**Category 8: Performance (choose 0-1)**
- **ios-performance-engineer** → Instruments profiling, optimization

**Category 9: Security (choose 0-2)**
- **ios-security-tester** → Keychain, CryptoKit, certificate pinning, biometric auth
- **ios-penetration-tester** → Advanced penetration testing, OWASP Mobile Top 10

#### Team Composition Examples:

**Simple App (Calculator, Converter)**: 6 agents total
```
Base (4): requirement-analyst, system-architect, verification-agent, quality-validator
iOS (2): swiftui-developer, swift-testing-specialist
```

**Medium App (Notes, To-Do List)**: 8-9 agents
```
Base (4): requirement-analyst, system-architect, verification-agent, quality-validator
iOS (4-5): swiftui-developer, swiftdata-specialist, state-architect, swift-testing-specialist, [swift-code-reviewer]
```

**Complex App (Social Network, E-commerce)**: 11-13 agents
```
Base (4): requirement-analyst, system-architect, verification-agent, quality-validator
Design (0-1): [ux-strategist] (optional for complex UX flows)
iOS (7-9): swiftui-developer, swiftdata-specialist, urlsession-expert, tca-specialist, swift-testing-specialist, ui-testing-expert, ios-performance-engineer, [ios-debugger], [xcode-cloud-expert]
```

**Enterprise App (Banking, Healthcare)**: 14+ agents
```
Base (4): requirement-analyst, system-architect, verification-agent, quality-validator
Design (0-1): [ux-strategist] (optional for complex UX flows)
iOS (10+): swiftui-developer, coredata-expert, urlsession-expert, combine-networking, tca-specialist, swift-testing-specialist, xctest-pro, ui-testing-expert, swift-code-reviewer, ios-debugger, xcode-cloud-expert, fastlane-specialist, ios-performance-engineer, ios-security-tester, ios-penetration-tester
```

#### Automatic Specialist Selection:

**system-architect will analyze requirements and recommend specialists:**

Prompt keywords → Specialists:
- "database", "storage", "persistence" → swiftdata-specialist or coredata-expert
- "API", "networking", "REST" → urlsession-expert
- "complex", "testability", "TCA" → tca-specialist
- "performance", "slow" → ios-performance-engineer
- "security", "encryption" → ios-security-tester
- "CI/CD", "deployment" → xcode-cloud-expert or fastlane-specialist

**Workflow**:
```
requirement-analyst → system-architect (recommends iOS specialists) →
[Present team to user for confirmation] →
[iOS specialists in parallel] → verification-agent → quality-validator
[Optional: ux-strategist for complex UX flows]
```

**Cannot skip (mandatory):**
- Base 4 agents (requirement-analyst, system-architect, verification-agent, quality-validator)
- At least 1 UI specialist (swiftui-developer)
- **verification-agent (GATE 1 - FIRST, facts before opinions, runs UI Guard for iOS)**
- swift-testing-specialist (GATE 2 - unit tests)
- **ui-testing-expert (GATE 3 - XCUITest + accessibility checks for UI work)**
- **design-reviewer (GATE 4 - visual QA + final accessibility audit for UI work)**
- quality-validator (Final gate - only if all 4 gates pass)

**Verification**: iOS Simulator screenshots + **MANDATORY /visual-review** + build verification + tests passing + reference comparison (if applicable)

**iOS simulator integration:**
- 9 out of 19 specialists support ios-simulator-skill (96-99% token reduction)
- Automatic usage for UI testing, debugging, accessibility audits

---

### 🎨 Design Team (Specialized - Add to Any Project)

**When to Use**: Design system creation, UI/UX work, visual design, accessibility audits

**Team Composition**: Dynamic (3-8 agents as needed)

#### Core Design Agents (Choose Based on Need):

**Category 1: Foundation (choose 1-2)**
- **design-system-architect** → Creates design systems from user references
  - Collects 3-5 design references from user ("Show me designs you love")
  - Extracts principles (color, typography, spacing, component patterns)
  - Generates `.design-system.md` with design tokens
  - Configures Tailwind v4 + daisyUI 5
  - **Use when**: No design system exists, need to capture user taste

- **ux-strategist** → UX optimization, journey mapping, interaction design
  - Simplifies user flows (Hick's Law, progressive disclosure)
  - Creates user journey maps
  - Designs micro-interactions and transitions
  - Defines data visualization strategy
  - **Use when**: UX flows confusing, need journey mapping, complex interactions

**Category 2: Visual & Accessibility (choose 1-2)**
- **visual-designer** → Visual hierarchy, typography, color, composition
  - Creates high-fidelity mockups
  - Establishes visual hierarchy (F-pattern, Z-pattern)
  - Designs typography scale and font pairing
  - Creates color palettes (OKLCH for perceptual uniformity)
  - **Use when**: Need mockups, visual refinement, typography/color design

- **accessibility-specialist** → WCAG 2.1 AA compliance (MANDATORY for production)
  - Keyboard navigation testing
  - Screen reader testing (NVDA, VoiceOver)
  - Color contrast validation (4.5:1 text, 3:1 graphics)
  - Touch target sizing (≥44x44px)
  - **Use when**: ALWAYS (accessibility is non-negotiable)

**Category 3: Implementation (choose 1-3)**
- **tailwind-specialist** → Tailwind v4 + daisyUI 5 implementation
  - Translates design system → Tailwind config
  - Implements components with daisyUI
  - Container queries, responsive design
  - Dark mode implementation
  - **Use when**: Using Tailwind CSS (most common)

- **css-specialist** → Pure CSS when Tailwind insufficient
  - Complex Grid layouts
  - Custom animations (keyframes, SVG)
  - Framework-agnostic requirements
  - **Use when**: Complex CSS Grid, custom animations, no framework

- **ui-engineer** → React/Vue/Angular component engineering
  - Implements UI components with TypeScript
  - State management (Context, Zustand, Redux)
  - Performance optimization (memo, lazy loading)
  - Accessibility implementation
  - **Use when**: Need component implementation (always for frontend)

**Category 4: Quality (MANDATORY)**
- **design-reviewer** → 7-phase design review (OneRedOak methodology)
  - Playwright MCP integration for live browser testing
  - Tests desktop (1440px), tablet (768px), mobile (375px)
  - Validates visual polish, accessibility, robustness
  - Captures screenshots for evidence
  - **Use when**: ALWAYS before merge/launch (quality gate)

#### Team Composition Examples:

**Simple Design Task (Button component, single page)**: 3-4 agents
```
Foundation (1): design-system-architect (if no design system exists)
Implementation (1-2): tailwind-specialist OR ui-engineer
Quality (2): accessibility-specialist, design-reviewer
```

**Medium Design Task (Multi-page app, component library)**: 5-6 agents
```
Foundation (2): design-system-architect, ux-strategist
Visual (1): visual-designer
Implementation (2): tailwind-specialist, ui-engineer
Quality (2): accessibility-specialist, design-reviewer
```

**Complex Design Task (Design system from scratch, complex UX)**: 7-8 agents
```
Foundation (2): design-system-architect, ux-strategist
Visual (1): visual-designer
Implementation (3): tailwind-specialist, css-specialist, ui-engineer
Quality (2): accessibility-specialist, design-reviewer
```

#### Automatic Specialist Selection:

**Prompt keywords → Specialists:**
- "design system", "brand", "style guide" → design-system-architect
- "UX", "user flow", "journey", "interaction" → ux-strategist
- "mockup", "visual", "typography", "colors" → visual-designer
- "accessibility", "WCAG", "screen reader" → accessibility-specialist (ALWAYS)
- "Tailwind", "daisyUI", "utility classes" → tailwind-specialist
- "CSS Grid", "animation", "custom CSS" → css-specialist
- "React", "Vue", "Angular", "component" → ui-engineer
- **ALWAYS**: design-reviewer (quality gate before launch)

**Workflow**:
```
[Request comes in with design needs] →
system-architect or ux-strategist (analyzes requirements, recommends design specialists) →
[Present design team to user for confirmation] →
Execute in phases (Foundation → Visual → Implementation → Quality Review)
```

**Integration with Other Teams:**
- **iOS Team**: NO design specialists for styling (SwiftUI handles styling natively). Optional: ux-strategist for complex UX flows.
- **Frontend Team**: ux-strategist + design-system-architect + tailwind-specialist + ui-engineer + design-reviewer (MANDATORY)
- **Mobile Team**: ux-strategist + ui-engineer + accessibility-specialist + design-reviewer (cross-platform design)
- **Standalone**: Full design team for design-only projects (no code implementation)

**Verification**: Screenshots + WCAG audit + design system documentation + Playwright tests

---

### 🌐 Frontend Team

**When to Use**: React, Next.js, Vue.js web frontends

**Team Composition**: Dynamic (10-15 agents as needed)

**Phase 1: Planning (2 agents)**

1. **requirement-analyst** → Requirements analysis ONLY
   - Analyzes user request
   - Creates user stories with acceptance criteria
   - Defines scope and constraints
   - Hands off to: system-architect

2. **system-architect** → Frontend architecture ONLY
   - Designs frontend architecture (state management, routing, etc.)
   - Defines component hierarchy and data flow
   - Makes tech decisions (React 18 vs Next.js 14, state approach)
   - Creates API integration contracts
   - **Recommends specialists** (design + frontend + testing)
   - Hands off to: Design team (parallel) + Frontend team (after design)

**Phase 2: Design (3-5 agents, in parallel)**

3. **ux-strategist** → UX flows and interaction design
   - Information architecture
   - User flows and navigation
   - Interaction patterns

4. **design-system-architect** → Design system foundation
   - Design tokens (colors, spacing, typography)
   - Component architecture
   - Tailwind v4 configuration

5. **tailwind-specialist** (MANDATORY) → Tailwind implementation
   - Tailwind v4 + daisyUI 5 styling
   - Responsive design patterns
   - Theme configuration

6. **ui-engineer** → Component patterns
   - React component API design
   - Component composition patterns
   - Reusability strategy

7. **accessibility-specialist** (MANDATORY) → WCAG 2.1 AA compliance
   - ARIA patterns
   - Keyboard navigation
   - Screen reader support
   - Hands off to: Frontend specialists

**Phase 3: Implementation (2-4 agents, after design specs ready)**

8. **react-18-specialist** OR **nextjs-14-specialist** (choose one)
   - React 18: Server Components, Suspense, hooks
   - Next.js 14: App Router, SSR/SSG, Server Actions
   - Implements per architecture + design specs
   - Tags all assumptions with meta-cognitive tags

9. **state-management-specialist** (if complex state)
   - UI/server/URL state separation
   - Zustand, React Query, or state colocation
   - State optimization

10. **frontend-performance-specialist** (if perf-critical)
    - Code splitting
    - Lazy loading
    - Core Web Vitals optimization

**Phase 4: Testing + QA (3 agents)**

11. **frontend-testing-specialist** (MANDATORY)
    - React Testing Library (behavior-first)
    - Vitest unit tests
    - Playwright E2E tests
    - Accessibility testing

12. **design-reviewer** (MANDATORY) → Visual QA
    - 7-phase OneRedOak review
    - Playwright visual verification
    - Design system compliance
    - Cross-browser testing

13. **verification-agent** (MANDATORY) → Tag verification
    - Searches for meta-cognitive tags
    - Runs ls, grep, npm test, npm build
    - Creates verification-report.md
    - Blocks if verification fails

14. **quality-validator** (MANDATORY) → Final gate
    - Reads verification-report.md
    - **Runs /visual-review** (MANDATORY)
    - Checks all acceptance criteria
    - Blocks if <100% complete

**Verification**: Browser screenshots + /visual-review + build passing + tests passing + WCAG audit

**Workflow**:
```
Phase 1: requirement-analyst → system-architect (recommends team)
         ↓
Phase 2: Design team (parallel):
         ux-strategist + design-system-architect + tailwind-specialist +
         ui-engineer + accessibility-specialist
         ↓
Phase 3: Frontend implementation (after design):
         react-18-specialist OR nextjs-14-specialist
         [+ state-management-specialist if needed]
         [+ frontend-performance-specialist if needed]
         ↓
Phase 4: Testing + QA:
         frontend-testing-specialist → design-reviewer →
         verification-agent → /visual-review → quality-validator
```

**When to add:**
- backend-engineer → If full-stack application
- infrastructure-engineer → For deployment, SEO optimization

**Can skip (if specs exist):**
- requirement-analyst → If user provides detailed requirements
- system-architect → If architecture already documented
- design-system-architect, ux-strategist, visual-designer → If design system exists
- state-management-specialist, frontend-performance-specialist → If not needed

**Cannot skip (mandatory):**
- tailwind-specialist → Styling is always required
- accessibility-specialist → WCAG compliance is mandatory
- react-18-specialist OR nextjs-14-specialist → Someone must write code
- frontend-testing-specialist → Code must be tested
- design-reviewer → Visual QA is mandatory
- verification-agent → Tags must be verified (Response Awareness)
- **/visual-review → MUST run before quality-validator for ALL UI work**
- quality-validator → Final gate must run

---

### 🐍 Backend Team

**When to Use**: APIs, server-side applications

**Team Composition (6 agents):**

1. **requirement-analyst** → Requirements analysis ONLY
   - Analyzes user request
   - Creates user stories with acceptance criteria
   - Defines scope and constraints
   - Hands off to: system-architect

2. **system-architect** → Backend architecture ONLY
   - Designs backend architecture (API design, database schema)
   - Defines data models and service boundaries
   - Makes tech decisions (REST vs GraphQL, database choice)
   - Creates API contracts and authentication strategy
   - Hands off to: backend-engineer

3. **backend-engineer** → API/server implementation ONLY
   - Implements code per architecture spec
   - Implements endpoints per API contract
   - Tags all assumptions with meta-cognitive tags
   - Does NOT make architecture/design/testing decisions
   - Hands off to: test-engineer

4. **test-engineer** → Testing ONLY
   - Writes unit tests
   - Writes API integration tests (Supertest)
   - Runs load tests (k6)
   - Measures performance
   - Hands off to: verification-agent

5. **verification-agent** → Tag verification ONLY
   - Searches for meta-cognitive tags (#COMPLETION_DRIVE, #FILE_CREATED, etc.)
   - Runs actual verification commands (ls, grep, pytest)
   - Creates verification-report.md
   - Blocks if any verification fails
   - Hands off to: quality-validator

6. **quality-validator** → Final validation ONLY
   - Reads user-request.md to verify ALL requirements met
   - Reviews verification-report.md for evidence
   - **Runs Reference Parity Gate if reference exists** (API spec, existing endpoints)
   - Checks all acceptance criteria
   - Blocks if <100% complete OR Reference Parity <70%
   - Approves delivery to user

**Note**: Skip design specialists (ux-strategist, tailwind-specialist, ui-engineer, design-reviewer) unless building admin UI

**Verification**: API tests + load tests + database verification + reference comparison (if applicable)

**Workflow**:
```
requirement-analyst → system-architect → backend-engineer →
test-engineer → verification-agent → quality-validator
```

**When to add:**
- Design specialists (ux-strategist, tailwind-specialist, ui-engineer, design-reviewer) → If building admin UI
- infrastructure-engineer → For Docker, Kubernetes, cloud deployment

**Can skip (if specs exist):**
- requirement-analyst → If user provides detailed requirements
- system-architect → If architecture already documented

**Cannot skip (mandatory):**
- backend-engineer → Someone must write code
- test-engineer → Code must be tested
- verification-agent → Tags must be verified (Response Awareness)
- quality-validator → Final gate must run

---

### 📱 Mobile Team

**When to Use**: React Native, Flutter cross-platform

**Team Composition (7 agents):**

1. **requirement-analyst** → Requirements analysis ONLY
   - Analyzes user request
   - Creates user stories with acceptance criteria
   - Defines scope and constraints
   - Hands off to: system-architect

2. **system-architect** → Mobile architecture ONLY
   - Designs mobile app architecture (navigation, state management)
   - Defines data models and platform-specific patterns
   - Makes tech decisions (navigation libraries, state solutions)
   - Creates API integration contracts
   - **Recommends specialists** (design + mobile + testing)
   - Hands off to: Design team (parallel) + Mobile implementation (after design)

**Design Team (3-5 agents, in parallel):**

3. **ux-strategist** → Mobile-first UX design
   - Mobile interaction patterns
   - Gesture-based navigation
   - Platform-adaptive flows

4. **ui-engineer** → React Native/Flutter component patterns
   - Component API design for cross-platform
   - Platform-specific adaptations (iOS & Android)
   - Reusability across platforms

5. **accessibility-specialist** (MANDATORY) → Mobile accessibility
   - VoiceOver (iOS) and TalkBack (Android)
   - Touch target sizes
   - Screen reader support
   - Hands off to: Mobile implementation

**Mobile Implementation:**

6. **cross-platform-mobile** → React Native/Flutter implementation ONLY
   - Implements code per architecture spec
   - Implements UI per design spec
   - Tags all assumptions with meta-cognitive tags
   - Does NOT make architecture/design/testing decisions
   - Hands off to: test-engineer

**Testing + QA:**

7. **test-engineer** → Testing ONLY
   - Writes unit tests
   - Writes integration tests (Detox, integration_test)
   - Tests on both iOS and Android
   - Measures performance
   - Hands off to: design-reviewer

8. **design-reviewer** (MANDATORY) → Visual QA
   - Platform design guideline compliance (iOS HIG, Material Design)
   - Visual verification on both iOS and Android
   - Accessibility testing
   - Cross-device testing

9. **verification-agent** (MANDATORY) → Tag verification ONLY
   - Searches for meta-cognitive tags (#COMPLETION_DRIVE, #FILE_CREATED, etc.)
   - Runs actual verification commands (ls, grep, build commands)
   - Creates verification-report.md
   - Blocks if any verification fails
   - Hands off to: quality-validator

10. **quality-validator** (MANDATORY) → Final validation ONLY
   - Reads user-request.md to verify ALL requirements met
   - Reviews verification-report.md for evidence
   - **Runs /visual-review BEFORE final validation** (MANDATORY for UI work)
   - **Runs Reference Parity Gate if reference exists** (web app, native app, design guide)
   - Checks all acceptance criteria
   - Blocks if <100% complete OR Reference Parity <70%
   - Approves delivery to user

**Verification**: iOS + Android screenshots + **MANDATORY /visual-review** + build verification + tests passing + reference comparison (if applicable)

**Workflow**:
```
Phase 1: requirement-analyst → system-architect (recommends team)
         ↓
Phase 2: Design team (parallel):
         ux-strategist + ui-engineer + accessibility-specialist
         ↓
Phase 3: Mobile implementation (after design):
         cross-platform-mobile
         ↓
Phase 4: Testing + QA:
         test-engineer → design-reviewer → verification-agent →
         /visual-review (MANDATORY) → quality-validator
```

**When to add:**
- infrastructure-engineer → For app store deployment, CI/CD

**Can skip (if specs exist):**
- requirement-analyst → If user provides detailed requirements
- system-architect → If architecture already documented
- ux-strategist, design-system-architect → If design system exists

**Cannot skip (mandatory):**
- cross-platform-mobile → Someone must write code
- test-engineer → Code must be tested
- verification-agent → Tags must be verified (Response Awareness)
- **/visual-review → MUST run before quality-validator for ALL UI work**
- quality-validator → Final gate must run

---

### Mobile Team Workflow Example

**Complete workflow for React Native app with UI changes:**

```
Phase 1: requirement-analyst
- Analyze user request
- Create user stories and acceptance criteria
- Write to .orchestration/user-request.md
- Hands off to: system-architect

Phase 2: system-architect
- Design mobile architecture (navigation, state management)
- Define data models and API contracts
- Choose tech stack decisions
- Write architecture-spec.md
- Hands off to: Design specialists (parallel)

Phase 3: Design specialists (parallel)
- ux-strategist: Mobile-first UX flows, gesture interactions
- ui-engineer: React Native component patterns
- accessibility-specialist: VoiceOver (iOS), TalkBack (Android)
- Write design-spec.md
- Hands off to: cross-platform-mobile

Phase 4: cross-platform-mobile
- Implement per architecture spec
- Implement UI per design spec
- Tag assumptions (#COMPLETION_DRIVE, #ARCHITECTURE_DECISION, etc.)
- Write agent-log.md with implementation details
- Hands off to: test-engineer

Phase 5: test-engineer
- Write unit tests (Jest)
- Write integration tests (Detox for React Native)
- Test on iOS simulator
- Test on Android emulator
- Write test-report.md
- Hands off to: verification-agent

Phase 6: verification-agent
- Search for all meta-cognitive tags
- Run verification commands (ls, grep, npm run build)
- Build for iOS: npx react-native run-ios
- Build for Android: npx react-native run-android
- Capture screenshots on both platforms
- Create verification-report.md
- Blocks if any verification fails
- Hands off to: /visual-review

Phase 7: /visual-review (MANDATORY for UI work)
- Read design system guide
- Capture iOS simulator screenshot
- Capture Android emulator screenshot
- Analyze with vision against design standards
- Check: Typography, spacing, colors, component compliance, accessibility
- Create visual-qa-report.md with scores
- Lists violations and needed fixes
- BLOCKS if critical violations found
- If APPROVED → Hands off to: quality-validator
- If NEEDS FIXES → Back to cross-platform-mobile

Phase 8: quality-validator (Final gate)
- Read user-request.md (original requirements)
- Review verification-report.md (evidence)
- Review visual-qa-report.md (/visual-review results)
- Run Reference Parity Gate if reference exists:
  * Compare implementation screenshots to reference screenshots
  * Calculate Reference Parity Score (Visual Match 40% + Feature Parity 30% + Design Rules 20% + Visual Quality 10%)
  * BLOCKS if Reference Parity Score <70%
- Check ALL acceptance criteria
- Blocks if <100% complete
- APPROVED → Present to user
```

**Critical checkpoints:**
1. ✅ Phase 0.5 (if reference exists): Capture reference, user approves checklist BEFORE implementation
2. ✅ Phase 4.5 (Mid-implementation): 50% checkpoint with design agent comparison
3. ✅ Phase 7: /visual-review MUST run before final validation
4. ✅ Phase 8: Reference Parity Gate (if reference exists) MUST pass ≥70%

**Time estimates:**
- Simple mobile task (1-2 screens): 4-6 hours
- Medium mobile task (3-5 screens): 8-12 hours
