#!/bin/bash
# Sign proofpack with GPG/PGP signature
# Usage: ./sign-proofpack.sh --proofpack <path> --signer <agent-name> --role <role>

set -euo pipefail

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --proofpack)
      PROOFPACK_FILE="$2"
      shift 2
      ;;
    --signer)
      SIGNER="$2"
      shift 2
      ;;
    --role)
      ROLE="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Validate arguments
if [ -z "${PROOFPACK_FILE:-}" ] || [ -z "${SIGNER:-}" ]; then
  echo "Usage: ./sign-proofpack.sh --proofpack <path> --signer <agent-name> [--role <role>]"
  exit 1
fi

if [ ! -f "$PROOFPACK_FILE" ]; then
  echo "❌ Proofpack file not found: $PROOFPACK_FILE"
  exit 1
fi

# Default role
ROLE="${ROLE:-signer}"

# Extract proofpack hash
PROOFPACK_HASH=$(jq -r '.hash' "$PROOFPACK_FILE")

if [ -z "$PROOFPACK_HASH" ] || [ "$PROOFPACK_HASH" == "null" ]; then
  echo "❌ Proofpack hash not found in $PROOFPACK_FILE"
  exit 1
fi

# Check if already signed
EXISTING_SIG=$(jq -r '.signature.signer' "$PROOFPACK_FILE" 2>/dev/null || echo "null")

if [ "$EXISTING_SIG" != "null" ]; then
  echo "⚠️  Proofpack already signed by $EXISTING_SIG"
  echo "Switching to multi-signature mode..."

  # Convert to multi-signature format
  jq '.signatures = [.signature] | del(.signature)' "$PROOFPACK_FILE" > "${PROOFPACK_FILE}.tmp"
  mv "${PROOFPACK_FILE}.tmp" "$PROOFPACK_FILE"
fi

# Determine what to sign
if jq -e '.signatures' "$PROOFPACK_FILE" > /dev/null 2>&1; then
  # Multi-signature: Sign previous signature hash
  PREVIOUS_SIG_HASH=$(jq -r '.signatures[-1].signature_hash' "$PROOFPACK_FILE")
  SIGNS="previous_signature_hash"
  TO_SIGN="$PREVIOUS_SIG_HASH"
else
  # First signature: Sign proofpack hash
  SIGNS="proofpack_hash"
  TO_SIGN="$PROOFPACK_HASH"
fi

echo "=== Signing Proofpack ==="
echo "Proofpack: $PROOFPACK_FILE"
echo "Signer: $SIGNER"
echo "Role: $ROLE"
echo "Signs: $SIGNS"
echo "Hash to sign: $TO_SIGN"
echo

# Sign with GPG
echo "$TO_SIGN" | gpg --armor --sign --local-user "$SIGNER" > /tmp/signature.asc 2>/dev/null || {
  echo "❌ GPG signing failed"
  echo "Ensure GPG key for '$SIGNER' exists and is accessible"
  echo
  echo "To generate key:"
  echo "  gpg --gen-key"
  echo
  exit 1
}

# Extract signature
SIGNATURE=$(cat /tmp/signature.asc | sed -n '/BEGIN PGP SIGNATURE/,/END PGP SIGNATURE/p')

# Compute signature hash
SIGNATURE_HASH="sha256:$(echo "$SIGNATURE" | shasum -a 256 | awk '{print $1}')"

# Get timestamp
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Create signature object
SIGNATURE_OBJ=$(jq -n \
  --arg signer "$SIGNER" \
  --arg role "$ROLE" \
  --arg signed_at "$TIMESTAMP" \
  --arg signs "$SIGNS" \
  --arg sig_hash "$SIGNATURE_HASH" \
  --arg pgp_sig "$SIGNATURE" \
  '{
    signer: $signer,
    role: $role,
    signed_at: $signed_at,
    signs: $signs,
    signature_hash: $sig_hash,
    algorithm: "RSA-2048",
    pgp_signature: $pgp_sig
  }')

# Add previous_signature_hash if signing chain
if [ "$SIGNS" == "previous_signature_hash" ]; then
  SIGNATURE_OBJ=$(echo "$SIGNATURE_OBJ" | jq --arg prev_hash "$TO_SIGN" '. + {previous_signature_hash: $prev_hash}')
fi

# Embed signature in proofpack
if jq -e '.signatures' "$PROOFPACK_FILE" > /dev/null 2>&1; then
  # Append to signatures array
  jq --argjson sig "$SIGNATURE_OBJ" '.signatures += [$sig] | .received_signatures = (.signatures | length)' \
    "$PROOFPACK_FILE" > "${PROOFPACK_FILE}.tmp"
else
  # Create signatures array
  jq --argjson sig "$SIGNATURE_OBJ" '.signatures = [$sig] | .received_signatures = 1 | .required_signatures = 1' \
    "$PROOFPACK_FILE" > "${PROOFPACK_FILE}.tmp"
fi

mv "${PROOFPACK_FILE}.tmp" "$PROOFPACK_FILE"

# Cleanup
rm -f /tmp/signature.asc

echo "✅ Proofpack signed"
echo
echo "Signer: $SIGNER"
echo "Role: $ROLE"
echo "Signed at: $TIMESTAMP"
echo "Signature hash: $SIGNATURE_HASH"
echo "Total signatures: $(jq -r '.received_signatures' "$PROOFPACK_FILE")"
