//
//  SwiftIcons.swift
//  SpaceSwitch — Native macOS Icon Catalog & SF Symbols Helper
//

import SwiftUI
import AppKit

/// Comprehensive SF Symbols & SVG Icons dictionary for SpaceSwitch macOS application
public enum SpaceSwitchIcon: String, CaseIterable {
    // Workspace Profiles
    case briefcase = "briefcase.fill"
    case house = "house.fill"
    case paintbrush = "paintbrush.fill"
    case terminal = "terminal.fill"
    case envelope = "envelope.fill"

    // Navigation & Tabs
    case appsAndBrowser = "square.grid.2x2.fill"
    case environment = "curlybraces.square.fill"
    case layoutAndSpaces = "rectangle.3.group.fill"
    case settings = "gearshape.fill"

    // Controls & Features
    case search = "magnifyingglass"
    case plusCircle = "plus.circle.fill"
    case globe = "globe"
    case link = "link"
    case folder = "folder.fill"
    case clock = "clock.fill"
    case power = "power.circle.fill"
    case menuBar = "menubar.rectangle"
    case chevronDown = "chevron.down"
    case trash = "trash.fill"
    case checkmark = "checkmark.circle.fill"

    /// Returns SwiftUI Image for SF Symbol or fallback SVG asset
    public var image: Image {
        Image(systemName: self.rawValue)
    }

    /// Returns AppKit NSImage for macOS AppKit UI
    public var nsImage: NSImage? {
        NSImage(systemSymbolName: self.rawValue, accessibilityDescription: self.rawValue)
    }
}

// MARK: - SwiftUI Extension Example
public extension View {
    @ViewBuilder
    func spaceSwitchIcon(_ icon: SpaceSwitchIcon, size: CGFloat = 16, color: Color = .primary) -> some View {
        icon.image
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(color)
    }
}

// MARK: - Swift Code Mapping Reference for Developers
/*
 ═════════════════════════════════════════════════════════════════════
  SpaceSwitch — Swift Code Mapping Reference:
 ═════════════════════════════════════════════════════════════════════

 1. Sidebar Profiles:
    - Workspace_1:   Image(systemName: "briefcase.fill")
    - Personal:      Image(systemName: "house.fill")
    - Design Studio: Image(systemName: "paintbrush.fill")
    - DevOps Infra:  Image(systemName: "terminal.fill")
    - Email & Admin: Image(systemName: "envelope.fill")

 2. Main Tabs:
    - Apps & Browser: Image(systemName: "square.grid.2x2.fill")
    - Environment:    Image(systemName: "curlybraces.square.fill")
    - Layout & Spaces:Image(systemName: "rectangle.3.group.fill")
    - Settings:       Image(systemName: "gearshape.fill")

 3. System Actions:
    - Auto Start:    Image(systemName: "power.circle.fill")
    - Schedule:      Image(systemName: "clock.fill")
    - Search:        Image(systemName: "magnifyingglass")
    - Add Profile:   Image(systemName: "plus.circle.fill")

 4. macOS Menu Bar Icon:
    - Status Item:   NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
                     statusItem.button?.image = NSImage(systemSymbolName: "slider.horizontal.2.square.on.square", accessibilityDescription: "SpaceSwitch")
 ═════════════════════════════════════════════════════════════════════
*/
