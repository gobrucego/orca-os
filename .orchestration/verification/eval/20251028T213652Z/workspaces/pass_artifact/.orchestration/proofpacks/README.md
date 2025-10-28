# Unified Proof Artifacts (Proofpacks)

**Purpose:** Tamper-proof evidence collection with cryptographic hashing

**Version:** 1.0.0 (Stage 1 Week 2)

---

## Overview

A **proofpack** is a cryptographically hashed JSON artifact containing ALL evidence for a task's completion:
- Screenshots (base64-encoded)
- Test outputs
- Build logs
- Verification report
- Timestamps
- Agent metadata

The cryptographic hash (SHA-256) ensures evidence integrity - if any field is modified after generation, the hash will no longer match, proving tampering.

---

## Why Proofpacks?

### Problem: Scattered Evidence

**Before proofpacks:**
```
.orchestration/evidence/
├── ios-simulator.png
├── test-output.log
├── build-log.txt
├── design-review-report.md
└── verification-report.md
```

- Evidence spread across multiple files
- No guarantee files haven't been modified
- Hard to package for auditing
- Difficult to verify completeness

### Solution: Single Tamper-Proof Artifact

**After proofpacks:**
```json
{
  "hash": "sha256:a1b2c3d4...",
  "timestamp": "2025-10-24T21:00:00Z",
  "task_id": "login-screen-implementation",
  "task_type": "ios-ui",
  "evidence": {
    "screenshots": {"ios_simulator": "data:image/png;base64,..."},
    "test_outputs": {"xcode_build": "Build succeeded\n..."},
    "verification_report": "# Verification Report\n...",
    ...
  }
}
```

- Single file contains everything
- Cryptographic hash proves integrity
- Self-contained for auditing
- Easy to verify completeness

---

## Proofpack Structure

### Schema v1.0.0

```json
{
  "schema_version": "1.0.0",
  "hash": "sha256:[64-char hex string]",
  "timestamp": "ISO 8601 timestamp",
  "task_id": "unique task identifier",
  "task_type": "ios-ui | frontend-ui | backend-api",
  "agent": "specialist agent that created this task",
  "metadata": {
    "session_id": "session identifier",
    "user_requirement": "quote from user-request.md",
    "completion_criteria_version": "1.0.0"
  },
  "evidence": {
    "screenshots": {
      "ios_simulator": "data:image/png;base64,[base64-encoded PNG]",
      "browser_screenshot": "data:image/png;base64,[base64-encoded PNG]"
    },
    "test_outputs": {
      "unit_tests": "text output from npm test or xcodebuild test",
      "integration_tests": "text output",
      "accessibility_tests": "text output"
    },
    "build_logs": {
      "build_command": "npm run build",
      "exit_code": 0,
      "stdout": "text output",
      "stderr": "text output (if any)"
    },
    "verification_report": "markdown text from verification-report.md",
    "design_review": "markdown text from design-review-report.md (if applicable)",
    "performance_benchmarks": {
      "p50_latency_ms": 45,
      "p95_latency_ms": 120,
      "throughput_rps": 250
    },
    "security_scan": {
      "tool": "npm audit",
      "critical_count": 0,
      "high_count": 0,
      "output": "text output"
    }
  },
  "deliverables_met": {
    "source_files": true,
    "screenshots": true,
    "build_success": true,
    "tests_passing": true,
    "accessibility_audit": true,
    "design_review": true
  },
  "verification_verdict": "PASSED | BLOCKED | CONDITIONAL",
  "quality_score": 95.5,
  "signature": {
    "signer": "verification-agent",
    "signed_at": "ISO 8601 timestamp",
    "algorithm": "sha256"
  }
}
```

---

## Hash Generation

### Algorithm: SHA-256

The hash is computed over the ENTIRE proofpack JSON (excluding the `hash` and `signature` fields themselves):

