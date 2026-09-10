import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var launchAtLoginBinding: Binding<Bool> {
        Binding<Bool>(
            get: { appState.launchAtLogin },
            set: { appState.launchAtLogin = $0; appState.saveStateToDisk() }
        )
    }
    
    var autoRestoreBinding: Binding<Bool> {
        Binding<Bool>(
            get: { appState.autoRestoreOnBoot },
            set: { appState.autoRestoreOnBoot = $0; appState.saveStateToDisk() }
        )
    }
    
    var keepAliveBinding: Binding<Bool> {
        Binding<Bool>(
            get: { appState.keepAliveInMenuBar },
            set: { appState.keepAliveInMenuBar = $0; appState.saveStateToDisk() }
        )
    }
    
    var quitIrrelevantBinding: Binding<Bool> {
        Binding<Bool>(
            get: { appState.quitIrrelevantApps },
            set: { appState.quitIrrelevantApps = $0; appState.saveStateToDisk() }
        )
    }
    
    var askBeforeQuittingBinding: Binding<Bool> {
        Binding<Bool>(
            get: { appState.askBeforeQuitting },
            set: { appState.askBeforeQuitting = $0; appState.saveStateToDisk() }
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Section 1: macOS Reboot & Lid Close Persistence
                ConfigBlockView(title: "MACOS BOOT & LID CLOSE SESSION RESTORE", icon: "power.circle.fill", iconColorHex: "#E9407A") {
                    VStack(spacing: 0) {
                        ToggleSettingRow(
                            name: "Launch at Login (macOS Auto-Start)",
                            desc: "Automatically launch SpaceSwitch when macOS boots up or user logs in",
                            isOn: launchAtLoginBinding
                        )
                        Divider()
                        
                        ToggleSettingRow(
                            name: "Auto-Restore Workspaces & Apps on Startup",
                            desc: "Reopen active workspace apps, URLs, env vars & window layout after Mac restart or lid wake",
                            isOn: autoRestoreBinding
                        )
                        Divider()
                        
                        ToggleSettingRow(
                            name: "Keep Alive in Menu Bar on Window Close",
                            desc: "Closing app window keeps daemon running in macOS menu bar",
                            isOn: keepAliveBinding
                        )
                        Divider()
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Session backup synced to ~/.config/SpaceSwitch/session_state.json")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.green)
                            Spacer()
                            Button("⚡ Test Reboot Recovery") {
                                appState.simulateRebootRecovery()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color(hex: "#E9407A"))
                            .controlSize(.small)
                        }
                        .padding(12)
                        .background(Color.green.opacity(0.08))
                    }
                }
                
                // Section 2: App Management Settings
                ConfigBlockView(title: "APPLICATION SWITCHING BEHAVIOR", icon: "gearshape.fill", iconColorHex: "#007AFF") {
                    VStack(spacing: 0) {
                        ToggleSettingRow(
                            name: "Quit Irrelevant Apps",
                            desc: "Automatically close apps not in this profile's list when switching",
                            isOn: quitIrrelevantBinding
                        )
                        Divider()
                        
                        ToggleSettingRow(
                            name: "Ask Before Quitting",
                            desc: "Show a confirmation before closing irrelevant apps",
                            isOn: askBeforeQuittingBinding
                        )
                    }
                }
            }
            .padding(20)
        }
    }
}

struct ToggleSettingRow: View {
    var name: String
    var desc: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 13, weight: .semibold))
                Text(desc)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .tint(Color(hex: "#E9407A"))
        }
        .padding(14)
    }
}
