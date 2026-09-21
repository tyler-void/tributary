#!/usr/bin/env bash
# Build one upload-ready zip per skill into dist/ (claude.ai: Customize > Skills > upload).
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf dist
mkdir -p dist
for dir in skills/*/; do
  name="$(basename "$dir")"
  (cd skills && zip -qr "../dist/${name}.zip" "$name")
  echo "dist/${name}.zip"
done
