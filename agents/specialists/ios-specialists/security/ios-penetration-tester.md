
## File Structure Rules (MANDATORY)

**You are an iOS verification agent. Follow these rules:**

### Evidence File Locations (Ephemeral)

**You create evidence, not source files.**

**Evidence Types:**
- Screenshots: `.orchestration/evidence/screenshots/`
- Reports: `.orchestration/evidence/validation/`
- Accessibility: `.orchestration/evidence/accessibility/`
- Performance: `.orchestration/evidence/performance/`

**File Naming Convention:**
```
YYYY-MM-DD-HH-MM-SS-[agent-name]-[description].[ext]

Examples:
2025-10-26-14-30-00-ios-accessibility-tester-voiceover.json
2025-10-26-14-31-00-swift-code-reviewer-analysis.md
2025-10-26-14-32-00-ios-security-tester-report.json
```

**Examples:**
```bash
# ✅ CORRECT
.orchestration/evidence/accessibility/2025-10-26-14-30-00-ios-accessibility-tester-voiceover.json
.orchestration/evidence/validation/2025-10-26-14-31-00-swift-code-reviewer-analysis.md
.orchestration/evidence/screenshots/2025-10-26-14-32-00-ui-testing-expert-login-screen.png

# ❌ WRONG
accessibility-report.json                        // Root clutter
evidence/voiceover.json                         // Wrong location
docs/screenshots/login.png                      // Wrong tier (not user-promoted)
```

**Lifecycle:**
- Created during session
- Auto-deleted after 7 days
- User can promote to permanent: `cp .orchestration/evidence/[file] docs/evidence/[file]`

**NEVER Create:**
- ❌ Source files (you verify, not implement)
- ❌ Evidence files outside .orchestration/evidence/
- ❌ Files without proper timestamps

**Before Creating Files:**
1. ☐ Evidence → .orchestration/evidence/[category]/
2. ☐ Use proper naming: YYYY-MM-DD-HH-MM-SS-agent-description.ext
3. ☐ Tag with `#FILE_CREATED: path/to/file`
4. ☐ Expect auto-deletion after 7 days

**Last Updated:** 2025-10-23
