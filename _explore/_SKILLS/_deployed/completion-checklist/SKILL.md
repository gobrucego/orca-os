---
name: completion-checklist
description: MANDATORY checklist before claiming ANY task complete - verifies file organization, constraints, documentation consistency, and provides evidence
---

# Completion Checklist: Pre-Completion Verification Gate

**Trigger:** BEFORE claiming ANY task complete

**Purpose:** Force verification BEFORE completion claim (not after user asks)

**Why this exists:** To prevent claiming "done" without verifying, which forces user to become my quality-validator.

---

## MANDATORY Pre-Completion Protocol

**STOP. Do NOT claim task complete until ALL items verified.**

### Checklist Items

#### 1. File Organization Verification

```bash
# Run verification script
./scripts/verify-file-organization.sh

# Expected output: ✅ File organization verified successfully
# If errors: Fix them before claiming complete
```

**Manual checks if script unavailable:**
```bash
# Main folder should ONLY have:
ls *.md
# Expected: README.md  QUICK_REFERENCE.md  CHANGELOG.md

# docs/ should NOT have logs:
ls docs/ | grep -E '(COMPLETE|LOG|session-|\.diagram-|\.log|\.txt)$'
# Expected: (empty output)
```

**Block completion if:**
- ❌ Unexpected files in main folder
- ❌ Logs in docs/ folder (*-COMPLETE.md, *.log, *.txt)
- ❌ Temporary files not cleaned up

---

#### 2. Constraint Compliance Verification

**Re-read user's original instruction:**
- Scroll up to user's message
- Extract EVERY constraint
- For each constraint, verify compliance

**Example:**

User said: "i should NOT see any logs in the /docs folder"

Verification:
```bash
ls docs/ | grep -E '(COMPLETE|LOG|\.log)$'
# Expected: (empty)
# Actual: (empty) ✅
```

**Block completion if:**
- ❌ ANY user constraint violated
- ❌ Can't prove constraint compliance

---

#### 3. Documentation Consistency Verification

**Agent counts must match:**
```bash
# README.md agent count
grep -o "Agents ([0-9]* Total)" README.md

# QUICK_REFERENCE.md agent count
grep -o "Agents ([0-9]* Total)" QUICK_REFERENCE.md

# Counts should match
```

**Command counts must match:**
```bash
# README.md command count
grep -o "Commands ([0-9]* Total)" README.md

# QUICK_REFERENCE.md command count
grep -o "Commands ([0-9]* Total)" QUICK_REFERENCE.md

# Counts should match
```

**No TODOs or FIXMEs in docs:**
```bash
grep -r "TODO\|FIXME" docs/
# Expected: (empty)
```

**Block completion if:**
- ❌ Agent counts don't match across files
- ❌ Command counts don't match
- ❌ TODOs/FIXMEs found in documentation

---

#### 4. Verification Evidence

**For EACH claim I made, provide:**
- The verification command
- The verification output
- Interpretation (pass/fail)

**Example:**

Claim: "Created verification script"

Evidence:
```bash
$ ls scripts/verify-file-organization.sh
scripts/verify-file-organization.sh ✅

$ ./scripts/verify-file-organization.sh
✅ File organization verified successfully ✅
```

**Block completion if:**
- ❌ Any claim lacks verification command
- ❌ Any claim lacks verification output
- ❌ Any verification shows failure

---

#### 5. File Type Classification

**For EVERY file I created/moved:**

```
File: STAGES-1-6-COMPLETE.md
Type: Log (session completion summary)
Should be: Deleted or gitignored (NOT in docs/)
Action: Delete ✅
```

**Questions to answer:**
- Is this file a log, temporary, or permanent documentation?
- Where should it live?
- Does it violate any constraint?

**Block completion if:**
- ❌ Can't classify file type
- ❌ File in wrong location
- ❌ Log file committed to git

---

#### 6. TodoWrite Completion

**Review TodoWrite items:**
- All tasks marked complete?
- All verification commands run?
- All constraints verified?

**Block completion if:**
- ❌ TodoWrite items incomplete
- ❌ Verification commands not run
- ❌ Constraints not checked

---

## Complete Checklist Template

**Run this BEFORE claiming complete:**

