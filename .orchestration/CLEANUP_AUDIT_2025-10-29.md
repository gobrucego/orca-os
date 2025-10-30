# Cleanup Audit Report - 2025-10-29

**Auditor:** meta-orchestrator
**Purpose:** Full cleanup of claude-vibe-code and ~/.claude directories
**Goal:** Remove logs, temp files, duplicates; establish clear file organization rules

---

## ROOT DIRECTORY CLEANUP TARGETS

### IMMEDIATE DELETION (Session Logs & Temp Files):

**Context files (session-specific, not needed):**
- `.claude-design-dna-context.md`
- `.claude-orchestration-context.md`
- `.claude-playbook-context.md`
- `.claude-session-context.md`

**Diagram reports (verification artifacts):**
- `.diagram-audit-report.md`
- `.diagram-verification.md`
- `.rebuilt-diagrams.md`

**Temp workspace directories:**
- `.tmp-ws-test/` (entire directory)
- `.tmp-ws-test2/` (entire directory)

**Timestamped workspace junk:**
- `[21:32:55] Create workspace: .orchestration`
- `[21:32:56] Create workspace: .orchestration`
- `[21:34:04] Create workspace: .orchestration`
- `[21:34:05] Create workspace: .orchestration`
- `[21:34:31] Create workspace: .orchestration`
- `[21:34:32] Create workspace: .orchestration`
- `[21:34:33] Create workspace: .orchestration`
- `[21:34:34] Create workspace: .orchestration`

**Hidden verification dirs:**
- `.verified/`
- `.tweak_verified/`

**Hidden config (review first):**
- `.worktrees/` (check if git worktrees are active)

**System junk:**
- `.DS_Store` (everywhere)
- `.obsidian/` (unless you use Obsidian for this project)

---

## .CLAUDE SUBDIRECTORY CLEANUP

### Files to DELETE:

**Deprecated scripts (Workshop handles this now):**
- `.claude/workshop-pre-compact.sh`
- `.claude/workshop-session-end.sh`
- `.claude/workshop-session-start.sh`

**User profile (merged into global CLAUDE.md):**
- `.claude/USER_PROFILE.md`

**Deployment manifest (outdated):**
- `.claude/DEPLOYMENT_MANIFEST.md`

**Workshop integration (redundant with hooks/SessionStart.sh):**
- `.claude/WORKSHOP_INTEGRATION.md`

**Local settings (project-specific overrides?):**
- `.claude/settings.local.json` (CHECK CONTENTS FIRST)

---

## .ORCHESTRATION SUBDIRECTORY CLEANUP

### Files to MOVE to ::archive or DELETE:

**Delivery reports (session artifacts):**
- `DELIVERY-SUMMARY.md`
- `phase3-completion-report.md`
- `quality-validation-APPROVED.md`
- `quality-validation-final.md`
- `quality-validation.md`

**Migration guides (ALREADY in .orchestration, should be in ::archive):**
- `DESIGN_MIGRATION_GUIDE.md`
- `FRONTEND_MIGRATION_GUIDE.md`
- `IOS_MIGRATION_GUIDE.md`

**Session completion logs:**
- `design-agent-rebuild-SESSION-COMPLETE.md`
- `frontend-team-rebuild-COMPLETE.md`
- `ios-team-rebuild-COMPLETE.md`
- `ios-simulator-skill-INSTALLED.md`
- `auto-verification-integration-complete.md`

**Analysis logs:**
- `design-agent-ultrathink-analysis.md`
- `frontend-agent-ultrathink-analysis.md`
- `design-analysis-session-log.md`
- `ios-team-gap-analysis.md`
- `ios-team-rebuild-analysis.md`
- `synthesis-analysis.md`
- `verification-enforcement-analysis.md`
- `verification-system-integration-analysis.md`

**Master plans (session artifacts):**
- `design-agent-rebuild-MASTER-PLAN.md`
- `frontend-agent-rebuild-MASTER-PLAN.md`
- `plan-1-agent-refactoring.md`
- `plan-2-orca-teams.md`
- `plan-3-documentation-consistency.md`
- `unified-implementation-plan.md`

**Guidelines (should be in docs/):**
- `DESIGN-GUIDELINES.md`
- `OPTIMIZATION.md`
- `SWIFTUI-DESIGN-SYSTEM.md`

**Verification reports (session artifacts):**
- `refactoring-verification-report.md`
- `verification-report.md`
- `RESPONSE_AWARENESS_IMPLEMENTATION_REPORT.md`
- `SYNTHESIS_COMPLETE.md`

**System audits:**
- `SYSTEM_AUDIT_2025-10-23.md`
- `SYSTEM_AUDIT_2025-10-25.md`

