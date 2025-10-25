# Self-Audit Protocol for Claude

**Purpose:** Prevent systemic issues by forcing periodic holistic audits after major changes.

**When to Trigger:** After ANY of these events:
- Creating 3+ new agents in a category
- Deprecating an agent
- Rebuilding a team (iOS, Frontend, Design, Backend)
- Modifying /orca team compositions
- Creating new specialist categories

---

## Mandatory Audit Checklist

### Phase 1: Duplicate Detection (10 min)

**Task:** Search for overlapping responsibilities across all agents.

**Commands:**
```bash
# List all agents by category
ls -1 ~/.claude/agents/*/

# Search for common keywords that might indicate duplicates
grep -r "Tailwind" ~/.claude/agents/ | grep "description:"
grep -r "styling" ~/.claude/agents/ | grep "description:"
grep -r "React" ~/.claude/agents/ | grep "description:"
grep -r "testing" ~/.claude/agents/ | grep "description:"
```

**Questions:**
- [ ] Are there 2+ agents with "styling" in their description?
- [ ] Are there 2+ agents with "Tailwind" in their expertise?
- [ ] Are there 2+ agents with the same framework (React, Next.js, Swift)?
- [ ] Are there 2+ agents with the same responsibility (testing, performance)?

**If YES to any:** Investigate if one is a duplicate. Check creation dates, file locations, and taxonomy boundaries.

---

### Phase 2: Agent Count Verification (5 min)

**Task:** Verify agent counts match documentation.

**Commands:**
```bash
# Count actual agents
find ~/.claude/agents/ios-specialists -name "*.md" | wc -l
find ~/.claude/agents/frontend-specialists -name "*.md" | wc -l
find ~/.claude/agents/design-specialists -name "*.md" | wc -l

# Check documented counts
grep "iOS Specialists" ~/claude-vibe-code/QUICK_REFERENCE.md
grep "Frontend Specialists" ~/claude-vibe-code/QUICK_REFERENCE.md
grep "Design Specialists" ~/claude-vibe-code/QUICK_REFERENCE.md
```

**Questions:**
- [ ] Does actual iOS count match QUICK_REFERENCE.md?
- [ ] Does actual Frontend count match QUICK_REFERENCE.md?
- [ ] Does actual Design count match QUICK_REFERENCE.md?
- [ ] Does total agent count match QUICK_REFERENCE.md header?

**If NO to any:** Update QUICK_REFERENCE.md immediately.

---

### Phase 3: /orca Integration Check (10 min)

**Task:** Verify /orca uses current agents, not deprecated ones.

**Commands:**
```bash
# Check for deprecated agent usage
grep -n "design-engineer" ~/.claude/commands/orca.md
grep -n "frontend-engineer" ~/.claude/commands/orca.md
grep -n "ios-engineer" ~/.claude/commands/orca.md

# Verify specialist team compositions
grep -A 20 "iOS Team" ~/.claude/commands/orca.md
grep -A 20 "Frontend Team" ~/.claude/commands/orca.md
grep -A 20 "Mobile Team" ~/.claude/commands/orca.md
grep -A 20 "Backend Team" ~/.claude/commands/orca.md
```

**Questions:**
- [ ] Does iOS Team use 21 iOS specialists (not ios-engineer)?
- [ ] Does Frontend Team use design specialists (ux-strategist, tailwind-specialist, ui-engineer, design-reviewer)?
- [ ] Does Mobile Team use design specialists?
- [ ] Does Backend Team reference design specialists for admin UI?
- [ ] Are ALL deprecated agents (design-engineer, frontend-engineer, ios-engineer) removed from team compositions?

**If NO to any:** Update /orca team compositions immediately.

---

### Phase 4: Taxonomy Boundary Check (10 min)

**Task:** Verify no category boundary violations (e.g., styling in frontend instead of design).

**Questions:**
- [ ] Is styling ONLY in design specialists (tailwind-specialist, css-specialist)?
- [ ] Are React/Next.js patterns ONLY in frontend specialists?
- [ ] Are Swift/SwiftUI patterns ONLY in iOS specialists?
- [ ] Does each specialist have ONE clear domain (no overlap)?

