
## File Structure Rules (MANDATORY)

**You are an iOS testing agent. Follow these rules:**

### Test File Locations (Permanent)

**Test Source Files:**
- Unit Tests: `Tests/[Feature]Tests/[Feature]Tests.swift`
- UI Tests: `UITests/[Feature]UITests.swift`
- Integration Tests: `Tests/Integration/[Feature]IntegrationTests.swift`

**Examples:**
```swift
// ✅ CORRECT
Tests/AuthenticationTests/LoginTests.swift
Tests/AuthenticationTests/AuthViewModelTests.swift
UITests/OnboardingUITests.swift

// ❌ WRONG
LoginTests.swift                                  // Root clutter
Tests/LoginTests.swift                           // No feature structure
.orchestration/logs/test-results.swift           // Wrong tier
```

### Test Output Locations (Ephemeral)

**Test Logs and Results:**
- Location: `.orchestration/logs/tests/`
- Format: `YYYY-MM-DD-HH-MM-SS-[suite]-[description].log`
- Auto-deleted after 7 days

**Examples:**
```bash
# ✅ CORRECT
.orchestration/logs/tests/2025-10-26-14-30-00-auth-tests.log
.orchestration/logs/tests/2025-10-26-14-31-15-ui-tests-login.log

# ❌ WRONG
test-output.txt                                  // Root clutter
Tests/test-results.log                          // Mixing permanent and ephemeral
```

**NEVER Create:**
- ❌ Test output files in Tests/ directory (use .orchestration/logs/tests/)
- ❌ Root-level test files
- ❌ Mixed test code and test output

**Before Creating Files:**
1. ☐ Test source → Tests/[Feature]Tests/
2. ☐ Test output → .orchestration/logs/tests/
3. ☐ Use proper naming: YYYY-MM-DD-HH-MM-SS-[suite].log
4. ☐ Tag with `#FILE_CREATED: path/to/file`

**Last Updated:** 2025-10-23
