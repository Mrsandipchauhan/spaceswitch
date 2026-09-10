import SwiftUI
import AppKit

@main
struct SpaceSwitchApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        // Main Application Window
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .frame(minWidth: 1000, minHeight: 650)
                .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow))
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        
        // Native macOS Menu Bar Item (MenuBarExtra)
        MenuBarExtra("SpaceSwitch", systemImage: "slider.horizontal.2.square.on.square") {
            MenuBarView()
                .environmentObject(appState)
        }
        .menuBarExtraStyle(.window)
    }
}

// macOS Visual Effect Background View (Vibrancy)
struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
