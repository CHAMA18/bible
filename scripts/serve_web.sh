#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/web"

cd "$ROOT_DIR"

echo "==> Serving on http://localhost:8080 ..."
echo "==> Press Ctrl+C to stop."

npx -y http-server "$BUILD_DIR" -p 8080 --cors -c