**If NO to any:** Review AGENT_TAXONOMY.md and consolidate or deprecate duplicates.

---

### Phase 5: Mandatory Specialist Coverage (5 min)

**Task:** Verify MANDATORY specialists exist and are referenced in /orca.

**Mandatory Specialists:**
1. accessibility-specialist (design) - WCAG compliance
2. design-reviewer (design) - Final design QA
3. frontend-testing-specialist (frontend) - Frontend testing
4. verification-agent (quality) - Meta-cognitive verification
5. quality-validator (quality) - Final gate

**Questions:**
- [ ] Do these 5 specialists exist as agent files?
- [ ] Are they marked as MANDATORY in /orca teams?
- [ ] Are they included in ALL relevant team examples in QUICK_REFERENCE.md?

**If NO to any:** Add missing agents or update /orca to enforce MANDATORY usage.

---

### Phase 6: Documentation Consistency (10 min)

**Task:** Verify documentation matches implementation.

**Files to Check:**
1. QUICK_REFERENCE.md - Agent counts, team compositions
2. FRONTEND_MIGRATION_GUIDE.md - Specialist names, counts
3. IOS_MIGRATION_GUIDE.md - Specialist names, counts
4. AGENT_TAXONOMY.md - Category boundaries

**Questions:**
- [ ] Do all migration guides reference correct specialist counts?
- [ ] Do all examples use current specialists (not deprecated)?
- [ ] Are team composition examples consistent across docs?
- [ ] Does AGENT_TAXONOMY.md match actual agent organization?

**If NO to any:** Update affected documentation files.

---

### Phase 7: Deprecation Completeness (10 min)

**Task:** Verify deprecated agents are fully deprecated (not just marked).

**For Each Deprecated Agent:**
```bash
# Check if deprecated agent is still referenced
grep -r "design-engineer" ~/.claude/commands/
grep -r "frontend-engineer" ~/.claude/commands/
grep -r "ios-engineer" ~/.claude/commands/

# Check auto_activate keywords
grep -A 5 "auto_activate:" ~/.claude/agents/specialized/design-engineer.md
```

**Questions:**
- [ ] Is deprecated agent's auto_activate keywords array empty?
- [ ] Is deprecated agent removed from ALL /orca team compositions?
- [ ] Is deprecated agent marked as DEPRECATED in QUICK_REFERENCE.md?
- [ ] Does deprecated agent's description explain replacement specialists?

**If NO to any:** Complete deprecation (empty keywords, remove from /orca, update docs).

---

## Audit Execution Process

### When to Run

**Automatically trigger after:**
1. Creating 3+ new agents in a session
2. Deprecating ANY agent
3. Modifying /orca team compositions
4. Completing a specialist rebuild (iOS, Frontend, Design)

### How to Run

**Option 1: Manual Checklist**
- Work through each phase sequentially
- Check off each question
- Fix issues immediately when found

**Option 2: Automated Script**
```bash
# Run from claude-vibe-code root
./scripts/self-audit.sh
```
(Future: Create this script)

**Option 3: /ultra-think Delegation**
```
/ultra-think "Run self-audit protocol from SELF_AUDIT_PROTOCOL.md:
- Phase 1: Duplicate detection
- Phase 2: Agent count verification
- Phase 3: /orca integration check
- Phase 4: Taxonomy boundary check
- Phase 5: Mandatory specialist coverage
- Phase 6: Documentation consistency
- Phase 7: Deprecation completeness

For each phase, run verification commands and identify issues."
```

### What to Do with Results

**If issues found:**
1. Create TODO list with all issues
2. Fix issues immediately (same session)
3. Re-run audit to verify fixes
4. Update session context with audit results

**If no issues found:**
- Document "Audit clean" in session notes
- Proceed with confidence

---

## Integration with Workflows

### Add to /orca Command

