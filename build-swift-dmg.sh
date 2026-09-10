#!/bin/bash
# ═══════════════════════════════════════════════════════════
# SpaceSwitch — Pure Native Swift macOS DMG Builder Script
# ═══════════════════════════════════════════════════════════

set -e

echo "🚀 Building Pure Native Swift macOS Application..."

# Navigate to SwiftNative directory
cd SwiftNative

# Compile Swift package for release
swift build -c release --arch arm64 --arch x86_64

echo "📦 Packaging SpaceSwitch.app Bundle..."

APP_BUNDLE="build/SpaceSwitch.app"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# Copy binary to bundle
cp .build/apple/Products/Release/SpaceSwitch "$APP_BUNDLE/Contents/MacOS/SpaceSwitch"

# Create Info.plist for macOS app
cat <<EOF > "$APP_BUNDLE/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>SpaceSwitch</string>
    <key>CFBundleIdentifier</key>
    <string>com.spaceswitch.app.native</string>
    <key>CFBundleName</key>
    <string>SpaceSwitch</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <false/>
</dict>
</plist>
EOF

echo "💿 Creating Apple DMG Package..."
mkdir -p ../dist
hdiutil create -volname "SpaceSwitch Native" -srcfolder "$APP_BUNDLE" -ov -format UDZO "../dist/SpaceSwitch-Swift-Native.dmg"

echo "✅ Pure Swift Native macOS DMG Built Successfully! Location: dist/SpaceSwitch-Swift-Native.dmg"
