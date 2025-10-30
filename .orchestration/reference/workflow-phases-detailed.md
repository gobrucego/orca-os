### PHASE 1: Planning & Analysis (20-25% of project time)

**Quality Gate 1 Criteria: 95% Compliance**

1. **Dispatch Planning Agents**
   ```markdown
   TodoWrite: Create todos for planning phase
   - [ ] Requirements analysis complete
   - [ ] System architecture designed
   - [ ] Work plan validated

   Parallel dispatch:
   - requirement-analyst: Comprehensive requirements (already dispatched in pre-flight)
   - system-architect: Architecture design, tech stack selection
   - (If UI required) Design specialists: ux-strategist (UX flows), design-system-architect (design tokens), visual-designer (visual design)

   For EACH agent:
   #COMPLETION_DRIVE: Demand evidence in .orchestration/evidence/
   #CARGO_CULT: Verify output references user's actual requirements
   ```

2. **Planning Validation**
   ```markdown
   Read ALL planning outputs:
   - .orchestration/user-request.md (frame anchor)
   - requirements.md
   - architecture.md
   - work-plan.md

   #CONTEXT_DEGRADED: Check for requirement drift
   For EACH requirement in requirements.md:
   - Quote from user-request.md: [exact words]
   - Interpretation in requirements.md: [paraphrased]
   - MATCH? YES/NO

   If ANY mismatch → #CARGO_CULT detected → Re-dispatch requirement-analyst
   ```

3. **Quality Gate 1: Planning Completeness**
   ```markdown
   Dispatch quality-validator with:
   - Input: All planning artifacts
   - Task: Score planning completeness against Quality Gate 1 criteria
   - Required: Validation report with score ≥95/100

   Scoring criteria:
   - Requirements completeness: 95%
   - Architecture feasibility: 90%
   - Work plan granularity: 90%
   - User requirement traceability: 100%

   #FALSE_COMPLETION: Do NOT proceed if score <95
   If failed → Identify gaps → Re-dispatch agents → Re-validate
   ```

### PHASE 2: Development & Implementation (60-65% of project time)

**Quality Gate 2 Criteria: 85% Compliance**

1. **Execute Work Plan**
   ```markdown
   Read .orchestration/work-plan.md

   For EACH task in plan:
     TodoWrite: Mark task as in_progress

     #CONTEXT_ROT prevention:
     - Re-read user-request.md before dispatch
     - Quote user's requirement in dispatch prompt
     - Specify evidence format required

     Dispatch appropriate specialists (react-18-specialist, nextjs-14-specialist, backend-engineer, swiftui-developer, etc.):
     - Task description: [from work-plan.md]
     - User requirement: [quote from user-request.md]
     - Acceptance criteria: [from user-stories.md]
     - Evidence required: [specific format]

     #COMPLETION_DRIVE_IMPL: Wait for evidence before marking complete
     #CARGO_CULT: Verify output solves user's problem, not proxy metric
   ```

2. **Evidence Verification Protocol**
   ```markdown
   For EACH completed task:

   Read .orchestration/evidence/[task-name]/

   #FALSE_COMPLETION checklist:
   - [ ] Evidence file exists (not empty promise)
   - [ ] Evidence shows working functionality (screenshot/log/test)
   - [ ] Functionality matches user's requirement (not technical proxy)
   - [ ] No hallucinated features (nothing user didn't ask for)

   #PATTERN_MOMENTUM: Watch for "I also added..." features
   If agent added unrequested features → STOP → Verify user actually wants them

   TodoWrite: Mark task as completed ONLY after evidence verified
   ```

3. **⚠️ CRITICAL: Meta-Cognitive Verification Phase (NEW - MANDATORY)**
   ```markdown
   After ALL implementation tasks complete, BEFORE quality-validator:

   Step 1: Check for Implementation Log
   Read .orchestration/implementation-log.md

   If file missing:
     #FAILED_VERIFICATION: Implementation agents did not create tag log
     BLOCK: Cannot proceed without verifiable claims
     Redispatch implementation agent to create implementation log with tags
     STOP HERE

   Step 2: Deploy verification-agent
   Dispatch verification-agent with:
     Task: "Search for all meta-cognitive tags in .orchestration/implementation-log.md and codebase.
            For EACH tag found:
            - Run actual verification commands (ls, grep, Read, file)
            - Show command outputs in verification report
            - Mark tags as #VERIFIED or #FAILED_VERIFICATION
            Create .orchestration/verification-report.md with findings."

     Agent: verification-agent
     Input: .orchestration/implementation-log.md, entire codebase
     Output: .orchestration/verification-report.md

   #CRITICAL: verification-agent must run ACTUAL commands, not generate validation

   Step 3: Read Verification Report
   Read .orchestration/verification-report.md

   Step 4: Check Verification Status
   If report contains "FAILED VERIFICATIONS":
     Count failed verifications
     Read specific failures from report

     BLOCK WORKFLOW:
     - Do NOT proceed to quality-validator
     - Do NOT mark tasks complete
     - Report failures to user with details

     Report to user:
     "❌ Verification Failed - Quality Gate BLOCKED

     {N} assumptions were incorrect:

     {List each failed verification from report with:
       - What was claimed
       - What was actually found
       - Which file/line
       - What needs to be fixed
     }

     Required actions:
     {List fixes needed}

     Workflow cannot proceed until all verifications pass.

     Details: .orchestration/verification-report.md"

     STOP HERE - Wait for user to fix or approve redispatch

   If report shows "ALL VERIFIED":
     TodoWrite: Add "Verification phase complete - all assumptions verified"
     Proceed to Quality Gate 2 (quality-validator)
     Include verification report as evidence

   If report shows "CONDITIONAL" (runtime tests needed):
     Report to user:
     "⏳ Verification Conditional - Manual Testing Required

     All static verifications passed ✓

     {N} items need runtime testing:
     {List each from report}

     Please test these items before production deployment.

     Proceeding to quality validation with conditional approval."

     Proceed to Quality Gate 2 with note about manual tests needed
   ```

