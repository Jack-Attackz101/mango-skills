#!/usr/bin/env bash
# Build one .zip per skill in dist/, for uploading to Claude.ai (Settings > Capabilities > Skills).
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rm -rf "$REPO/dist"; mkdir -p "$REPO/dist"
for src in "$REPO"/skills/*/; do
  name="$(basename "$src")"
  (cd "$REPO/skills" && zip -qr "$REPO/dist/$name.zip" "$name" -x '*/node_modules/*' '*.mango-skill')
  echo "dist/$name.zip  $(du -h "$REPO/dist/$name.zip" | cut -f1)"
done
