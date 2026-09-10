#!/bin/bash
# ═══════════════════════════════════════════════════════════
# SpaceSwitch — macOS DMG Installer Build Script
# ═══════════════════════════════════════════════════════════

echo "🚀 Building SpaceSwitch for macOS (DMG Package)..."

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "📦 Installing Electron dependencies..."
    npm install
fi

# Build DMG package for macOS (Universal: Apple Silicon M1/M2/M3 + Intel)
echo "🔨 Compiling DMG installer package..."
npm run dist:dmg

echo "✅ DMG Built Successfully! Check output in 'dist/SpaceSwitch-1.0.0.dmg'"