```markdown
## Phase 7: Post-Execution Self-Audit (IF major changes)

**Trigger:** If this /orca execution:
- Created 3+ new agents
- Deprecated an agent
- Modified team compositions

**Action:** Run self-audit protocol from SELF_AUDIT_PROTOCOL.md to verify system consistency.
```

### Add to Completion Drive

```markdown
#AUDIT_REQUIRED

When you see this tag, run SELF_AUDIT_PROTOCOL.md before claiming completion.
```

### Add to Session End

```markdown
Before /session-save, if this session involved:
- Agent creation/deprecation
- /orca modifications
- Specialist rebuilds

Run quick audit: Phases 1, 2, 3 (15 min) to catch critical issues.
```

---

## Why This Failed Before

### Root Cause Analysis

**What went wrong:**
1. **Incremental blindness:** Built iOS team → then Frontend → then Design, never looked holistically
2. **No integration verification:** Never checked if /orca used new specialists
3. **No count tracking:** Created 21 iOS specialists but documented 19
4. **No duplicate detection:** Created styling-specialist without checking for tailwind-specialist
5. **No deprecation protocol:** Marked agents DEPRECATED but never removed from /orca

**Pattern:**
- Individual specialist creation was correct
- System-level integration was broken
- No holistic view until forced audit

### How This Protocol Prevents It

1. **Phase 1 (Duplicate Detection):** Would have caught styling-specialist vs tailwind-specialist
2. **Phase 2 (Agent Count):** Would have caught 19 vs 21 iOS specialists
3. **Phase 3 (/orca Integration):** Would have caught design-engineer still in use
4. **Phase 4 (Taxonomy Boundaries):** Would have flagged styling as design responsibility
5. **Phase 7 (Deprecation Completeness):** Would have ensured design-engineer fully removed

**Enforcement:**
- Mandatory after 3+ agent creations
- Mandatory after deprecations
- Mandatory after /orca modifications
- Use #AUDIT_REQUIRED tag in completion-drive

---

## Audit Log Template

```markdown
# Self-Audit Log - [DATE]

## Trigger Event
[What triggered this audit: "Completed iOS specialist rebuild" / "Deprecated design-engineer" / etc.]

## Phase 1: Duplicate Detection
- [ ] No styling duplicates
- [ ] No framework duplicates
- [ ] No testing duplicates
- **Issues Found:** [None / List issues]

## Phase 2: Agent Count Verification
- iOS: [X actual] vs [Y documented] - [✅ Match / ❌ Mismatch]
- Frontend: [X actual] vs [Y documented] - [✅ Match / ❌ Mismatch]
- Design: [X actual] vs [Y documented] - [✅ Match / ❌ Mismatch]
- **Issues Found:** [None / List issues]

## Phase 3: /orca Integration
- [ ] iOS Team uses specialists (not ios-engineer)
- [ ] Frontend Team uses design specialists
- [ ] No deprecated agents in /orca
- **Issues Found:** [None / List issues]

## Phase 4: Taxonomy Boundaries
- [ ] Styling only in design
- [ ] React only in frontend
- [ ] Swift only in iOS
- **Issues Found:** [None / List issues]

## Phase 5: Mandatory Specialists
- [ ] accessibility-specialist exists and referenced
- [ ] design-reviewer exists and referenced
- [ ] frontend-testing-specialist exists and referenced
- [ ] verification-agent exists and referenced
- [ ] quality-validator exists and referenced
- **Issues Found:** [None / List issues]

## Phase 6: Documentation Consistency
- [ ] QUICK_REFERENCE.md matches implementation
- [ ] Migration guides match implementation
- [ ] AGENT_TAXONOMY.md matches implementation
- **Issues Found:** [None / List issues]

## Phase 7: Deprecation Completeness
- [ ] All deprecated agents have empty auto_activate
- [ ] All deprecated agents removed from /orca
- [ ] All deprecated agents marked in QUICK_REFERENCE.md
- **Issues Found:** [None / List issues]

## Result
- **Status:** [✅ CLEAN / ❌ ISSUES FOUND]
- **Issues Fixed:** [List fixed issues]
- **Follow-up Required:** [None / List follow-up tasks]

## Sign-off
Audit completed: [DATE + TIME]
Next audit due: [After next major change]
```

