// swift-tools-version: 5.9
// ═══════════════════════════════════════════════════════════
// SpaceSwitch — Native macOS App Swift Package Manifest
// ═══════════════════════════════════════════════════════════

import PackageDescription

let package = Package(
    name: "SpaceSwitch",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "SpaceSwitch",
            targets: ["SpaceSwitch"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SpaceSwitch",
            dependencies: [],
            path: "Sources"
        )
    ]
)
