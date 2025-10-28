# Digital Signatures - Cryptographic Proof of Approval Chain

**Purpose:** GPG/PGP signatures for non-repudiation and multi-party verification

**Version:** 1.0.0 (Stage 5 Week 10)

---

## Overview

Digital Signatures provide **cryptographic proof of approval chain** for proofpacks, enabling:
- Non-repudiation (signer cannot deny signing)
- Multi-party verification (developer + QA + reviewer)
- Audit trails with cryptographic integrity
- Compliance with security standards

**Philosophical Position:** Trust but verify. Cryptographic signatures provide mathematical proof of approval, not just claims.

---

## Why Digital Signatures?

### Problem: Tamper Detection is Not Attribution

**Proofpacks (Stage 1) provide:**
- Cryptographic hash (SHA-256)
- Tamper detection (hash mismatch if modified)
- Integrity verification

**But proofpacks DON'T provide:**
- ❌ Who approved this proofpack?
- ❌ When was it approved?
- ❌ Can the approver deny they approved it?

**Example scenario:**

```
Proofpack: login-screen-20251024.json
Hash: sha256:a1b2c3d4...
Verdict: PASSED
Quality Score: 95.5

Questions:
- Who reviewed this? (Unknown)
- Did quality-validator actually approve it? (Unverifiable)
- Could someone forge "quality-validator" approval? (Yes)
```

**Solution: Digital Signatures**

```
Proofpack: login-screen-20251024.json
Hash: sha256:a1b2c3d4...
Verdict: PASSED
Quality Score: 95.5

Signatures:
  1. verification-agent (signed: 2025-10-25T14:30:00Z)
     Signature: -----BEGIN PGP SIGNATURE-----
                iQEzBAABCAAdFiEE...
                -----END PGP SIGNATURE-----

  2. quality-validator (signed: 2025-10-25T14:35:00Z)
     Signature: -----BEGIN PGP SIGNATURE-----
                iQEzBAABCAAdFiEE...
                -----END PGP SIGNATURE-----

Verification:
  ✅ verification-agent signature valid
  ✅ quality-validator signature valid
  ✅ Approval chain complete
```

---

## Signature Types

### 1. Single-Signature (Basic)

**Use case:** verification-agent signs proofpack after verification

**Who signs:** verification-agent
**What's signed:** Proofpack hash (sha256:...)
**Purpose:** Proves verification-agent created this proofpack

**Example:**
```json
{
  "hash": "sha256:a1b2c3d4...",
  "signature": {
    "signer": "verification-agent",
    "signed_at": "2025-10-25T14:30:00Z",
    "algorithm": "RSA-2048",
    "pgp_signature": "-----BEGIN PGP SIGNATURE-----\niQEzBAABCAAdFiEE...\n-----END PGP SIGNATURE-----"
  }
}
```

### 2. Multi-Signature Chain (Advanced)

**Use case:** Multiple parties approve proofpack (developer → QA → reviewer)

**Who signs:** Multiple agents in sequence
**What's signed:** Previous signature hash (chain of custody)
**Purpose:** Proves approval chain is complete and unbroken

**Example:**
```json
{
  "hash": "sha256:a1b2c3d4...",
  "signatures": [
    {
      "signer": "verification-agent",
      "role": "verifier",
      "signed_at": "2025-10-25T14:30:00Z",
      "signs": "proofpack_hash",
      "signature_hash": "sha256:sig1hash...",
      "pgp_signature": "-----BEGIN PGP SIGNATURE-----\n...\n-----END PGP SIGNATURE-----"
    },
    {
      "signer": "quality-validator",
      "role": "quality_gate",
      "signed_at": "2025-10-25T14:35:00Z",
      "signs": "previous_signature_hash",
      "previous_signature_hash": "sha256:sig1hash...",
      "signature_hash": "sha256:sig2hash...",
      "pgp_signature": "-----BEGIN PGP SIGNATURE-----\n...\n-----END PGP SIGNATURE-----"
    },
    {
      "signer": "human-reviewer",
      "role": "final_approval",
      "signed_at": "2025-10-25T15:00:00Z",
      "signs": "previous_signature_hash",
      "previous_signature_hash": "sha256:sig2hash...",
      "signature_hash": "sha256:sig3hash...",
      "pgp_signature": "-----BEGIN PGP SIGNATURE-----\n...\n-----END PGP SIGNATURE-----"
    }
  ],
  "approval_chain_complete": true,
  "required_signatures": 3,
  "received_signatures": 3
}
```

---

## Signature Algorithm: GPG/PGP

### Why GPG/PGP?

**Advantages:**
- Industry standard (widely trusted)
- Asymmetric encryption (public/private key pairs)
- Non-repudiation (only private key holder can sign)
- Verification without private key (anyone with public key can verify)
- Key management infrastructure (keyservers, revocation)

