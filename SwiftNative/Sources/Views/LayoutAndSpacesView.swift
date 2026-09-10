import SwiftUI

struct LayoutAndSpacesView: View {
    @EnvironmentObject var appState: AppState
    
    var spaceBinding: Binding<Int> {
        Binding<Int>(
            get: { appState.activeProfile.virtualSpace },
            set: { appState.updateActiveVirtualSpace($0) }
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ConfigBlockView(title: "MACOS VIRTUAL DESKTOPS (SPACES)", icon: "rectangle.3.group.fill", iconColorHex: "#AF52DE") {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Assigned macOS Desktop Space")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("SpaceSwitch will automatically switch to this virtual desktop on macOS")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Picker("", selection: spaceBinding) {
                                Text("Desktop 1").tag(1)
                                Text("Desktop 2").tag(2)
                                Text("Desktop 3").tag(3)
                                Text("Desktop 4").tag(4)
                                Text("Desktop 5").tag(5)
                            }
                            .frame(width: 140)
                        }
                        
                        // Layout preview grid
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Virtual Desktop Preview (Space \(appState.activeProfile.virtualSpace))")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.blue.opacity(0.15))
                                    .overlay(
                                        VStack {
                                            Image(systemName: "curlybraces")
                                                .font(.system(size: 18))
                                                .foregroundColor(.blue)
                                            Text("Code Editor")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.blue)
                                        }
                                    )
                                    .frame(height: 120)
                                
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.green.opacity(0.15))
                                        .overlay(
                                            HStack {
                                                Image(systemName: "globe")
                                                    .foregroundColor(.green)
                                                Text(appState.activeProfile.browser)
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundColor(.green)
                                            }
                                        )
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(hex: "#E9407A").opacity(0.15))
                                        .overlay(
                                            HStack {
                                                Image(systemName: "terminal.fill")
                                                    .foregroundColor(Color(hex: "#E9407A"))
                                                Text("Terminal")
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundColor(Color(hex: "#E9407A"))
                                            }
                                        )
                                }
                                .frame(height: 120)
                            }
                        }
                        .padding(12)
                        .background(Color(nsColor: .controlBackgroundColor))
                        .cornerRadius(8)
                    }
                    .padding(14)
                }
            }
            .padding(20)
        }
    }
}