```javascript
// Pseudocode for hash generation
function generateProofpackHash(proofpack) {
  // 1. Create copy without hash/signature fields
  const hashableContent = {
    schema_version: proofpack.schema_version,
    timestamp: proofpack.timestamp,
    task_id: proofpack.task_id,
    task_type: proofpack.task_type,
    agent: proofpack.agent,
    metadata: proofpack.metadata,
    evidence: proofpack.evidence,
    deliverables_met: proofpack.deliverables_met,
    verification_verdict: proofpack.verification_verdict,
    quality_score: proofpack.quality_score
  };

  // 2. Serialize to canonical JSON (sorted keys)
  const canonicalJSON = JSON.stringify(hashableContent, Object.keys(hashableContent).sort());

  // 3. Compute SHA-256
  const hash = crypto.createHash('sha256').update(canonicalJSON).digest('hex');

  return `sha256:${hash}`;
}
```

### Verification

Anyone can verify the proofpack wasn't tampered with:

```bash
#!/bin/bash
# verify-proofpack.sh

PROOFPACK_FILE=$1

# Extract hash from proofpack
CLAIMED_HASH=$(jq -r '.hash' "$PROOFPACK_FILE")

# Remove hash and signature fields
jq 'del(.hash, .signature)' "$PROOFPACK_FILE" > /tmp/proofpack-hashable.json

# Compute hash
COMPUTED_HASH="sha256:$(shasum -a 256 /tmp/proofpack-hashable.json | awk '{print $1}')"

# Compare
if [ "$CLAIMED_HASH" == "$COMPUTED_HASH" ]; then
  echo "✅ Proofpack integrity verified"
  exit 0
else
  echo "❌ Proofpack tampered - hash mismatch"
  echo "Claimed:  $CLAIMED_HASH"
  echo "Computed: $COMPUTED_HASH"
  exit 1
fi
```

---

## Lifecycle

### 1. Task Implementation

```
specialist agent (swiftui-developer, react-18-specialist, etc.)
    ↓
Implements feature
Claims completion
Creates evidence files (.orchestration/evidence/)
```

### 2. Verification

```
verification-agent
    ↓
Loads completion criteria (.orchestration/completion-criteria/[task-type].json)
Runs verification commands (ls, grep, xcodebuild test, npm test)
Collects evidence (screenshots, test outputs, logs)
Creates verification-report.md
```

### 3. Proofpack Generation

```
verification-agent
    ↓
Collects ALL evidence into proofpack structure
Encodes screenshots as base64
Includes test outputs, build logs, reports
Computes SHA-256 hash
Writes .orchestration/proofpacks/[task-id]-[timestamp].json
```

### 4. Enforcement

```
workflow-orchestrator
    ↓
Checks proofpack.json exists
Verifies hash integrity
Reads verification_verdict from proofpack
If BLOCKED → HARD BLOCK (no quality-validator)
If PASSED → Proceed to quality-validator with proofpack as evidence
```

### 5. Quality Validation

```
quality-validator
    ↓
Receives proofpack.json as input
Verifies hash first (ensures no tampering)
Reads evidence from proofpack
Scores quality based on evidence
Generates final validation report
```

---

## File Naming Convention

```
.orchestration/proofpacks/[task-id]-[timestamp].json
```

**Examples:**
```
.orchestration/proofpacks/login-screen-20251024T210000Z.json
.orchestration/proofpacks/dashboard-ui-20251024T215500Z.json
.orchestration/proofpacks/api-auth-20251024T220000Z.json
```

**Rationale:**
- `task-id`: Human-readable task identifier
- `timestamp`: ISO 8601 format (UTC), ensures uniqueness
- `.json`: JSON format

---

## Storage

### Directory Structure

```
.orchestration/
└── proofpacks/
    ├── README.md (this file)
    ├── schema-v1.0.0.json (JSON schema for validation)
    ├── verify-proofpack.sh (hash verification script)
    └── [task-proofpacks...]
        ├── login-screen-20251024T210000Z.json
        ├── dashboard-ui-20251024T215500Z.json
        └── api-auth-20251024T220000Z.json
```

