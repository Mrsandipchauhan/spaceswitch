import SwiftUI
import AppKit

struct MenuBarView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            // Menu bar header
            HStack {
                Image(systemName: "slider.horizontal.2.square.on.square")
                    .foregroundColor(Color(hex: "#E9407A"))
                Text("SpaceSwitch")
                    .font(.system(size: 14, weight: .bold))
                Spacer()
            }
            .padding(12)
            
            Divider()
            
            // Profiles list
            ForEach(appState.profiles) { profile in
                Button(action: {
                    appState.selectProfile(id: profile.id)
                }) {
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(hex: profile.colorHex))
                                .frame(width: 24, height: 24)
                            Image(systemName: profile.sfSymbolIcon)
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text(profile.name)
                                .font(.system(size: 13, weight: appState.activeProfileId == profile.id ? .bold : .medium))
                            Text(profile.browser)
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if appState.activeProfileId == profile.id {
                            Text("ACTIVE")
                                .font(.system(size: 9, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.15))
                                .foregroundColor(.green)
                                .cornerRadius(4)
                        }
                        
                        Text(profile.hotkey)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(appState.activeProfileId == profile.id ? Color(hex: "#E9407A").opacity(0.1) : Color.clear)
                }
                .buttonStyle(.plain)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            Button(action: {
                NSApp.activate(ignoringOtherApps: true)
            }) {
                HStack {
                    Image(systemName: "gearshape")
                    Text("Settings...")
                    Spacer()
                    Text("⌘,")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }
            .buttonStyle(.plain)
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                HStack {
                    Image(systemName: "power")
                        .foregroundColor(.red)
                    Text("Quit SpaceSwitch")
                        .foregroundColor(.red)
                    Spacer()
                    Text("⌘Q")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }
            .buttonStyle(.plain)
        }
        .frame(width: 280)
    }
}