**Algorithm:** RSA-2048 or Ed25519 (modern, faster)

**Signature process:**
1. Hash proofpack content (SHA-256)
2. Sign hash with private key (GPG)
3. Embed signature in proofpack JSON
4. Anyone can verify with public key

---

## Key Management

### Key Generation

**Generate key pair for each agent:**

```bash
# Generate key for verification-agent
gpg --batch --gen-key <<EOF
%no-protection
Key-Type: RSA
Key-Length: 2048
Name-Real: verification-agent
Name-Email: verification-agent@claude-vibe-code.local
Expire-Date: 0
EOF

# Export public key
gpg --armor --export verification-agent > .orchestration/digital-signatures/keys/verification-agent.pub.asc

# Export private key (KEEP SECURE)
gpg --armor --export-secret-keys verification-agent > .orchestration/digital-signatures/keys/verification-agent.priv.asc
```

### Key Storage

```
.orchestration/digital-signatures/keys/
├── verification-agent.pub.asc (PUBLIC - tracked in git)
├── verification-agent.priv.asc (PRIVATE - gitignored, encrypted)
├── quality-validator.pub.asc (PUBLIC)
├── quality-validator.priv.asc (PRIVATE - gitignored)
└── README.md (key management docs)
```

**CRITICAL:**
- ✅ Public keys: Tracked in git (anyone can verify)
- ❌ Private keys: NEVER commit to git (use environment variables or keyring)

### Key Distribution

**Public keys:**
- Committed to `.orchestration/digital-signatures/keys/*.pub.asc`
- Anyone can verify signatures

**Private keys:**
- Stored in environment variables: `GPG_PRIVATE_KEY_VERIFICATION_AGENT`
- Or: System keyring (macOS Keychain, Linux gpg-agent)
- Never in git, never in proofpacks

---

## Signing Process

### Script: `sign-proofpack.sh`

**Usage:**
```bash
./orchestration/digital-signatures/sign-proofpack.sh \
  --proofpack .orchestration/proofpacks/login-screen-20251024.json \
  --signer verification-agent \
  --role verifier
```

**Process:**

1. **Load proofpack:**
   ```bash
   PROOFPACK_FILE=$1
   PROOFPACK_HASH=$(jq -r '.hash' "$PROOFPACK_FILE")
   ```

2. **Sign hash with GPG:**
   ```bash
   echo "$PROOFPACK_HASH" | gpg --armor --sign --local-user verification-agent > /tmp/signature.asc
   ```

3. **Extract signature:**
   ```bash
   SIGNATURE=$(cat /tmp/signature.asc | sed -n '/BEGIN PGP SIGNATURE/,/END PGP SIGNATURE/p')
   ```

4. **Embed signature in proofpack:**
   ```bash
   jq --arg sig "$SIGNATURE" --arg signer "verification-agent" --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
     '.signature = {
        signer: $signer,
        signed_at: $timestamp,
        algorithm: "RSA-2048",
        pgp_signature: $sig
      }' "$PROOFPACK_FILE" > "${PROOFPACK_FILE}.tmp"

   mv "${PROOFPACK_FILE}.tmp" "$PROOFPACK_FILE"
   ```

5. **Output:**
   ```
   ✅ Proofpack signed

   Signer: verification-agent
   Signed: 2025-10-25T14:30:00Z
   Algorithm: RSA-2048
   Signature hash: sha256:sig1hash...
   ```

---

## Verification Process

### Script: `verify-signature.sh`

**Usage:**
```bash
./orchestration/digital-signatures/verify-signature.sh \
  --proofpack .orchestration/proofpacks/login-screen-20251024.json
```

**Process:**

1. **Load proofpack:**
   ```bash
   PROOFPACK_FILE=$1
   PROOFPACK_HASH=$(jq -r '.hash' "$PROOFPACK_FILE")
   SIGNATURE=$(jq -r '.signature.pgp_signature' "$PROOFPACK_FILE")
   SIGNER=$(jq -r '.signature.signer' "$PROOFPACK_FILE")
   ```

2. **Verify signature with GPG:**
   ```bash
   echo "$SIGNATURE" > /tmp/signature.asc
   echo "$PROOFPACK_HASH" | gpg --verify /tmp/signature.asc -
   ```

3. **Check verification result:**
   ```bash
   if [ $? -eq 0 ]; then
     echo "✅ Signature valid"
     echo "Signer: $SIGNER"
     echo "Signed at: $(jq -r '.signature.signed_at' "$PROOFPACK_FILE")"
   else
     echo "❌ Signature invalid or signer unknown"
     exit 1
   fi
   ```