### Retention Policy

- **During session**: All proofpacks retained
- **After session**: User decides retention
- **Audit trail**: Proofpacks can be archived for compliance

### Size Considerations

Proofpacks can be large due to base64-encoded screenshots:
- Average screenshot: 500KB-2MB
- Base64 encoding: +33% size
- Average proofpack: 1-5MB

For large projects (50+ tasks), proofpacks directory may reach 50-250MB.

**Mitigation:**
- Compress screenshots before base64 encoding
- Link to external screenshot files (hybrid approach)
- Archive old proofpacks after session

---

## Integration with Quality System

### Current Integration (Stage 1 Week 2)

```
verification-agent
    ↓ (runs verifications)
    ↓ (collects evidence)
    ↓ (generates proofpack.json with hash)
    ↓ (writes to .orchestration/proofpacks/)
workflow-orchestrator
    ↓ (reads proofpack.json)
    ↓ (verifies hash integrity)
    ↓ (checks verification_verdict)
    ↓ (HARD BLOCK if BLOCKED)
quality-validator
    ↓ (receives proofpack.json)
    ↓ (verifies hash first)
    ↓ (reads evidence from proofpack)
    ↓ (scores quality)
```

### Future Integration (Stage 2+)

**Stage 2 Week 4: Behavioral Oracles**
- Oracle test results included in proofpack
- Playwright screenshots → evidence.screenshots.playwright_*
- XCUITest results → evidence.test_outputs.xcuitest
- curl results → evidence.test_outputs.api_health

**Stage 3 Week 5: Screenshot Diff**
- BEFORE screenshot → evidence.screenshots.before
- AFTER screenshot → evidence.screenshots.after
- Pixel diff → evidence.visual_diff.pixel_diff_count
- Diff image → evidence.screenshots.diff_image

**Stage 3 Week 6: Verification Replay**
- Verification script → evidence.verification_script
- Replayable for iterative fixes

---

## Examples

### Example 1: ios-ui Proofpack

```json
{
  "schema_version": "1.0.0",
  "hash": "sha256:a1b2c3d4e5f6...",
  "timestamp": "2025-10-24T21:00:00Z",
  "task_id": "login-screen-implementation",
  "task_type": "ios-ui",
  "agent": "swiftui-developer",
  "metadata": {
    "session_id": "session-20251024-001",
    "user_requirement": "Build a login screen with email and password fields",
    "completion_criteria_version": "1.0.0"
  },
  "evidence": {
    "screenshots": {
      "ios_simulator": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUg..."
    },
    "test_outputs": {
      "xcode_build": "Build succeeded. Exit code: 0\n=== BUILD TARGET MyApp OF PROJECT MyApp WITH CONFIGURATION Debug ===\n...",
      "xctest": "Test Suite 'All tests' passed at 2025-10-24 21:00:00.000.\n\t Executed 8 tests, with 0 failures (0 unexpected)..."
    },
    "build_logs": {
      "build_command": "xcodebuild build -scheme MyApp -destination 'platform=iOS Simulator,name=iPhone 15'",
      "exit_code": 0,
      "stdout": "...",
      "stderr": ""
    },
    "verification_report": "# Verification Report: login-screen-implementation\n\n## Deliverable Verification\n\n1. source_files: ✅ VERIFIED\n...",
    "design_review": "# Design Review Report\n\n## Phase 1: Typography & Hierarchy\n✅ PASSED..."
  },
  "deliverables_met": {
    "source_files": true,
    "ios_screenshot": true,
    "build_success": true,
    "ui_tests": true,
    "accessibility_audit": true,
    "visual_review": true
  },
  "verification_verdict": "PASSED",
  "quality_score": null,
  "signature": {
    "signer": "verification-agent",
    "signed_at": "2025-10-24T21:00:05Z",
    "algorithm": "sha256"
  }
}
```

### Example 2: frontend-ui Proofpack (with failure)