**Protocols (should be in docs/):**
- `PLAN_CORRUPTION_PREVENTION.md`
- `PLAN_VALIDATION_PROTOCOL.md`
- `PRE_FLIGHT_CHECKLIST.md`

**Work artifacts:**
- `before-state.md`
- `success-criteria.md`
- `work-plan.md`
- `swift6-modern-patterns-guide.md`

**Active logs (probably still useful):**
- `agent-log.md` (KEEP - active)
- `implementation-log.md` (KEEP - active)
- `user-request.md` (KEEP - active)

---

## SUBDIRECTORIES TO REVIEW/CLEANUP

### .orchestration/logs/
- Purpose: Session logs
- Action: Archive old logs, keep recent only

### .orchestration/evidence/
- Purpose: Screenshots, test output
- Action: Archive old evidence, keep recent only

### .orchestration/sessions/
- Purpose: Session summaries
- Action: Keep (useful for Workshop)

### .orchestration/playbooks/
- Purpose: ACE playbook system
- Action: Keep (active system)

### .orchestration/reference/
- Purpose: Extracted reference docs for agents
- Action: Keep (active system)

### .orchestration/.backup/
- Purpose: Old backups
- Action: DELETE entire directory

### .orchestration/agent-skill-vectors/
- Purpose: Agent specialization tracking (experimental)
- Action: Review - if not used, DELETE

### .orchestration/completion-criteria/
- Purpose: Quality gate definitions (experimental)
- Action: Review - if superseded by quality-gates.md, DELETE

### .orchestration/intent-taxonomy.json
- Purpose: Routing taxonomy (experimental)
- Action: Review - if not used by /orca, DELETE

### .orchestration/knowledge-graph/
- Purpose: Experimental feature
- Action: DELETE if not actively used

### .orchestration/mode.json
- Purpose: Unknown
- Action: Review and DELETE if unused

### .orchestration/multi-objective-optimizer/
- Purpose: Experimental feature
- Action: DELETE if not actively used

### .orchestration/oracles/
- Purpose: Behavioral oracles (experimental)
- Action: Review - part of ACE system or standalone?

### .orchestration/pattern-embeddings/
- Purpose: Experimental feature
- Action: DELETE if not actively used

### .orchestration/proofpacks/
- Purpose: Evidence bundles (experimental)
- Action: Review - if not used, DELETE

### .orchestration/quality-checklist/
- Purpose: Superseded by quality-gates.md?
- Action: Review and DELETE if redundant

### .orchestration/screenshot-diff/
- Purpose: Visual regression testing (experimental)
- Action: Review - if not used, DELETE

### .orchestration/signals/
- Purpose: ACE signal log
- Action: Keep if part of active ACE system

### .orchestration/specialist-certification/
- Purpose: Experimental feature
- Action: DELETE if not actively used

### .orchestration/stage-4/
### .orchestration/stage-6-complete/
- Purpose: Session stage markers
- Action: DELETE

### .orchestration/two-phase-commit/
- Purpose: Experimental feature
- Action: DELETE if not actively used

### .orchestration/verification/
### .orchestration/verification-budget/
### .orchestration/verification-replay/
### .orchestration/verification-system/
- Purpose: Verification system components
- Action: Keep if active, DELETE if superseded by verification-agent

### .orchestration/work-orders/
- Purpose: Task queue system (experimental)
- Action: DELETE if not actively used

---

## OUT DIRECTORY CLEANUP

**What is this?**
- Looks like build output or exported site

**Contents:**
- `out/_next/` (Next.js build)
- `out/api/`, `out/api 2/`, `out/api 3/` (duplicates?)
- `out/protocols/`, `out/protocols 2/`, `out/protocols 3/` (duplicates?)
- `out/design.html`, `out/index.html` (static site)
- `out/codex-cli-mcp-memory/` (package?)
- `out/codex-cli-mcp-memory.tar.gz`
- `out/codex-cli-mcp-memory.zip`

**Action:** Should `out/` be gitignored entirely? This looks like build artifacts.

---

## COMMANDS DIRECTORY CLEANUP

**Deprecated commands:**
- `commands/session-resume.md` (deprecated - Workshop handles this)
- `commands/session-save.md` (deprecated - Workshop handles this)

**Backup file:**
- `commands/orca-BACKUP-20251029.md` (DELETE - git has history)

**Finalize command:**
- `commands/finalize.md` (review - is this actively used?)

**Tweak command:**
- `commands/tweak.md` (review - is this actively used?)

---

## DEV-LOGS DIRECTORY

**Keep:** Session logs for reference
**Action:** Move old logs to ::archive if >30 days old

---

