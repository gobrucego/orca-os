#!/bin/bash
# Verify GPG/PGP signatures in proofpack
# Usage: ./verify-signature.sh --proofpack <path>

set -euo pipefail

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --proofpack)
      PROOFPACK_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Validate arguments
if [ -z "${PROOFPACK_FILE:-}" ]; then
  echo "Usage: ./verify-signature.sh --proofpack <path>"
  exit 1
fi

if [ ! -f "$PROOFPACK_FILE" ]; then
  echo "❌ Proofpack file not found: $PROOFPACK_FILE"
  exit 1
fi

echo "=== Verifying Proofpack Signatures ==="
echo "Proofpack: $PROOFPACK_FILE"
echo

# Check if proofpack has signatures
if ! jq -e '.signatures' "$PROOFPACK_FILE" > /dev/null 2>&1; then
  # Check for old single-signature format
  if jq -e '.signature' "$PROOFPACK_FILE" > /dev/null 2>&1; then
    echo "⚠️  Old signature format detected, converting to multi-signature format..."
    jq '.signatures = [.signature] | del(.signature)' "$PROOFPACK_FILE" > "${PROOFPACK_FILE}.tmp"
    mv "${PROOFPACK_FILE}.tmp" "$PROOFPACK_FILE"
  else
    echo "❌ No signatures found in proofpack"
    exit 1
  fi
fi

# Get signature count
SIG_COUNT=$(jq '.signatures | length' "$PROOFPACK_FILE")
echo "Signatures found: $SIG_COUNT"
echo

# Get proofpack hash for first signature verification
PROOFPACK_HASH=$(jq -r '.hash' "$PROOFPACK_FILE")

# Verify each signature
VERIFIED_COUNT=0
FAILED_COUNT=0

for i in $(seq 0 $((SIG_COUNT - 1))); do
  echo "--- Signature $((i + 1)) of $SIG_COUNT ---"

  # Extract signature details
  SIGNER=$(jq -r ".signatures[$i].signer" "$PROOFPACK_FILE")
  ROLE=$(jq -r ".signatures[$i].role" "$PROOFPACK_FILE")
  SIGNED_AT=$(jq -r ".signatures[$i].signed_at" "$PROOFPACK_FILE")
  SIGNS=$(jq -r ".signatures[$i].signs" "$PROOFPACK_FILE")
  SIGNATURE=$(jq -r ".signatures[$i].pgp_signature" "$PROOFPACK_FILE")
  SIG_HASH=$(jq -r ".signatures[$i].signature_hash" "$PROOFPACK_FILE")

  echo "Signer: $SIGNER"
  echo "Role: $ROLE"
  echo "Signed at: $SIGNED_AT"
  echo "Signs: $SIGNS"

  # Determine what was signed
  if [ "$SIGNS" == "proofpack_hash" ]; then
    SIGNED_CONTENT="$PROOFPACK_HASH"
  elif [ "$SIGNS" == "previous_signature_hash" ]; then
    SIGNED_CONTENT=$(jq -r ".signatures[$i].previous_signature_hash" "$PROOFPACK_FILE")
  else
    echo "❌ Unknown signature type: $SIGNS"
    FAILED_COUNT=$((FAILED_COUNT + 1))
    echo
    continue
  fi

  # Write signature to temp file
  echo "$SIGNATURE" > /tmp/signature.asc

  # Verify signature with GPG
  echo "$SIGNED_CONTENT" | gpg --verify /tmp/signature.asc - 2>/dev/null

  if [ $? -eq 0 ]; then
    echo "✅ Signature valid"
    VERIFIED_COUNT=$((VERIFIED_COUNT + 1))

    # Verify signature hash matches
    COMPUTED_SIG_HASH="sha256:$(echo "$SIGNATURE" | shasum -a 256 | awk '{print $1}')"
    if [ "$COMPUTED_SIG_HASH" == "$SIG_HASH" ]; then
      echo "✅ Signature hash matches"
    else
      echo "⚠️  Signature hash mismatch"
      echo "Expected: $SIG_HASH"
      echo "Computed: $COMPUTED_SIG_HASH"
    fi
  else
    echo "❌ Signature verification failed"
    FAILED_COUNT=$((FAILED_COUNT + 1))
  fi

  echo
done

# Verify signature chain
if [ $SIG_COUNT -gt 1 ]; then
  echo "--- Verifying Signature Chain ---"

  for i in $(seq 1 $((SIG_COUNT - 1))); do
    CURRENT_SIGNS=$(jq -r ".signatures[$i].signs" "$PROOFPACK_FILE")

    if [ "$CURRENT_SIGNS" == "previous_signature_hash" ]; then
      PREV_SIG_HASH=$(jq -r ".signatures[$((i - 1))].signature_hash" "$PROOFPACK_FILE")
      CLAIMED_PREV_HASH=$(jq -r ".signatures[$i].previous_signature_hash" "$PROOFPACK_FILE")

      if [ "$PREV_SIG_HASH" == "$CLAIMED_PREV_HASH" ]; then
        echo "✅ Signature $((i + 1)) correctly signs signature $i"
      else
        echo "❌ Signature chain broken at signature $((i + 1))"
        echo "Expected previous hash: $PREV_SIG_HASH"
        echo "Claimed previous hash: $CLAIMED_PREV_HASH"
        FAILED_COUNT=$((FAILED_COUNT + 1))
      fi
    fi
  done

  echo
fi

# Cleanup
rm -f /tmp/signature.asc

# Summary
echo "=== Verification Summary ==="
echo "Total signatures: $SIG_COUNT"
echo "Verified: $VERIFIED_COUNT"
echo "Failed: $FAILED_COUNT"
echo

if [ $FAILED_COUNT -eq 0 ]; then
  echo "✅ All signatures verified successfully"

  # Check if approval chain is complete
  REQUIRED_SIGS=$(jq -r '.required_signatures // 0' "$PROOFPACK_FILE")
  RECEIVED_SIGS=$(jq -r '.received_signatures // 0' "$PROOFPACK_FILE")

  if [ "$REQUIRED_SIGS" -gt 0 ]; then
    if [ "$RECEIVED_SIGS" -ge "$REQUIRED_SIGS" ]; then
      echo "✅ Approval chain complete ($RECEIVED_SIGS/$REQUIRED_SIGS signatures)"
    else
      echo "⚠️  Approval chain incomplete ($RECEIVED_SIGS/$REQUIRED_SIGS signatures)"
      exit 2
    fi
  fi

  exit 0
else
  echo "❌ Signature verification failed"
  exit 1
fi
