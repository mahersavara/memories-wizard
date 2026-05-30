#!/bin/bash
# Build script for Memories Wizard macOS
# Produces: /tmp/mw-build/MemoriesWizard.app
# Usage: ./build.sh [run]

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="/tmp/mw-build"
APP_BUNDLE="$BUILD_DIR/MemoriesWizard.app"
MACOS_DIR="$APP_BUNDLE/Contents/MacOS"
RESOURCES_DIR="$APP_BUNDLE/Contents/Resources"
SDK=$(xcrun --sdk macosx --show-sdk-path)
TARGET="arm64-apple-macosx12.0"

echo "=== Building Memories Wizard (macOS) ==="
echo "SDK: $SDK"
echo "Target: $TARGET"

# Clean and create .app bundle structure
rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Compile
swiftc \
  -sdk "$SDK" \
  -target "$TARGET" \
  -module-name MemoriesWizard \
  "$PROJECT_DIR/Sources/MemoriesWizard"/*.swift \
  -framework SwiftUI \
  -framework AppKit \
  -framework AVKit \
  -framework UniformTypeIdentifiers \
  -framework Combine \
  -o "$MACOS_DIR/MemoriesWizard"

# Copy Info.plist
cp "$PROJECT_DIR/Sources/MemoriesWizard/Info.plist" "$APP_BUNDLE/Contents/Info.plist"

# Copy resources
cp -R "$PROJECT_DIR/Resources/"* "$RESOURCES_DIR/" 2>/dev/null || true
cp -R "$PROJECT_DIR/Assets.xcassets" "$RESOURCES_DIR/" 2>/dev/null || true

# Create PkgInfo
echo -n 'APPL????' > "$APP_BUNDLE/Contents/PkgInfo"

echo "=== Build successful ==="
echo "App bundle: $APP_BUNDLE"

if [ "$1" = "run" ]; then
    echo "=== Launching Memories Wizard ==="
    open "$APP_BUNDLE"
fi
