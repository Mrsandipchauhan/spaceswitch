import SwiftUI

struct EnvironmentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ConfigBlockView(title: "ENVIRONMENT VARIABLES (.ENV)", icon: "curlybraces.square.fill", iconColorHex: "#5856D6") {
                    VStack(spacing: 0) {
                        ForEach(Array(appState.activeProfile.envVars.keys), id: \.self) { key in
                            HStack {
                                Text(key)
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color(hex: "#5856D6"))
                                Spacer()
                                Text(appState.activeProfile.envVars[key] ?? "")
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }
                            .padding(12)
                            Divider()
                        }
                    }
                }
                
                ConfigBlockView(title: "AUTO-EXECUTE ON WORKSPACE SWITCH", icon: "terminal.fill", iconColorHex: "#30B0C7") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Startup Shell Script")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("Runs automatically when switching to this profile")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Toggle("", isOn: .constant(true))
                                .toggleStyle(.switch)
                        }
                        
                        Text("npm run dev --prefix ~/Desktop/Macbook/spaceswitch")
                            .font(.system(size: 11, design: .monospaced))
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.black.opacity(0.85))
                            .foregroundColor(.green)
                            .cornerRadius(6)
                    }
                    .padding(14)
                }
            }
            .padding(20)
        }
    }
}
