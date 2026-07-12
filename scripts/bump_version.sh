#!/usr/bin/env bash
# bump_version.sh — bump the Bible app version, commit, tag, and push in one shot.
#
# Usage:
#   ./scripts/bump_version.sh <new-version-name>
#
# Examples:
#   ./scripts/bump_version.sh 1.0.1
#   ./scripts/bump_version.sh 1.1.0
#
# What it does:
#   1. Reads the current version from pubspec.yaml (format: version: NAME+CODE)
#   2. Increments the versionCode by 1
#   3. Writes the new version back to pubspec.yaml (preserving file formatting)
#   4. Commits the change as "chore(release): vX.Y.Z"
#   5. Tags the commit as "vX.Y.Z" (annotated tag)
#   6. Pushes main and the new tag to origin
#
# The push triggers the GitHub Actions workflows:
#   - .github/workflows/play-store-deploy.yml  → builds Android AAB → Play Store
#   - .github/workflows/app-store-deploy.yml   → builds iOS IPA → TestFlight
#
# Requirements:
#   - A clean working tree (no uncommitted changes)
#   - Push access to origin/main
#   - The current branch must be main

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# --- arg parsing -----------------------------------------------------------

if [ $# -ne 1 ]; then
  echo "Usage: $0 <new-version-name>"
  echo "Example: $0 1.0.1"
  exit 2
fi

NEW_VERSION_NAME="$1"

# Validate the version name: digits and dots only, must start and end with a digit.
if ! [[ "$NEW_VERSION_NAME" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
  echo "ERROR: Invalid version name '$NEW_VERSION_NAME'."
  echo "Expected format like '1.0.1' (digits separated by dots)."
  exit 2
fi

# --- pre-flight checks -----------------------------------------------------

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$BRANCH" != "main" ]; then
  echo "ERROR: Must be on the 'main' branch (currently on '$BRANCH')."
  exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "ERROR: Working tree has uncommitted changes. Commit or stash first."
  git status --short
  exit 1
fi

# Make sure we're up to date with origin.
git fetch origin main
LOCAL="$(git rev-parse HEAD)"
REMOTE="$(git rev-parse origin/main)"
if [ "$LOCAL" != "$REMOTE" ]; then
  echo "ERROR: Local main is out of sync with origin/main."
  echo "  local : $LOCAL"
  echo "  remote: $REMOTE"
  echo "Pull or rebase first."
  exit 1
fi

# --- read current version --------------------------------------------------

CURRENT_LINE="$(grep -E '^version:' pubspec.yaml | head -1 | tr -d ' ')"
CURRENT_FULL="${CURRENT_LINE#version:}"
CURRENT_NAME="${CURRENT_FULL%%+*}"
CURRENT_CODE="${CURRENT_FULL##*+}"

if [ -z "$CURRENT_NAME" ] || [ -z "$CURRENT_CODE" ]; then
  echo "ERROR: Could not parse current version from pubspec.yaml."
  echo "Expected format: version: NAME+CODE  (got: $CURRENT_FULL)"
  exit 1
fi

NEW_VERSION_CODE=$((CURRENT_CODE + 1))

echo "============================================================"
echo " Bible app — version bump"
echo "============================================================"
echo "  Current:  $CURRENT_NAME+$CURRENT_CODE"
echo "  New:      $NEW_VERSION_NAME+$NEW_VERSION_CODE"
echo "  Tag:      v$NEW_VERSION_NAME"
echo "============================================================"
echo ""
read -rp "Proceed? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# --- update pubspec.yaml ---------------------------------------------------
# Use Python to do a strict line replacement so we don't accidentally mangle
# any other 'version' fields elsewhere in the file.

python3 - "$NEW_VERSION_NAME" "$NEW_VERSION_CODE" <<'PY'
import re, sys
new_name, new_code = sys.argv[1], sys.argv[2]
with open('pubspec.yaml', 'r') as f:
    content = f.read()
new_line = f'version: {new_name}+{new_code}'
new_content, n = re.subn(r'^version:.*$', new_line, content, count=1, flags=re.MULTILINE)
if n != 1:
    print('ERROR: did not find exactly one version: line in pubspec.yaml', file=sys.stderr)
    sys.exit(1)
with open('pubspec.yaml', 'w') as f:
    f.write(new_content)
print(f'pubspec.yaml updated: {new_line}')
PY

# --- commit + tag + push ---------------------------------------------------

TAG="v$NEW_VERSION_NAME"

git add pubspec.yaml
git commit -m "chore(release): $TAG

Bump version from $CURRENT_NAME+$CURRENT_CODE to $NEW_VERSION_NAME+$NEW_VERSION_CODE.

This tag triggers:
  - .github/workflows/play-store-deploy.yml  → Android AAB → Play Store internal track
  - .github/workflows/app-store-deploy.yml   → iOS IPA → TestFlight"

git tag -a "$TAG" -m "Release $TAG (versionCode $NEW_VERSION_CODE)"

echo ""
echo "Pushing commit and tag to origin..."
git push origin main
git push origin "$TAG"

echo ""
echo "============================================================"
echo " Done!"
echo "============================================================"
echo "  Tag:        $TAG"
echo "  Watch:      https://github.com/$(git remote get-url origin | sed -E 's#.*github.com[/:](.*)\.git#\1#')/actions"
echo "  Play Store: https://play.google.com/console (internal testing)"
echo "  TestFlight: https://appstoreconnect.apple.com/apps/TestFlight"