## QA-LOGS DIRECTORY

**Keep:** QA audit results for reference
**Action:** None needed

---

## REFRENCES (TYPO) DIRECTORY

**Fix typo:** Should be `references/`
**Contents:** External papers, cloned repos
**Action:** Rename to `references/`

---

## DOCS SUBDIRECTORIES TO REVIEW

### docs/atlas/
- Purpose: Unknown
- Action: Review contents

### docs/brand/
- Purpose: Brand guidelines
- Action: Keep

### docs/changes/
- Purpose: Change logs (duplicates CHANGELOG.md?)
- Action: Review and consolidate

### docs/deprecated/
- Purpose: Old docs
- Action: Keep (intentional archive)

### docs/plans/
- Purpose: Implementation plans
- Action: Review - if session artifacts, move to .orchestration

### docs/proposals/
- Purpose: Feature proposals
- Action: Keep if current, archive if old

### docs/testing/
- Purpose: Testing documentation
- Action: Keep

---

## AGENTS DIRECTORY CLEANUP

**Context file:**
- `agents/.claude-orchestration-context.md` (DELETE - session artifact)

---

## EXT DIRECTORY

**What is this?**
- `ext/codex-cli/` - External tool?
- Action: Review if needed

---

## TEMPLATES DIRECTORY

**Contents:**
- `templates/ios/` - iOS templates
- Action: Keep

---

## MCP DIRECTORY

**Contents:**
- `mcp/chrome-devtools-mcp/`
- `mcp/xcodebuildmcp/`
- Action: Keep (active MCP servers)

---

## GLOBAL ~/.CLAUDE AUDIT (Separate Task)

Will audit global directory after local cleanup complete.

---

## CLEANUP EXECUTION PLAN

### Phase 1: Delete obvious junk
1. All `.DS_Store` files
2. Temp workspace directories (`.tmp-ws-test`, `.tmp-ws-test2`)
3. Timestamped workspace files
4. Context files in root (`.claude-*-context.md`)
5. Diagram reports in root

### Phase 2: Archive session artifacts
1. Move .orchestration session logs to ::archive
2. Move .orchestration master plans to ::archive
3. Move .orchestration completion reports to ::archive
4. Move dev-logs >30 days to ::archive

### Phase 3: Remove experimental/unused features
1. Delete experimental .orchestration subdirectories if confirmed unused
2. Delete deprecated commands
3. Delete backup files

### Phase 4: Consolidate and organize
1. Rename `refrences/` → `references/`
2. Review and consolidate docs/changes/ with CHANGELOG.md
3. Clean up out/ directory

### Phase 5: Create file organization rules
1. Create `docs/FILE_ORGANIZATION.md`
2. Update workflow-orchestrator to enforce rules
3. Add to verification-agent checklist

---

## FILE ORGANIZATION RULES (To Document)

**Logs and session artifacts:**
- Location: `.orchestration/logs/` OR `::archive/` (if >30 days)
- NEVER: Root directory, docs/, agents/, commands/

**Evidence (screenshots, test output):**
- Location: `.orchestration/evidence/`
- Retention: 30 days, then archive

**Temporary files:**
- Location: `.orchestration/tmp/` (create if needed)
- Lifetime: Session only, delete on completion

**Agent-generated reports:**
- Location: `.orchestration/reports/` (create if needed)
- Retention: Current session only, archive when session ends

**Permanent documentation:**
- Location: `docs/`
- Version controlled in git

**Reference materials:**
- Location: `references/` (NOT refrences)
- Gitignored unless explicitly needed

**Build artifacts:**
- Location: `out/`, `dist/`, `build/`
- Gitignored always

---

---

## GLOBAL ~/.CLAUDE DIRECTORY AUDIT

### MASSIVE CLEANUP NEEDED

**Todo files (325 total!):**
- Location: `~/.claude/todos/`
- Issue: Claude Code creates UUID-based todo JSON files that NEVER get cleaned up
- Action: DELETE ALL (todo state is transient, not persistent)
- Command: `rm -rf ~/.claude/todos/*`

**Debug logs (12 files):**
- Location: `~/.claude/debug/`
- Issue: UUID-based debug logs from sessions
- Action: DELETE ALL (stale debug logs)
- Command: `rm ~/.claude/debug/*.txt`

**System junk:**
- `.DS_Store` files everywhere
- Action: `find ~/.claude -name ".DS_Store" -delete`

**Context files in agents directory:**
- `~/.claude/agents/.claude-orchestration-context.md`
- Action: DELETE (session artifact)

**Deprecated manifest:**
- `~/.claude/DEPLOYMENT_MANIFEST.md`
- Action: DELETE (outdated, git history has this)

