#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$ROOT_DIR/.build"
APP_DIR="$BUILD_DIR/ScreenExposer.app"
MACOS_DIR="$APP_DIR/Contents/MacOS"

mkdir -p "$MACOS_DIR"

swiftc \
  "$ROOT_DIR/main.swift" \
  "$ROOT_DIR/PowerManager.swift" \
  "$ROOT_DIR/ScreenKeepAwakeManager.swift" \
  -o "$MACOS_DIR/ScreenExposer" \
  -framework AppKit \
  -framework IOKit

cp "$ROOT_DIR/Info.plist" "$APP_DIR/Contents/Info.plist"

echo "Built $APP_DIR"
