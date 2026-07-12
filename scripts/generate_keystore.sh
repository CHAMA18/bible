#!/usr/bin/env bash
# generate_keystore.sh — generate a release keystore for signing Android AABs
# and emit the values you need to paste into GitHub repo secrets.
#
# Run this ONCE on your local machine. Keep the .jks file safe — if you lose
# it you will not be able to ship updates to the same Play Store listing.
#
# Usage:
#   ./scripts/generate_keystore.sh
#
# You'll be prompted for passwords. After it finishes you'll get:
#   - bible-release.jks           (the keystore — DO NOT COMMIT, DO NOT LOSE)
#   - A printout of the base64 string to paste into KEYSTORE_BASE64 secret
#   - A summary of which value goes into which secret

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

KEYSTORE_NAME="bible-release.jks"
KEY_ALIAS="bible-key"
KEYSTORE_PATH="$ROOT_DIR/$KEYSTORE_NAME"
VALIDITY_DAYS=10000  # ~27 years — Play Store requires >= 25 years remaining

echo "============================================================"
echo " Bible app — Android release keystore generator"
echo "============================================================"
echo ""
echo "This will create: $KEYSTORE_PATH"
echo "Key alias:        $KEY_ALIAS"
echo "Validity:         $VALIDITY_DAYS days"
echo ""
echo "You will be prompted for:"
echo "  1. A keystore store password (min 6 chars)"
echo "  2. A key password (can match the store password)"
echo "  3. Distinguished-name fields (Name, Org, City, State, Country)"
echo ""
read -rp "Press Enter to continue, or Ctrl+C to abort..."

keytool -genkeypair \
  -v \
  -keystore "$KEYSTORE_PATH" \
  -storetype JKS \
  -keyalg RSA \
  -keysize 4096 \
  -validity "$VALIDITY_DAYS" \
  -alias "$KEY_ALIAS" \
  -storepass:env STORE_PW_PROMPT \
  -keypass:env KEY_PW_PROMPT 2>/dev/null || true

# keytool doesn't honor :env reliably across distros; fall back to interactive prompt.
if [ ! -f "$KEYSTORE_PATH" ]; then
  keytool -genkeypair \
    -v \
    -keystore "$KEYSTORE_PATH" \
    -storetype JKS \
    -keyalg RSA \
    -keysize 4096 \
    -validity "$VALIDITY_DAYS" \
    -alias "$KEY_ALIAS"
fi

echo ""
echo "============================================================"
echo " Keystore generated successfully"
echo "============================================================"
echo ""
echo "File: $KEYSTORE_PATH"
ls -lh "$KEYSTORE_PATH"
echo ""

BASE64_FILE="$KEYSTORE_PATH.base64"
base64 -w 0 "$KEYSTORE_PATH" > "$BASE64_FILE"
echo "Base64-encoded copy: $BASE64_FILE"
echo ""

KEYSTORE_BASE64="$(cat "$BASE64_FILE")"
echo "============================================================"
echo " Now add these as GitHub repo secrets"
echo " (Settings → Secrets and variables → Actions → New repository secret)"
echo "============================================================"
echo ""
echo "  Secret name                  Value"
echo "  ---------------------------  -------------------------------------------------------"
echo "  KEYSTORE_BASE64              (paste contents of $BASE64_FILE)"
echo "  KEYSTORE_ALIAS               $KEY_ALIAS"
echo "  KEYSTORE_PASSWORD            (the store password you typed above)"
echo "  KEY_PASSWORD                 (the key password you typed above)"
echo "  PLAY_SERVICE_ACCOUNT_JSON    (see docs/PLAY_STORE_SETUP.md for the service-account JSON)"
echo ""
echo "============================================================"
echo " IMPORTANT"
echo "============================================================"
echo " 1. NEVER commit bible-release.jks or *.base64 to git."
echo "    They are already in .gitignore, but double-check before pushing."
echo " 2. BACK UP bible-release.jks to at least two secure locations"
echo "    (password manager, encrypted USB, etc.). If you lose it you"
echo "    cannot publish updates to the same Play Store listing."
echo " 3. After confirming secrets work, delete the base64 file:"
echo "    rm $BASE64_FILE"
echo ""
