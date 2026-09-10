import SwiftUI
import AppKit

struct AppsAndBrowserView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAddUrlSheet: Bool = false
    @State private var newUrlTitle: String = ""
    @State private var newUrlAddress: String = "https://"
    
    var browserBinding: Binding<String> {
        Binding<String>(
            get: { appState.activeProfile.browser },
            set: { appState.updateActiveBrowser($0) }
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Section 1: Default Browser & Profile
                ConfigBlockView(title: "DEFAULT BROWSER PROFILE", icon: "globe", iconColorHex: "#34C759") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Assigned Browser")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("All links opened in this workspace will launch in this browser")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Picker("", selection: browserBinding) {
                                Text("Google Chrome").tag("Google Chrome")
                                Text("Brave Browser").tag("Brave Browser")
                                Text("Arc Browser").tag("Arc Browser")
                                Text("Firefox").tag("Firefox")
                                Text("Safari").tag("Safari")
                            }
                            .frame(width: 180)
                        }
                    }
                    .padding(14)
                }
                
                // Section 2: Workspace URLs & Tabs
                ConfigBlockView(title: "AUTO-LAUNCH URLS & TABS", icon: "link", iconColorHex: "#007AFF") {
                    VStack(spacing: 0) {
                        ForEach(appState.activeProfile.urls) { urlItem in
                            HStack(spacing: 12) {
                                Image(systemName: urlItem.iconName)
                                    .foregroundColor(Color(hex: "#007AFF"))
                                    .font(.system(size: 14))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(urlItem.title)
                                        .font(.system(size: 13, weight: .medium))
                                    Text(urlItem.urlString)
                                        .font(.system(size: 11))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if let url = URL(string: urlItem.urlString) {
                                        NSWorkspace.shared.open(url)
                                    }
                                }) {
                                    Image(systemName: "arrow.up.right.square")
                                        .foregroundColor(Color(hex: "#007AFF"))
                                }
                                .buttonStyle(.plain)
                                .help("Open in browser")
                                
                                Button(action: {
                                    appState.removeUrlFromActiveProfile(id: urlItem.id)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.secondary)
                                }
                                .buttonStyle(.plain)
                                .help("Remove URL")
                            }
                            .padding(12)
                            Divider()
                        }
                        
                        Button(action: {
                            showAddUrlSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Add URL / Tab")
                                Spacer()
                            }
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "#007AFF"))
                            .padding(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // Section 3: App Deeplinks
                ConfigBlockView(title: "LAUNCHER DEEPLINKS", icon: "bolt.fill", iconColorHex: "#E9407A") {
                    VStack(spacing: 0) {
                        ForEach(appState.activeProfile.deeplinks) { deeplink in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "music.note")
                                        .foregroundColor(.green)
                                    Text(deeplink.name)
                                        .font(.system(size: 13, weight: .semibold))
                                    Spacer()
                                    Text(deeplink.shortcut)
                                        .font(.system(size: 11, weight: .bold))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.secondary.opacity(0.15))
                                        .cornerRadius(4)
                                }
                                HStack {
                                    Text("URI: \(deeplink.urlScheme)")
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Button("Launch Now") {
                                        if let url = URL(string: deeplink.urlScheme) {
                                            NSWorkspace.shared.open(url)
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .controlSize(.small)
                                }
                            }
                            .padding(14)
                        }
                    }
                }
            }
            .padding(20)
        }
        .sheet(isPresented: $showAddUrlSheet) {
            VStack(spacing: 16) {
                Text("Add Workspace URL")
                    .font(.system(size: 14, weight: .bold))
                
                TextField("Title (e.g. GitHub Repository)", text: $newUrlTitle)
                    .textFieldStyle(.roundedBorder)
                
                TextField("URL (e.g. https://github.com)", text: $newUrlAddress)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Button("Cancel") {
                        showAddUrlSheet = false
                    }
                    Spacer()
                    Button("Add URL") {
                        if !newUrlAddress.isEmpty {
                            let title = newUrlTitle.isEmpty ? newUrlAddress : newUrlTitle
                            appState.addUrlToActiveProfile(title: title, urlString: newUrlAddress)
                            newUrlTitle = ""
                            newUrlAddress = "https://"
                            showAddUrlSheet = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(hex: "#007AFF"))
                }
            }
            .padding(20)
            .frame(width: 380)
        }
    }
}

struct ConfigBlockView<Content: View>: View {
    var title: String
    var icon: String
    var iconColorHex: String
    var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: iconColorHex))
                        .frame(width: 20, height: 20)
                    Image(systemName: icon)
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
            )
        }
    }
}