**History file:**
- `~/.claude/history.jsonl`
- Purpose: Unknown (Claude Code history?)
- Action: Review size, may need rotation

**File index:**
- `~/.claude/file_index.md`
- Purpose: Unknown
- Action: Review if actively used

**Project-specific CLAUDE.md:**
- `~/.claude/CLAUDE.md.project`
- Purpose: Unknown
- Action: Review if needed or DELETE

**Report in wrong location:**
- `~/.claude/visual-verification-implementation-report.md`
- Action: Should be in project .orchestration/, not global

**Validation schema:**
- `~/.claude/agentfeedback-validation-schema.yml`
- Action: Keep (active system)

**Changelog:**
- `~/.claude/CHANGELOG.md`
- Action: Keep (version history)

**Config directory:**
- `~/.claude/config/.opus-disabled` (marker file)
- `~/.claude/config/*.yml` (configuration files)
- `~/.claude/config/*.yml.backup` (backup files)
- Action: Keep configs, DELETE .backup files

**Context directory:**
- `~/.claude/context/daisyui.llms.txt`
- Purpose: Context loading for daisyUI
- Action: Keep

**Design inspiration:**
- `~/.claude/design-inspiration/` (entire system)
- Purpose: Design reference gallery
- Action: Keep (active system)

**Git hooks:**
- `~/.claude/git-hooks/pre-commit`
- `~/.claude/git-hooks/pre-push`
- Purpose: Git hook templates
- Action: Keep

**Plugins directory:**
- `~/.claude/plugins/` (if exists)
- Purpose: Claude Code plugins
- Action: Keep

**Scripts directory:**
- `~/.claude/scripts/` (from earlier sync)
- Purpose: Custom scripts (statusline, etc.)
- Action: Keep

**Skills directory:**
- `~/.claude/skills/` (if exists)
- Purpose: Custom skills
- Action: Keep

---

## FILE ORGANIZATION DOCUMENTATION REQUIRED

### Create ~/.claude/docs/FILE_ORGANIZATION.md

**Purpose:** Strict rules for where agents can write files

**Rules to enforce:**

1. **NEVER write to project root** (except .gitignore, README.md, package.json, etc. - whitelisted files only)

2. **Logs MUST go to:**
   - `.orchestration/logs/` (project-specific)
   - `~/.claude/debug/` is for Claude Code internals ONLY

3. **Evidence MUST go to:**
   - `.orchestration/evidence/` (project-specific)
   - NEVER root, NEVER docs/

4. **Reports MUST go to:**
   - `.orchestration/reports/` (if session-specific)
   - `docs/` (if permanent documentation)

5. **Temporary files MUST go to:**
   - `.orchestration/tmp/` (create if needed)
   - NEVER root, NEVER hidden dot-files

6. **Context files are FORBIDDEN in:**
   - Project root
   - `docs/`
   - `agents/`
   - `commands/`
   - Anywhere except `.orchestration/`

7. **Backup files are FORBIDDEN:**
   - No `.backup` files
   - No `file-BACKUP-DATE.md` files
   - Git history is the backup

8. **UUID/timestamp files are FORBIDDEN:**
   - No `[TIMESTAMP] message.md` files
   - No UUID-based filenames in project directories

9. **Duplicate directories are FORBIDDEN:**
   - No `api/`, `api 2/`, `api 3/`
   - No `protocols/`, `protocols 2/`, `protocols 3/`

10. **Build artifacts MUST be gitignored:**
    - `out/`, `dist/`, `build/`, `.next/`, `target/`
    - NEVER committed to git

---

## CLEANUP EXECUTION SUMMARY

### High Priority (Immediate):
1. DELETE 325 todo files in `~/.claude/todos/`
2. DELETE all `.DS_Store` files (both locations)
3. DELETE temp workspace directories in project
4. DELETE timestamped workspace files in project
5. DELETE context files in project root

### Medium Priority (Session artifacts):
1. Archive .orchestration session logs >30 days
2. Archive .orchestration completion reports
3. Archive .orchestration master plans
4. DELETE experimental .orchestration subdirectories if unused

### Low Priority (Organization):
1. Rename `refrences/` → `references/`
2. Consolidate docs/changes/ with CHANGELOG.md
3. Review and clean out/ directory
4. Create FILE_ORGANIZATION.md enforcement

---

**Total cleanup impact:**
- **~350+ files to delete** (todo JSONs, debug logs, temp files)
- **~50+ directories to review/archive** (.orchestration subdirs)
- **~20+ session artifacts to archive** (completion reports, plans)

**Audit complete. Awaiting cleanup approval and FILE_ORGANIZATION.md creation.**
