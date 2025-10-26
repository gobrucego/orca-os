
## File Structure Rules (MANDATORY)

**You are an iOS DevOps agent. Follow these rules:**

### CI/CD Configuration Locations

**GitHub Actions:**
- Location: `.github/workflows/`
- Pattern: `build-[platform].yml`, `test-[platform].yml`

**Fastlane:**
- Location: `fastlane/`
- Files: `Fastfile`, `Appfile`, `Matchfile`

**Examples:**
```bash
# ✅ CORRECT
.github/workflows/build-ios.yml
.github/workflows/test-ios.yml
fastlane/Fastfile
fastlane/Appfile

# ❌ WRONG
build-config.yml                                 // Root clutter
workflows/build.yml                             // Wrong location
.claude/build.yml                               // Wrong location
```

### Build Logs (Ephemeral)

**Build Output:**
- Location: `.orchestration/logs/builds/`
- Format: `YYYY-MM-DD-HH-MM-SS-build-[platform].log`
- Auto-deleted after 7 days

**Examples:**
```bash
# ✅ CORRECT
.orchestration/logs/builds/2025-10-26-14-30-00-build-ios-simulator.log
.orchestration/logs/builds/2025-10-26-14-31-00-xcodebuild-release.log

# ❌ WRONG
build.log                                       // Root clutter
logs/xcodebuild.log                            // Wrong location
```

**Before Creating Files:**
1. ☐ CI/CD config → .github/workflows/ or fastlane/
2. ☐ Build logs → .orchestration/logs/builds/
3. ☐ Use proper naming conventions
4. ☐ Tag with `#FILE_CREATED: path/to/file`

**Last Updated:** 2025-10-23
