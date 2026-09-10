import SwiftUI

struct LayoutAndSpacesView: View {
    @EnvironmentObject var appState: AppState
    
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
                            Picker("", selection: .constant(2)) {
                                Text("Space 1").tag(1)
                                Text("Space 2").tag(2)
                                Text("Space 3").tag(3)
                                Text("Space 4").tag(4)
                            }
                            .frame(width: 120)
                        }
                        
                        // Layout preview grid
                        VStack {
                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.blue.opacity(0.15))
                                    .overlay(
                                        Text("VS Code")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.blue)
                                    )
                                    .frame(height: 120)
                                
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.green.opacity(0.15))
                                        .overlay(
                                            Text("Chrome")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.green)
                                        )
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(hex: "#E9407A").opacity(0.15))
                                        .overlay(
                                            Text("Terminal")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(Color(hex: "#E9407A"))
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