4. **⚠️ MANDATORY ENFORCEMENT: Verification Gate (HARD BLOCK)**
   ```markdown
   BEFORE dispatching quality-validator, MANDATORY checks:

   CHECK 1: Verification Report Exists
   Read .orchestration/verification-report.md

   If file does NOT exist:
     ❌ HARD BLOCK ACTIVATED

     Report to user:
     "🚫 WORKFLOW BLOCKED - Verification Not Run

     verification-agent was not executed. This is a critical quality gate violation.

     Required: verification-agent must run and create .orchestration/verification-report.md

     Workflow cannot proceed to quality-validator without verification.

     This is a HARD BLOCK - no overrides, no exceptions."

     STOP HERE - Do not proceed
     Dispatch verification-agent immediately
     Re-run this check after verification completes

   CHECK 2: Verification Verdict Check
   Read verdict from .orchestration/verification-report.md

   If verdict == "BLOCKED" OR contains "FAILED VERIFICATIONS":
     ❌ HARD BLOCK ACTIVATED

     Extract failed verification count and details from report

     Report to user:
     "🚫 WORKFLOW BLOCKED - Verification Failed

     verification-agent found {N} failed verifications:

     {List each failed verification from report}

     Workflow CANNOT proceed to quality-validator with failed verifications.

     Required actions:
     1. Review failures in .orchestration/verification-report.md
     2. Fix all failed verifications
     3. Re-run verification-agent
     4. Workflow will resume when ALL verifications pass

     This is a HARD BLOCK - no overrides, no exceptions."

     STOP HERE - Do not proceed
     Wait for fixes
     Re-run this check after fixes applied

   CHECK 3: Proceed to Quality Validation
   If verification-report.md exists AND verdict != "BLOCKED":
     ✅ VERIFICATION GATE PASSED

     Report to user:
     "✅ Verification Gate Passed

     All {N} verifications successful.
     Proceeding to Quality Gate 2 (quality-validator).

     Verification evidence: .orchestration/verification-report.md"

     Continue to Quality Gate 2 below
   ```

5. **Quality Gate 2: Development Quality**
   ```markdown
   #CRITICAL: This section ONLY runs if Verification Gate passed above

   Dispatch test-engineer with:
   - Input: All implemented code
   - Task: Comprehensive test suite generation
   - Coverage required: 80% minimum
   - Test types: Unit, integration, security

   Dispatch quality-validator with:
   - Input: All implementation + test results + .orchestration/verification-report.md
   - Task: Score code quality against Gate 2 criteria
   - Required: Score ≥85/100
   - MANDATORY: Read verification-report.md FIRST before scoring

   Scoring criteria:
   - Code quality: 85%
   - Test coverage: 80%
   - Performance benchmarks: met
   - Security scan: no critical issues
   - Verification gate: PASSED (prerequisite)

   #FALSE_COMPLETION: "Tests passing" needs evidence file showing 0 failures
   #ENFORCEMENT_ACTIVE: Cannot reach here without passing verification gate
   ```

### PHASE 3: Validation & Deployment (15-20% of project time)

**Quality Gate 3 Criteria: 95% Production Readiness**