```json
{
  "schema_version": "1.0.0",
  "hash": "sha256:f1e2d3c4b5a6...",
  "timestamp": "2025-10-24T21:30:00Z",
  "task_id": "dashboard-ui-implementation",
  "task_type": "frontend-ui",
  "agent": "react-18-specialist",
  "metadata": {
    "session_id": "session-20251024-002",
    "user_requirement": "Create a dashboard showing user statistics",
    "completion_criteria_version": "1.0.0"
  },
  "evidence": {
    "screenshots": {},
    "test_outputs": {
      "npm_test": "FAIL src/Dashboard.test.tsx\n  ● Dashboard › renders statistics\n    Expected element to have text content: '1234' but received: '0'\n..."
    },
    "build_logs": {
      "build_command": "npm run build",
      "exit_code": 0,
      "stdout": "...",
      "stderr": ""
    },
    "verification_report": "# Verification Report: dashboard-ui-implementation\n\n## Summary\n- Total deliverables: 7\n- Verified: 2\n- Failed: 5\n- **Overall Verdict: BLOCKED**\n\n## Failed Verifications\n1. browser_screenshot - Screenshot missing\n2. component_tests - 3 tests failing\n..."
  },
  "deliverables_met": {
    "source_files": true,
    "browser_screenshot": false,
    "build_success": true,
    "component_tests": false,
    "accessibility_audit": false,
    "visual_review": false,
    "console_clean": false
  },
  "verification_verdict": "BLOCKED",
  "quality_score": null,
  "signature": {
    "signer": "verification-agent",
    "signed_at": "2025-10-24T21:30:05Z",
    "algorithm": "sha256"
  }
}
```

---

## Advantages

### 1. Tamper-Proof

- Cryptographic hash ensures integrity
- Any modification breaks the hash
- Verifiable by anyone with the proofpack

### 2. Self-Contained

- Single file contains ALL evidence
- No need to hunt for scattered files
- Easy to share, archive, audit

### 3. Verifiable

- verification_verdict is explicit
- deliverables_met is binary (true/false)
- Evidence is included, not just claimed

### 4. Auditable

- Timestamp proves when evidence was created
- Agent attribution (who created this)
- Traceable to user requirement

### 5. Enforceable

- workflow-orchestrator can verify hash before trusting
- quality-validator must verify hash first
- Cannot proceed without valid proofpack

---

## Limitations

### 1. Size

- Base64-encoded screenshots inflate size
- Large proofpacks (5-10MB) possible
- Mitigation: Compression, external links

### 2. Not Executable

- Proofpack is static evidence, not live test
- Cannot re-run tests from proofpack
- Mitigation: Behavioral Oracles (Stage 2 Week 4) store executable scripts

### 3. Hash Algorithm Fixed

- SHA-256 is current standard
- Future quantum computers may break SHA-256
- Mitigation: schema_version allows future algorithm changes

---

## Future Enhancements

### Stage 2 Week 4: Behavioral Oracles

- Include executable test scripts in proofpack
- Oracle results embedded
- Replayable via verification_script field

### Stage 3 Week 5: Screenshot Diff

- BEFORE/AFTER screenshots both in proofpack
- Pixel diff calculation included
- Visual regression evidence

### Stage 3 Week 6: Verification Replay

- Store verification commands in proofpack
- Enable re-verification without re-implementation

### Stage 5 Week 10: Digital Signatures (Optional)

- GPG/PGP signatures for non-repudiation
- Multi-party verification (developer + QA + reviewer)
- Cryptographic proof of approval chain

---

## Related Documentation

- **.orchestration/completion-criteria/README.md** - What deliverables are required
- **verification-agent.md** - How verification runs and generates proofpacks
- **workflow-orchestrator.md** - Enforcement of proofpack integrity
- **quality-validator.md** - How proofpacks are used for quality scoring

---

**Last Updated:** 2025-10-24 (Stage 1 Week 2)
**Next Update:** Stage 2 Week 4 (Behavioral Oracles integration)
