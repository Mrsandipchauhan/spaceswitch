import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchFieldText: String = ""
    
    var body: some View {
        MainSplitView()
    }
}

struct MainSplitView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            SidebarView()
                .frame(width: 240)
            
            Divider()
                .background(Color(nsColor: .separatorColor))
            
            // Main Detail Pane
            VStack(spacing: 0) {
                // Titlebar Header
                TitlebarHeaderView()
                
                Divider()
                    .background(Color(nsColor: .separatorColor))
                
                // Profile Banner Header
                ProfileHeaderView()
                
                // Tab Selection Bar
                TabSelectionBarView()
                
                // Tab Panels
                ZStack {
                    if appState.activeTab == "tab-apps" {
                        AppsAndBrowserView()
                    } else if appState.activeTab == "tab-env" {
                        EnvironmentView()
                    } else if appState.activeTab == "tab-layout" {
                        LayoutAndSpacesView()
                    } else if appState.activeTab == "tab-settings" {
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(nsColor: .windowBackgroundColor))
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if appState.showToast {
                ToastNotificationView(text: appState.toastText)
                    .padding(20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

struct TitlebarHeaderView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            // Traffic lights space placeholder
            Spacer()
                .frame(width: 70)
            
            Spacer()
            
            Text("SpaceSwitch")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
            
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 6, height: 6)
                Text(appState.statusMessage)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.green.opacity(0.9))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color.green.opacity(0.12))
            .cornerRadius(10)
            
            Spacer()
            
            Button(action: {
                appState.simulateRebootRecovery()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                    Text("Reboot Restore")
                }
                .font(.system(size: 11, weight: .semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(nsColor: .controlBackgroundColor))
                .cornerRadius(6)
            }
            .buttonStyle(.plain)
        }
        .frame(height: 52)
        .padding(.horizontal, 16)
        .background(VisualEffectView(material: .titlebar, blendingMode: .withinWindow))
    }
}

struct TabSelectionBarView: View {
    @EnvironmentObject var appState: AppState
    
    let tabs = [
        ("tab-apps", "Apps & Browser", "square.grid.2x2.fill"),
        ("tab-env", "Environment", "curlybraces.square.fill"),
        ("tab-layout", "Layout & Spaces", "rectangle.3.group.fill"),
        ("tab-settings", "Settings", "gearshape.fill")
    ]
    
    var body: some View {
        HStack(spacing: 24) {
            ForEach(tabs, id: \.0) { tab in
                Button(action: {
                    appState.activeTab = tab.0
                    appState.saveStateToDisk()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: tab.2)
                            .font(.system(size: 13))
                        Text(tab.1)
                            .font(.system(size: 13, weight: appState.activeTab == tab.0 ? .semibold : .regular))
                    }
                    .foregroundColor(appState.activeTab == tab.0 ? Color(hex: "#E9407A") : .secondary)
                    .padding(.vertical, 10)
                    .overlay(alignment: .bottom) {
                        if appState.activeTab == tab.0 {
                            Rectangle()
                                .fill(Color(hex: "#E9407A"))
                                .frame(height: 2)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color(nsColor: .windowBackgroundColor))
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

struct ToastNotificationView: View {
    var text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.85))
        .cornerRadius(8)
        .shadow(radius: 10)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 1)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