1. **⚠️ MANDATORY ENFORCEMENT: Pre-Deployment Verification Check (HARD BLOCK)**
   ```markdown
   BEFORE final validation, verify ALL previous quality gates passed:

   CHECK 1: Verification Report Exists
   Read .orchestration/verification-report.md

   If file does NOT exist:
     ❌ HARD BLOCK ACTIVATED

     Report to user:
     "🚫 DEPLOYMENT BLOCKED - No Verification Evidence

     Cannot proceed to production deployment without verification-agent evidence.

     This is a critical quality gate violation that should have been caught in Phase 2.

     Required: verification-agent must have run and created verification-report.md

     This is a HARD BLOCK - no production deployment allowed."

     STOP HERE - Cannot deploy without verification

   CHECK 2: Verification Passed
   Read verdict from .orchestration/verification-report.md

   If verdict == "BLOCKED" OR contains "FAILED VERIFICATIONS":
     ❌ HARD BLOCK ACTIVATED

     Report to user:
     "🚫 DEPLOYMENT BLOCKED - Verification Failures Present

     verification-agent reported failures that were never resolved.

     Production deployment CANNOT proceed with failed verifications.

     Review .orchestration/verification-report.md for details.

     This is a HARD BLOCK - fix all failures before deployment."

     STOP HERE

   CHECK 3: Quality Gate 2 Passed
   Read quality-validator reports from Phase 2

   If score < 85/100:
     ❌ HARD BLOCK ACTIVATED

     Report to user:
     "🚫 DEPLOYMENT BLOCKED - Quality Gate 2 Failed

     Phase 2 quality validation scored below threshold.

     Cannot proceed to production without meeting quality standards.

     This is a HARD BLOCK."

     STOP HERE

   If ALL checks pass:
     ✅ PRE-DEPLOYMENT CHECKS PASSED

     Report to user:
     "✅ Pre-Deployment Verification Complete

     - Verification gate: PASSED
     - Quality Gate 2: PASSED
     - Ready for final production validation

     Proceeding to Quality Gate 3..."

     Continue to Final Validation below
   ```

2. **Final Validation**
   ```markdown
   #CRITICAL: This section ONLY runs if all pre-deployment checks passed above

   Dispatch quality-validator with:
   - Input: Complete codebase + all artifacts + verification-report.md + Gate 2 report
   - Task: Production readiness assessment
   - Required: Final validation report ≥95/100
   - MANDATORY: Verify verification-report.md shows ALL VERIFIED

   Final checklist:
   - [ ] All user requirements met (100%)
   - [ ] All tests passing (100%)
   - [ ] No critical security issues (100%)
   - [ ] Documentation complete (95%)
   - [ ] Performance validated (95%)
   - [ ] Verification gate passed (100%) ← NEW REQUIREMENT
   - [ ] Quality Gate 2 passed (100%) ← NEW REQUIREMENT
   ```

2. **User Requirement Frame Verification**
   ```markdown
   #CONTEXT_RECONSTRUCT: Final frame check

   Read .orchestration/user-request.md one final time

   For EACH user complaint/request/requirement:
   1. Quote user's exact words
   2. Evidence file path showing it's addressed
   3. Status: VERIFIED or NOT_VERIFIED

   Example verification table:
   | User Requirement | Evidence Path | Status |
   |-----------------|---------------|---------|
   | "simple login form" | .orchestration/evidence/login-ui/screenshot.png | ✅ VERIFIED |
   | "save user preferences" | .orchestration/evidence/preferences/test-output.log | ✅ VERIFIED |
   | "fast page load" | .orchestration/evidence/performance/lighthouse-score.png | ✅ VERIFIED |

   #CRITICAL: Block yourself if ANY requirement NOT_VERIFIED
   ```

3. **Quality Gate 3: Release Approval**
   ```markdown
   Dispatch quality-validator final approval:
   - Overall score: ≥95/100
   - User verification table: 100% verified
   - Production deployment checklist: complete

   #FALSE_COMPLETION: Do NOT present to user unless 100% verified

   If any item fails → Identify gap → Dispatch agent to fix → Re-validate → Repeat
   ```

4. **Auto-Verification Injection (MANDATORY)**
   ```markdown
   #CRITICAL: AFTER quality-validator approval, BEFORE presenting to user

   Auto-verification system runs automatically in /orca Phase 7.
   You do NOT need to invoke it manually - it's a system-level feature.

   What auto-verification does:
   - Detects completion claims in final response
   - Automatically executes verification tools (xcodebuild, simulator, screenshots, oracles)
   - Injects behavioral evidence into response
   - Detects contradictions (claim vs evidence)
   - Blocks completion if evidence budget not met

   This provides "belt + suspenders" verification:
   1. verification-agent (Phase 5) - Verifies meta-cognitive tags
   2. quality-validator (Phase 6) - Validates evidence completeness
   3. auto-verification (Phase 7) - Automatic behavioral oracles

   #ENFORCEMENT: Even if tags weren't created or verification was skipped,
   auto-verification runs automatically and prevents false completions.

   Evidence budget examples:
   - iOS UI: 5 points (build 1pt + screenshot 2pt + oracle 2pt)
   - Frontend UI: 5 points (build 1pt + screenshot 2pt + playwright 2pt)
   - Backend API: 5 points (build 1pt + curl 2pt + tests 2pt)

   If contradiction detected, auto-verification will:
   - Show claim vs evidence mismatch
   - Block "Fixed!" response
   - Require actual fix before claiming complete
   ```

