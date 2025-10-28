# Work Order Acknowledgment Protocol (Stage 4)

**Purpose:** Confirm orchestrator's interpretation with user BEFORE dispatching specialists

**Version:** 1.0.0 (Stage 4 - Evidence-First + Work Order Acknowledgment)

---

## Why This Exists

**Problem:** Orchestrator can misinterpret user requests, leading to:
- Wrong project location (OBDN vs PeptideFox)
- Reversed subject/object in instructions
- Missing context or requirements
- Specialists implementing the wrong thing

**Solution:** Show interpretation, get confirmation, THEN dispatch.

---

## Protocol

### Step 1: Generate Work Order

After Evidence-First Dispatch completes successfully:

```markdown
## 🎯 Work Order for Review

**Request Interpretation:**
- Primary intent: {intent_type from intent-taxonomy.json}
- Action: {what user wants done}
- Target: {validated_target from Evidence-First}
- Domain: {detected_domain: frontend/ios/backend/design}
- Project location: {evidence_based_path}
- Quality level: {detected from keywords: premium/production/prototype}

**Planned Specialist Team:**
- {specialist_1} - {role_description}
- {specialist_2} - {role_description}
- {specialist_3} - {role_description}
{Add design-reviewer if quality indicators detected}
{Add accessibility-specialist if production UI}

**Evidence Requirements:**
After implementation, specialists must provide:
- {evidence_type_1 from intent-taxonomy.json}
- {evidence_type_2}
- {evidence_type_3}

**Verification Plan:**
- Response Awareness tags: ✅ Yes
- verification-agent: ✅ Yes
- quality-validator: ✅ Yes
- design-reviewer: {✅ Yes / ⚠️ No based on intent}
- Two-Phase Commit: ✅ CLAIMED → VERIFIED → COMPLETED

---

**Is this interpretation correct?**

Please respond:
- **"yes"** - Proceed with this plan
- **"no"** - I'll ask what needs correction
- **"clarify X"** - Specify what needs clarification
```

### Step 2: User Confirmation Validation

**CRITICAL: Validate response before proceeding**

```javascript
function validateWorkOrderResponse(response) {
  // Normalize response
  const normalized = response.trim().toLowerCase();

  // Check 1: Non-empty
  if (!response || normalized === '' || normalized === '.') {
    return {
      valid: false,
      reason: "EMPTY_RESPONSE",
      action: "RETRY",
      retry_message: "Previous response was empty. Please respond with 'yes', 'no', or 'clarify [what needs clarification]'"
    };
  }

  // Check 2: Valid response type
  if (normalized === 'yes' || normalized === 'y') {
    return {
      valid: true,
      action: "PROCEED_TO_DISPATCH"
    };
  }

  if (normalized === 'no' || normalized === 'n') {
    return {
      valid: true,
      action: "ASK_WHAT_INCORRECT",
      follow_up: "What part of this interpretation is incorrect?"
    };
  }

  if (normalized.startsWith('clarify')) {
    return {
      valid: true,
      action: "CLARIFY",
      clarification_needed: response.substring('clarify'.length).trim()
    };
  }

  // Check 3: Unrecognized response
  return {
    valid: false,
    reason: "UNRECOGNIZED_RESPONSE",
    action: "RETRY",
    retry_message: `Response "${response}" not recognized. Please respond with:\n- "yes" to proceed\n- "no" if interpretation is wrong\n- "clarify X" to ask about specific part`
  };
}
```

### Step 3: Response Handling

#### If response === "yes" (Proceed)

```markdown
Tag: #WORK_ORDER_ACKNOWLEDGED
Status: PROCEED_TO_DISPATCH

Dispatching specialist team:
- {specialist_1}
- {specialist_2}
- {specialist_3}

Work order transmitted to specialists:
- Full interpretation provided
- Evidence already gathered from Evidence-First
- Success criteria defined
- Verification requirements established

Specialists will NOT receive raw user request.
Specialists WILL receive validated work order.
This prevents specialists from making different assumptions.
```

#### If response === "no" (Incorrect)

```markdown
Tag: #WORK_ORDER_REJECTED
Status: BLOCKED_FOR_CORRECTION

Follow-up question:
"What part of this interpretation is incorrect?
- The intent (what you want done)?
- The target (which project)?
- The specialist team?
- Something else?"

After receiving clarification:
1. Return to Evidence-First if target is wrong
2. Regenerate work order with corrections
3. Re-present for confirmation
4. MAX_RETRIES: 3 (prevent infinite loop)
```

#### If response === "clarify X" (Needs explanation)

```markdown
Tag: #WORK_ORDER_CLARIFICATION_REQUESTED
Status: PAUSED_FOR_CLARIFICATION

Provide detailed explanation of requested part:
- If clarify intent: Explain why this intent was selected
- If clarify specialists: Explain role of each specialist
- If clarify evidence: Explain what each evidence type proves
- If clarify verification: Explain verification workflow

Then re-ask:
"With that explanation, is the interpretation correct? [yes/no/clarify]"
```

#### If response is empty/invalid (Validation failed)

