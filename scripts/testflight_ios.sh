#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIVE_PATH="$ROOT_DIR/build/ios/archive/Runner.xcarchive"
EXPORT_PATH="$ROOT_DIR/build/ios/ipa"
EXPORT_OPTIONS="$ROOT_DIR/ios/ExportOptions-TestFlight.plist"
SCHEME="Runner"
WORKSPACE="$ROOT_DIR/ios/Runner.xcworkspace"
CONFIGURATION="Release"

cd "$ROOT_DIR"

flutter pub get

pushd "$ROOT_DIR/ios" >/dev/null
pod install
popd >/dev/null

xcodebuild \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -destination generic/platform=iOS \
  -archivePath "$ARCHIVE_PATH" \
  -allowProvisioningUpdates \
  archive

xcodebuild \
  -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS" \
  -allowProvisioningUpdates

if [[ -n "${ASC_API_KEY_ID:-}" && -n "${ASC_API_ISSUER_ID:-}" && -n "${ASC_API_KEY_PATH:-}" ]]; then
  IPA_PATH="$(find "$EXPORT_PATH" -maxdepth 1 -name '*.ipa' -print -quit)"
  if [[ -z "$IPA_PATH" ]]; then
    echo "No IPA found in $EXPORT_PATH" >&2
    exit 1
  fi

  mkdir -p "$HOME/.appstoreconnect/private_keys"
  cp "$ASC_API_KEY_PATH" "$HOME/.appstoreconnect/private_keys/AuthKey_${ASC_API_KEY_ID}.p8"

  xcrun altool \
    --upload-app \
    --type ios \
    --file "$IPA_PATH" \
    --apiKey "$ASC_API_KEY_ID" \
    --apiIssuer "$ASC_API_ISSUER_ID"
else
  echo "Archive and export completed. Set ASC_API_KEY_ID, ASC_API_ISSUER_ID, and ASC_API_KEY_PATH to upload automatically."
fi