4. **Verify signer identity:**
   ```bash
   # Check signer matches expected public key
   PUBLIC_KEY=".orchestration/digital-signatures/keys/${SIGNER}.pub.asc"
   gpg --import "$PUBLIC_KEY"
   ```

---

## Multi-Party Approval Chain

### Approval Roles

**Three-tier approval:**

1. **verification-agent** (Tier 1 - Verifier)
   - Runs verification commands
   - Collects evidence
   - Signs proofpack hash
   - Role: Proves verification was executed

2. **quality-validator** (Tier 2 - Quality Gate)
   - Reviews evidence from verification-agent
   - Scores quality
   - Signs previous signature hash
   - Role: Proves quality gate passed

3. **human-reviewer** (Tier 3 - Final Approval)
   - Reviews quality score
   - Approves for production deployment
   - Signs previous signature hash
   - Role: Proves human approved deployment

### Chain of Custody

**Signature chaining:**

```
Proofpack Hash (sha256:a1b2c3d4...)
    ↓ (signs)
verification-agent signature (sha256:sig1hash...)
    ↓ (signs)
quality-validator signature (sha256:sig2hash...)
    ↓ (signs)
human-reviewer signature (sha256:sig3hash...)
```

**Verification:**
```bash
# Verify chain from bottom to top
1. Verify human-reviewer signature signs quality-validator signature hash ✅
2. Verify quality-validator signature signs verification-agent signature hash ✅
3. Verify verification-agent signature signs proofpack hash ✅

Result: Complete chain of custody verified
```

---

## Integration with Quality System

### Modified workflow-orchestrator

**Before:**
```markdown
verification-agent generates proofpack
    ↓
quality-validator reads proofpack
    ↓
Deploy if PASSED
```

**After (with signatures):**
```markdown
verification-agent generates proofpack
    ↓
verification-agent SIGNS proofpack (Tier 1)
    ↓
quality-validator reads proofpack
    ↓
quality-validator verifies verification-agent signature ✅
    ↓
quality-validator scores quality
    ↓
quality-validator SIGNS proofpack (Tier 2)
    ↓
workflow-orchestrator verifies signature chain ✅
    ↓
(Optional) human-reviewer approves (Tier 3)
    ↓
Deploy if all signatures valid
```

---

## Signature Verification Enforcement

**workflow-orchestrator checks:**

```markdown
## Phase 7: Signature Verification (NEW - Stage 5)

BEFORE proceeding to deployment:

1. **Load proofpack:**
   ```bash
   PROOFPACK=".orchestration/proofpacks/${TASK_ID}.json"
   ```

2. **Check signature exists:**
   ```bash
   SIGNATURE_COUNT=$(jq '.signatures | length' "$PROOFPACK")

   if [ "$SIGNATURE_COUNT" -eq 0 ]; then
     echo "❌ HARD BLOCK: No signatures found"
     echo "Proofpack must be signed by verification-agent"
     exit 1
   fi
   ```

3. **Verify each signature:**
   ```bash
   for sig in $(jq -c '.signatures[]' "$PROOFPACK"); do
     SIGNER=$(echo "$sig" | jq -r '.signer')

     # Verify signature
     ./orchestration/digital-signatures/verify-signature.sh \
       --proofpack "$PROOFPACK" \
       --signer "$SIGNER"

     if [ $? -ne 0 ]; then
       echo "❌ HARD BLOCK: Signature verification failed for $SIGNER"
       exit 1
     fi
   done
   ```

4. **Verify approval chain complete:**
   ```bash
   REQUIRED_SIGS=$(jq -r '.required_signatures' "$PROOFPACK")
   RECEIVED_SIGS=$(jq -r '.received_signatures' "$PROOFPACK")

   if [ "$RECEIVED_SIGS" -lt "$REQUIRED_SIGS" ]; then
     echo "❌ HARD BLOCK: Incomplete approval chain"
     echo "Required: $REQUIRED_SIGS, Received: $RECEIVED_SIGS"
     exit 1
   fi
   ```

5. **All signatures valid:**
   ```
   ✅ All signatures verified
   ✅ Approval chain complete
   → Proceed to deployment
   ```
```

---

## Use Cases

### Use Case 1: Single-Tier Verification

**Scenario:** verification-agent verifies task, no additional approval needed

**Workflow:**
```bash
# verification-agent completes verification
verification-agent generates proofpack.json

# verification-agent signs proofpack
./orchestration/digital-signatures/sign-proofpack.sh \
  --proofpack proofpack.json \
  --signer verification-agent

# workflow-orchestrator verifies signature
./orchestration/digital-signatures/verify-signature.sh \
  --proofpack proofpack.json

Result: ✅ Signature valid, proceed
```

