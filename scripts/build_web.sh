#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/web"
cd "$ROOT_DIR"
echo "==> Cleaning previous build..."
rm -rf "$BUILD_DIR"
echo "==> Fetching dependencies..."
flutter pub get
echo "==> Building web (WASM)..."
flutter build web --wasm --base-href "/"
echo ""
echo "==> Build complete! Output size:"
du -sh "$BUILD_DIR"
echo ""
echo "==> To serve locally run:"
echo "    npx -y http-server build/web -p 8080 --cors"
echo "    Then open http://localhost:8080"
