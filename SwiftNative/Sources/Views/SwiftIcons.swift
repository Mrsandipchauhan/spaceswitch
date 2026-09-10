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

// MARK: - SwiftUI Extension
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