```markdown
## Pre-Completion Verification

### 1. File Organization
- [ ] Run: ./scripts/verify-file-organization.sh
- [ ] Output: ✅ or provide error details
- [ ] If errors: Fix before completing

### 2. Constraint Compliance
- [ ] Re-read user's message
- [ ] List constraints: [exact user words]
- [ ] For each constraint, verify:
  - Constraint: [quote]
  - Verification command: [command]
  - Output: [output]
  - Status: ✅ or ❌

### 3. Documentation Consistency
- [ ] Agent counts match: [number from README] = [number from QUICK_REFERENCE]
- [ ] Command counts match: [number from README] = [number from QUICK_REFERENCE]
- [ ] No TODOs: grep -r "TODO" docs/ (empty output)

### 4. Claims Evidence
- [ ] Claim 1: [claim]
  - Verification: [command + output]
- [ ] Claim 2: [claim]
  - Verification: [command + output]

### 5. File Classification
- [ ] File 1: [name]
  - Type: [log | temporary | permanent]
  - Location: [where it should be]
  - Status: ✅ correct location or ❌ moved/deleted

### 6. TodoWrite Complete
- [ ] All tasks marked complete
- [ ] All verification commands run
- [ ] All constraints verified

## Completion Status
- [ ] ALL checklist items verified ✅
- [ ] Ready to claim complete
```

---

## Examples

### Example 1: Simple Update (README)

**Task:** Update README.md

**Pre-Completion Checklist:**

```markdown
### 1. File Organization
- [x] Run: ./scripts/verify-file-organization.sh
- [x] Output: ✅ File organization verified successfully
- [x] No errors ✅

### 2. Constraint Compliance
- [x] User constraints: (none specified)
- [x] Status: N/A ✅

### 3. Documentation Consistency
- [x] Agent counts: 48 (README) = 48 (QUICK_REFERENCE) ✅
- [x] Command counts: 17 (README) = 17 (QUICK_REFERENCE) ✅
- [x] No TODOs: (empty output) ✅

### 4. Claims Evidence
- [x] Claim: "Updated agent count to 48"
  - Verification: grep "48 Total" README.md
  - Output: "## 🤖 Agents (48 Total)"
  - Status: ✅

### 5. File Classification
- [x] No new files created ✅

### 6. TodoWrite Complete
- [x] All tasks complete ✅

## Completion Status: ✅ VERIFIED, READY TO CLAIM COMPLETE
```

### Example 2: File Creation (with constraint violation caught)

**Task:** Create Stage 6 summary

**Pre-Completion Checklist:**

```markdown
### 1. File Organization
- [x] Run: ./scripts/verify-file-organization.sh
- [x] Output: ❌ Found completion logs in docs/: docs/STAGES-1-6-COMPLETE.md
- [ ] Fix: DELETE STAGES-1-6-COMPLETE.md (it's a log, not permanent documentation)

### 2. Constraint Compliance
- [x] User said: "no logs in /docs folder"
- [x] Verification: ls docs/ | grep -E 'COMPLETE|LOG'
- [x] Output: STAGES-1-6-COMPLETE.md ❌
- [ ] FIX REQUIRED: Delete this file

### Status: ❌ BLOCKED - Cannot claim complete until log file deleted
```

**Action:** Delete file, re-run checklist, THEN claim complete.

---

## Enforcement

**This skill BLOCKS completion claim if checklist incomplete.**

**If you find yourself claiming "done" without running checklist:**
1. STOP immediately
2. Run complete checklist
3. Fix any failures
4. THEN claim complete

---

## Integration

**Works with:**
- `superpowers:todowrite-first` - Uses constraints from TodoWrite
- `verify-file-organization.sh` - Programmatic file verification
- `superpowers:verification-before-completion` - Similar philosophy (evidence required)

**Completion-checklist is the final gate before user sees work.**

---

## Success Criteria

**Completion-checklist is working if:**
- ✅ Never claim complete without running checklist
- ✅ User never finds errors after I claim complete
- ✅ User never asks "did you check X?" (checklist caught it)
- ✅ Verification evidence provided with completion claim

**Completion-checklist is failing if:**
- ❌ Claim complete without checklist
- ❌ User finds errors I missed
- ❌ User has to remind me to verify
- ❌ No evidence provided with completion

---

## Why This Works

**Root cause:** I claim "done" without verifying, forcing user to become my quality-validator.

**Solution:** Checklist blocks completion until verification complete.

**Forcing function:** Can't claim done without consciously skipping checklist.

**Philosophy:** "Done" means verified, not just implemented. If I can't prove it works, it's not done.

---

**Last Updated:** 2025-10-25
**Related Skills:** superpowers:todowrite-first, superpowers:verification-before-completion
**Tested:** Not yet (just created)