```markdown
Tag: #WORK_ORDER_RESPONSE_INVALID: {reason}
Status: BLOCKED_FOR_VALID_RESPONSE
Retry count: {increment}

IF retry_count < 3:
  Retry with clearer prompt:
  "Previous response was {reason}. Please respond clearly:
  - Type 'yes' if interpretation is correct
  - Type 'no' if interpretation is wrong
  - Type 'clarify X' to ask about specific part"

IF retry_count >= 3:
  HARD_BLOCK
  FAIL_TASK("User confirmation failed after 3 attempts")

  Report to user:
  "Unable to get valid confirmation after 3 attempts.
  Please restart with clearer instruction or use /clarify command."
```

---

## Integration with Specialist Dispatch

### What Specialists Receive

**NOT the raw user request:** "Build a simple premium card component for OBDN"

**YES the validated work order:**

```json
{
  "work_order_id": "wo-20251025-001",
  "validated_at": "2025-10-25T...",
  "acknowledged_by_user": true,

  "interpretation": {
    "intent": "build_component",
    "action": "Create premium card component",
    "target_project": "OBDN",
    "project_path": "./explore/obdn-design-automation",
    "project_type": "Documentation/Design",
    "domain": "design",
    "quality_level": "premium"
  },

  "evidence_gathered": {
    "target_found": true,
    "ambiguity_resolved": true,
    "user_confirmed": true,
    "evidence_first_output": "#STAGE_4_EVIDENCE_GATHERED: ./explore/obdn-design-automation"
  },

  "specialist_assignments": [
    {"specialist": "visual-designer", "role": "Design premium card component"},
    {"specialist": "design-reviewer", "role": "Verify premium quality standards"}
  ],

  "success_criteria": {
    "required_evidence": [
      "component_file",
      "screenshot",
      "design_review_approval"
    ],
    "verification_gates": [
      "Response Awareness tags",
      "verification-agent validation",
      "design-reviewer approval",
      "quality-validator final gate"
    ]
  }
}
```

### Benefits

1. **Specialists can't misinterpret** - They receive structured work order, not ambiguous text
2. **No duplicate evidence gathering** - Evidence-First results included
3. **Clear success criteria** - Specialists know exactly what evidence to provide
4. **Audit trail** - Work order documents interpretation and user confirmation

---

## Failure Prevention Matrix

| Failure Mode | How Work Order Prevents It |
|--------------|---------------------------|
| **Reversed instruction** | User sees interpretation before implementation, confirms/corrects |
| **Wrong project** | Evidence-First validated target, shown in work order, user confirmed |
| **Missing requirements** | Success criteria explicitly listed, user can add missing items |
| **Wrong specialist team** | Specialist list shown, user can request additions |

---

## Example: Full Workflow

**User request:** "Build a simple premium card component for OBDN"

### Phase 1: Evidence-First (auto)
```
Target: OBDN
Found: ./explore/obdn-design-automation (single unambiguous)
Project type: Documentation/Design
```

### Phase 2: Intent Extraction (auto)
```
Intent: build_component (keyword "Build")
Domain: design (keyword "premium")
Quality: premium (keyword "premium")
```

### Phase 3: Work Order Generation (auto)
```markdown
## 🎯 Work Order for Review

**Request Interpretation:**
- Primary intent: build_component
- Action: Create premium card component
- Target: OBDN
- Domain: design
- Project location: ./explore/obdn-design-automation
- Quality level: premium

**Planned Specialist Team:**
- visual-designer - Design premium card component with hierarchy, typography, spacing
- design-reviewer - Verify premium quality standards (7-phase review)
- ui-engineer - Implement component with accessibility (if code required)

**Evidence Requirements:**
- component_file (design file or code)
- screenshot (visual proof)
- design_review_approval (design-reviewer sign-off)

**Verification Plan:**
- Response Awareness tags: ✅ Yes
- verification-agent: ✅ Yes
- quality-validator: ✅ Yes
- design-reviewer: ✅ Yes (premium quality)

---

**Is this interpretation correct?** [yes/no/clarify]
```

### Phase 4: User Confirmation

**User responds:** "yes"

**Validation:**
```javascript
validateWorkOrderResponse("yes")
// → { valid: true, action: "PROCEED_TO_DISPATCH" }
```

**Tag:** #WORK_ORDER_ACKNOWLEDGED

### Phase 5: Dispatch

Specialists receive validated work order (shown above) with:
- Clear interpretation
- Evidence already gathered
- Success criteria defined
- User confirmation documented

**Result:** Specialists implement exactly what user intended, no assumptions, no misinterpretations.

---

## Metrics

**Success Metrics:**
- **Interpretation accuracy: 100%** (user confirmed before implementation)
- **Reversed instruction rate: 0%** (user sees interpretation first)
- **Wrong project rate: 0%** (Evidence-First validated + user confirmed)
- **User satisfaction: High** (transparency + confirmation)

**Performance Metrics:**
- **Time cost: +30-60 seconds** (work order generation + user confirmation)
- **Token cost: +200-400 tokens** (work order display)
- **User friction: Low** (yes/no/clarify is fast)

**Net benefit: Massive** (prevents 30+ minute rework from wrong implementation)

---

## Related Documentation

- `.orchestration/stage-4/evidence-first.sh` - Evidence gathering before work order
- `.orchestration/intent-taxonomy.json` - Intent classification rules
- `docs/RESPONSE_AWARENESS_TAGS.md` - Tags used in work order (#WORK_ORDER_ACKNOWLEDGED, etc.)
- `.orchestration/two-phase-commit/` - Verification after work order

---

**Last Updated:** 2025-10-25 (Stage 4 Implementation)
**Status:** Active - Required for all /orca dispatches