**Benefits:**
- Proves verification-agent actually verified
- Non-repudiation (verification-agent can't deny)
- Tamper detection (signature breaks if proofpack modified)

---

### Use Case 2: Two-Tier Approval (verification-agent + quality-validator)

**Scenario:** verification-agent verifies, quality-validator scores quality

**Workflow:**
```bash
# Tier 1: verification-agent
verification-agent generates proofpack.json
verification-agent signs proofpack (signs proofpack hash)

# Tier 2: quality-validator
quality-validator verifies verification-agent signature ✅
quality-validator scores quality
quality-validator signs proofpack (signs verification-agent signature hash)

# workflow-orchestrator verifies chain
verify verification-agent signature ✅
verify quality-validator signature ✅
verify quality-validator signs verification-agent signature ✅

Result: ✅ Two-tier approval chain complete
```

---

### Use Case 3: Three-Tier Approval (+ human reviewer)

**Scenario:** Production deployment requires human approval

**Workflow:**
```bash
# Tier 1: verification-agent
verification-agent generates proofpack.json
verification-agent signs proofpack

# Tier 2: quality-validator
quality-validator verifies + scores
quality-validator signs proofpack

# Tier 3: human-reviewer
human-reviewer reviews quality score (95.5%)
human-reviewer approves for production
human-reviewer signs proofpack

# workflow-orchestrator enforces complete chain
verify all 3 signatures ✅
verify chain of custody ✅

Result: ✅ Three-tier approval, deploy to production
```

---

## Security Considerations

### 1. Private Key Protection

**CRITICAL:** Private keys must NEVER be committed to git

**Storage options:**
1. **Environment variables:**
   ```bash
   export GPG_PRIVATE_KEY_VERIFICATION_AGENT="$(cat verification-agent.priv.asc)"
   ```

2. **System keyring:**
   ```bash
   # macOS Keychain
   security add-generic-password -a verification-agent -s gpg-key -w "$(cat verification-agent.priv.asc)"

   # Linux gpg-agent
   gpg --import verification-agent.priv.asc
   ```

3. **Secrets management:**
   - AWS Secrets Manager
   - HashiCorp Vault
   - 1Password CLI

### 2. Key Rotation

**Best practice:** Rotate keys annually

**Process:**
1. Generate new key pair
2. Export new public key
3. Update all systems to use new key
4. Revoke old key
5. Publish revocation certificate

### 3. Signature Verification Always

**Enforcement:**
- workflow-orchestrator MUST verify signatures before deployment
- NEVER trust unverified proofpacks
- HARD BLOCK if signature invalid

### 4. Audit Logging

**Log all signature operations:**
```json
{
  "event": "signature_created",
  "timestamp": "2025-10-25T14:30:00Z",
  "signer": "verification-agent",
  "proofpack": "login-screen-20251024.json",
  "signature_hash": "sha256:sig1hash..."
}
```

---

## Directory Structure

```
.orchestration/digital-signatures/
├── README.md (this file)
├── sign-proofpack.sh (create signature)
├── verify-signature.sh (verify signature)
├── verify-chain.sh (verify multi-party chain)
├── keys/
│   ├── README.md (key management docs)
│   ├── verification-agent.pub.asc (PUBLIC - tracked in git)
│   ├── quality-validator.pub.asc (PUBLIC - tracked in git)
│   └── .gitignore (excludes *.priv.asc)
└── logs/
    └── signature-audit.log (audit trail)
```

---

## Limitations

### 1. Key Management Complexity

**Challenge:** Managing private keys securely is complex

**Mitigation:** Use system keyring or secrets management service

### 2. Human Reviewer Bottleneck

**Challenge:** Waiting for human approval slows deployment

**Mitigation:** Make human approval optional, required only for production

### 3. Key Compromise

**Challenge:** If private key is stolen, attacker can forge signatures

**Mitigation:**
- Key rotation (annual)
- Revocation certificates
- Multi-party approval (requires compromising multiple keys)

---

## Future Enhancements

### Hardware Security Modules (HSM)

Store private keys in tamper-proof hardware (Yubikey, TPM)

### Threshold Signatures

Require M-of-N signatures (e.g., 2 of 3 reviewers must sign)

### Timestamping Service

Third-party timestamping for proof of signature time

---

## Related Documentation

- **Proofpacks** (.orchestration/proofpacks/README.md) - What gets signed
- **verification-agent** (agents/quality/verification-agent.md) - Who signs
- **quality-validator** (agents/quality/quality-validator.md) - Quality gate signer
- **workflow-orchestrator** (agents/orchestration/workflow-orchestrator.md) - Signature verification enforcement

---

**Last Updated:** 2025-10-25 (Stage 5 Week 10)
**Next Update:** Stage 6 (Threshold signatures, HSM integration)
