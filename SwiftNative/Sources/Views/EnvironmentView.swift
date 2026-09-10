import SwiftUI

struct EnvironmentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAddEnvSheet: Bool = false
    @State private var newEnvKey: String = ""
    @State private var newEnvValue: String = ""
    @State private var autoExecuteScript: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ConfigBlockView(title: "ENVIRONMENT VARIABLES (.ENV)", icon: "curlybraces.square.fill", iconColorHex: "#5856D6") {
                    VStack(spacing: 0) {
                        if appState.activeProfile.envVars.isEmpty {
                            Text("No environment variables configured for this profile.")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                                .padding(16)
                        } else {
                            ForEach(Array(appState.activeProfile.envVars.keys.sorted()), id: \.self) { key in
                                HStack {
                                    Text(key)
                                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                                        .foregroundColor(Color(hex: "#5856D6"))
                                    Spacer()
                                    Text(appState.activeProfile.envVars[key] ?? "")
                                        .font(.system(size: 12, design: .monospaced))
                                        .foregroundColor(.secondary)
                                    
                                    Button(action: {
                                        appState.removeEnvVarFromActiveProfile(key: key)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.leading, 8)
                                    .help("Remove variable")
                                }
                                .padding(12)
                                Divider()
                            }
                        }
                        
                        Button(action: {
                            showAddEnvSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Add Environment Variable")
                                Spacer()
                            }
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "#5856D6"))
                            .padding(12)
                        }
                        .buttonStyle(.plain)
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
                            Toggle("", isOn: $autoExecuteScript)
                                .toggleStyle(.switch)
                        }
                        
                        Text("export \(appState.activeProfile.envVars.map { "\($0.key)=\($0.value)" }.joined(separator: " "))")
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
        .sheet(isPresented: $showAddEnvSheet) {
            VStack(spacing: 16) {
                Text("Add Environment Variable")
                    .font(.system(size: 14, weight: .bold))
                
                TextField("Variable Name (e.g. PORT, API_KEY)", text: $newEnvKey)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Value (e.g. 8080, production)", text: $newEnvValue)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Button("Cancel") {
                        showAddEnvSheet = false
                    }
                    Spacer()
                    Button("Save") {
                        let trimmedKey = newEnvKey.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmedKey.isEmpty {
                            appState.addEnvVarToActiveProfile(key: trimmedKey, value: newEnvValue)
                            newEnvKey = ""
                            newEnvValue = ""
                            showAddEnvSheet = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(hex: "#5856D6"))
                }
            }
            .padding(20)
            .frame(width: 360)
        }
    }
}