---

### Phase 8: File Organization Audit (5 min)

**Task:** Verify file organization follows strict rules (no logs in docs/, no extra docs in main/).

**Commands:**
```bash
# Run verification script
./scripts/verify-file-organization.sh

# Manual checks if script unavailable
ls *.md | grep -v "README\|QUICK_REFERENCE\|CHANGELOG"  # Should be empty
ls docs/ | grep -E '(COMPLETE|LOG|session-|\.diagram-|\.log|\.txt)$'  # Should be empty
```

**Questions:**
- [ ] Main folder contains ONLY: README.md, QUICK_REFERENCE.md, CHANGELOG.md?
- [ ] docs/ folder contains NO logs (*-COMPLETE.md, *.log, *.txt)?
- [ ] docs/ folder contains NO session files (session-*.md)?
- [ ] docs/ folder contains NO temporary diagram files (.diagram-*.md)?
- [ ] All files in docs/ are permanent public documentation?

**If NO to any:** Fix file organization immediately.

**Common violations:**
- STAGES-1-6-COMPLETE.md in docs/ (it's a log, should be deleted)
- session-*.md in docs/ (temporary, should be gitignored)
- .diagram-*.md in docs/ (temporary work files, should be deleted)

---

### Phase 9: My Own Completion Claims Audit (5 min)

**Task:** Verify MY work follows same quality standards as agents' work.

**Commands:**
```bash
# Check if I used TodoWrite
ls .claude-todo-*.json 2>/dev/null  # Should exist if used

# Check if I provided verification evidence
# Review completion messages for verification commands and outputs
```

**Questions:**
- [ ] Did I use TodoWrite BEFORE starting work (not after)?
- [ ] Did I extract user's constraints explicitly (exact quotes)?
- [ ] Did I run verification commands BEFORE claiming complete?
- [ ] Did I provide verification output as evidence?
- [ ] Did I classify file types (log vs documentation) before file operations?
- [ ] Did I re-read user's original instruction before completion?

**If NO to any:** I'm operating OUTSIDE the quality system.

**Red flags:**
- User asked "did you check X?" → I didn't verify proactively
- User found errors after I claimed complete → I didn't verify
- No verification evidence in completion message → I just claimed without proof
- Files in wrong locations → I didn't classify file types

**Action if failed:**
1. Acknowledge I bypassed quality gates
2. Run proper verification NOW
3. Fix any issues found
4. Use forcing functions next time (todowrite-first skill, completion-checklist skill)

---

## Summary

**This protocol prevents:**
- ❌ Creating duplicates (styling-specialist vs tailwind-specialist)
- ❌ Documentation drift (19 vs 21 specialists)
- ❌ Stale references (design-engineer in /orca)
- ❌ Missing integration (design specialists in frontend teams)
- ❌ Incomplete deprecation (agents marked but still used)
- ❌ File organization errors (logs in docs/, extra docs in main/) **[NEW - Phase 8]**
- ❌ Bypassing quality gates (claiming done without verification) **[NEW - Phase 9]**

**This protocol enforces:**
- ✅ Holistic system view after major changes
- ✅ Cross-file consistency verification
- ✅ Taxonomy boundary enforcement
- ✅ Mandatory specialist coverage
- ✅ Complete deprecation process
- ✅ File organization rules **[NEW - Phase 8]**
- ✅ Quality gates for MY work (not just agents) **[NEW - Phase 9]**

**Trigger conditions:**
- After creating 3+ agents
- After deprecating any agent
- After modifying /orca
- After rebuilding a specialist category
- After ANY file organization work **[NEW - Phase 8]**
- After claiming ANY task complete **[NEW - Phase 9]**
- Use #AUDIT_REQUIRED tag in code

**Time investment:** 60-70 minutes per audit (worth it to prevent systemic failures)

---

**Last Updated:** 2025-10-25 (Added Phase 8 and 9)
**Status:** Active - Use immediately
**Next Review:** After next major agent change
