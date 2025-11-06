---
name: todowrite-first
description: MANDATORY TodoWrite before ANY work - extracts user constraints, creates verification checklist, blocks work without it
---

# TodoWrite-First: Constraint Extraction Protocol

**Trigger:** BEFORE starting ANY task (even simple ones)

**Purpose:** Force constraint awareness and verification planning BEFORE work begins

**Why this exists:** To prevent the pattern where I start work → forget constraints → violate them → user catches it.

---

## MANDATORY Pre-Work Protocol

**STOP. Do NOT begin work until TodoWrite is created.**

### Step 1: Extract User Constraints

Re-read the user's message. For EACH constraint or requirement:

```
User said: "i should NOT see any logs in the /docs folder"
             ↓
TodoWrite item: [ ] CONSTRAINT: No logs in /docs folder (user instruction line 1)
```

**Extract EVERY:**
- Explicit constraint ("must", "should not", "only", "never")
- File organization rules ("no X in Y folder")
- Quality requirements ("must verify", "provide evidence")
- Completion criteria ("done when X")

### Step 2: Decompose Tasks

Break user request into atomic tasks:

```
User request: "Create verification script and test it"
             ↓
[ ] Task: Create verification script
[ ] Task: Make script executable
[ ] Task: Run script to test
[ ] Task: Provide output as evidence
```

### Step 3: Add Verification Commands

For EACH task, specify HOW you'll verify it:

```
[ ] Task: Create verification script
    Verify: ls scripts/verify-file-organization.sh

[ ] Task: Make script executable
    Verify: ls -la scripts/verify-file-organization.sh | grep "x"

[ ] Task: Run script to test
    Verify: ./scripts/verify-file-organization.sh (provide output)
```

### Step 4: File Operation Checklist

For ANY file creation/move/delete, add:

```
[ ] File operation: Create FILENAME.md
[ ] Check: Is this a log or permanent documentation?
    Answer: [log | temporary | permanent_documentation]
[ ] Check: Where should this file live?
    If log: Delete or gitignore
    If temporary: Delete after use
    If permanent: docs/ folder with proper naming
[ ] Check: Does this violate any user constraint?
    Review constraints from Step 1
```

---

## TodoWrite Template

**Use this template for EVERY task:**

```
[{"content": "CONSTRAINT: [exact user words] (line X)", "status": "pending", "activeForm": "Tracking constraint"},
 {"content": "CONSTRAINT: [exact user words] (line Y)", "status": "pending", "activeForm": "Tracking constraint"},
 {"content": "Task: [atomic task]", "status": "pending", "activeForm": "Doing task"},
 {"content": "Verify: [verification command]", "status": "pending", "activeForm": "Verifying task"},
 {"content": "File check: Is [filename] a log or documentation?", "status": "pending", "activeForm": "Checking file type"},
 {"content": "Final: Run verify-file-organization.sh", "status": "pending", "activeForm": "Final verification"}]
```

---

## Examples

### Example 1: Simple File Creation

**User:** "Create a summary document for Stage 6"

**TodoWrite (BEFORE starting work):**
```json
[
  {"content": "Task: Create Stage 6 summary document", "status": "pending", "activeForm": "Creating summary"},
  {"content": "Check: Is this a log or permanent documentation?", "status": "pending", "activeForm": "Checking file type"},
  {"content": "If log: Delete after review", "status": "pending", "activeForm": "Handling log"},
  {"content": "If permanent: Place in docs/ with proper name", "status": "pending", "activeForm": "Handling documentation"},
  {"content": "Verify: Run verify-file-organization.sh", "status": "pending", "activeForm": "Running verification"}
]
```

**Process:**
1. Create TodoWrite ✅
2. Create document
3. Answer: "Is this a log?" → YES (session summary)
4. Decision: Delete after review (don't commit)
5. Mark todos complete

### Example 2: User Gives Explicit Constraints

**User:** "Update README. i should NOT see any additional documentation in the main folder, and i should NOT see any logs in the /docs folder"

**TodoWrite (BEFORE starting work):**
```json
[
  {"content": "CONSTRAINT: No additional documentation in main folder (user line 1)", "status": "pending", "activeForm": "Tracking constraint"},
  {"content": "CONSTRAINT: No logs in /docs folder (user line 1)", "status": "pending", "activeForm": "Tracking constraint"},
  {"content": "Task: Update README.md", "status": "pending", "activeForm": "Updating README"},
  {"content": "Verify: ls *.md should only show README, QUICK_REFERENCE, CHANGELOG", "status": "pending", "activeForm": "Verifying main folder"},
  {"content": "Verify: ls docs/ should not show logs (*-COMPLETE.md, *.log, *.txt)", "status": "pending", "activeForm": "Verifying docs folder"},
  {"content": "Final: Run verify-file-organization.sh", "status": "pending", "activeForm": "Final verification"}
]
```

**Process:**
1. Create TodoWrite with EXACT constraint quotes ✅
2. Update README
3. Before claiming done, check constraints:
   - ls *.md → Only README, QUICK_REFERENCE, CHANGELOG? ✅
   - ls docs/ → No logs? ✅
4. Run verify-file-organization.sh ✅
5. Mark todos complete

---

## Enforcement

**This skill BLOCKS work if TodoWrite not created.**

**If you find yourself starting work without TodoWrite:**
1. STOP immediately
2. Create TodoWrite
3. THEN continue work

**Red flags that you skipped TodoWrite:**
- You don't remember user's exact constraints
- You're making file decisions without checking constraint list
- You can't specify verification commands for your claims

---

## Integration with Other Skills

**Works with:**
- `superpowers:completion-checklist` - Uses TodoWrite constraints for final verification
- `superpowers:verification-before-completion` - Uses TodoWrite verification commands
- `file-organization-protocol` - Uses TodoWrite file type classification

**TodoWrite is the foundation. Other skills build on it.**

---

## Success Criteria

**TodoWrite-First is working if:**
- ✅ Every session starts with TodoWrite creation
- ✅ User constraints are quoted exactly in TodoWrite
- ✅ Verification commands are specified upfront
- ✅ File type questions are answered before file operations
- ✅ User never has to ask "did you check X?" (constraints are explicit)

**TodoWrite-First is failing if:**
- ❌ Work starts without TodoWrite
- ❌ Constraints are vague or missing
- ❌ Verification happens reactively (after user asks)
- ❌ User has to remind me about constraints

---

## Why This Works

**Root cause:** I forget constraints because I rely on memory, not reference.

**Solution:** TodoWrite makes constraints VISIBLE and EXPLICIT.

**Forcing function:** Can't skip TodoWrite without consciously violating the protocol.

**Integration:** Works with existing quality systems (verification-agent, quality-validator).

**Philosophy:** If I can't remember user's constraints, I shouldn't start work. TodoWrite ensures I can always reference them.

---

**Last Updated:** 2025-10-25
**Related Skills:** superpowers:completion-checklist, superpowers:verification-before-completion
**Tested:** Not yet (just created)
