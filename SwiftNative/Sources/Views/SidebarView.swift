import SwiftUI
import AppKit

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText: String = ""
    @State private var showNewProfileSheet: Bool = false
    @State private var newProfileName: String = ""
    @State private var newProfileBrowser: String = "Google Chrome"
    @State private var newProfileColor: String = "#E9407A"
    @State private var newProfileIcon: String = "briefcase.fill"
    
    let colorPalette = [
        "#E9407A", "#007AFF", "#AF52DE", "#30B0C7", "#FF9500", "#34C759", "#FF2D55", "#5856D6"
    ]
    
    let iconOptions = [
        "briefcase.fill", "house.fill", "paintbrush.fill", "terminal.fill", "envelope.fill", "folder.fill", "gamecontroller.fill", "chart.bar.fill"
    ]
    
    var filteredProfiles: [WorkspaceProfile] {
        if searchText.isEmpty {
            return appState.profiles
        } else {
            return appState.profiles.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Sidebar Search & Add Button
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.system(size: 11))
                    TextField("Search profiles...", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 12))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(Color(nsColor: .controlBackgroundColor).opacity(0.6))
                .cornerRadius(6)
                
                Button(action: {
                    showNewProfileSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "#E9407A"))
                        Text("New Workspace")
                            .font(.system(size: 12, weight: .medium))
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            
            // Profiles List
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("PROFILES")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(appState.profiles.count)")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1)
                            .background(Color.secondary.opacity(0.15))
                            .cornerRadius(4)
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    
                    ForEach(filteredProfiles) { profile in
                        SidebarProfileRow(
                            profile: profile,
                            isActive: appState.activeProfileId == profile.id,
                            onSelect: {
                                appState.selectProfile(id: profile.id)
                            },
                            onDelete: {
                                appState.deleteProfile(id: profile.id)
                            }
                        )
                    }
                    
                    // APP DEEPLINKS Section
                    HStack {
                        Text("APP DEEPLINKS")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("1")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1)
                            .background(Color.secondary.opacity(0.15))
                            .cornerRadius(4)
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 16)
                    .padding(.bottom, 4)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "music.note")
                            .foregroundColor(.green)
                        Text("Spotify Playlist")
                            .font(.system(size: 12))
                        Spacer()
                        Image(systemName: "pin.fill")
                            .font(.system(size: 9))
                            .foregroundColor(Color(hex: "#E9407A"))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.secondary.opacity(0.06))
                    .cornerRadius(6)
                    .padding(.horizontal, 8)
                }
            }
        }
        .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow))
        .sheet(isPresented: $showNewProfileSheet) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Create New Workspace")
                    .font(.system(size: 15, weight: .bold))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Workspace Name")
                        .font(.system(size: 12, weight: .medium))
                    TextField("e.g. Research & Writing", text: $newProfileName)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Assigned Browser")
                        .font(.system(size: 12, weight: .medium))
                    Picker("", selection: $newProfileBrowser) {
                        Text("Google Chrome").tag("Google Chrome")
                        Text("Brave Browser").tag("Brave Browser")
                        Text("Arc Browser").tag("Arc Browser")
                        Text("Firefox").tag("Firefox")
                        Text("Safari").tag("Safari")
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Theme Color")
                        .font(.system(size: 12, weight: .medium))
                    HStack(spacing: 10) {
                        ForEach(colorPalette, id: \.self) { color in
                            Circle()
                                .fill(Color(hex: color))
                                .frame(width: 22, height: 22)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: newProfileColor == color ? 2 : 0)
                                )
                                .shadow(radius: newProfileColor == color ? 2 : 0)
                                .onTapGesture {
                                    newProfileColor = color
                                }
                        }
                    }
                }
                
                HStack {
                    Button("Cancel") {
                        showNewProfileSheet = false
                    }
                    Spacer()
                    Button("Create Workspace") {
                        let name = newProfileName.trimmingCharacters(in: .whitespacesAndNewlines)
                        appState.createNewProfile(
                            name: name.isEmpty ? "New Workspace" : name,
                            browser: newProfileBrowser,
                            colorHex: newProfileColor,
                            icon: newProfileIcon
                        )
                        newProfileName = ""
                        showNewProfileSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(hex: "#E9407A"))
                }
                .padding(.top, 8)
            }
            .padding(20)
            .frame(width: 400)
        }
    }
}

struct SidebarProfileRow: View {
    var profile: WorkspaceProfile
    var isActive: Bool
    var onSelect: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 10) {
                // Color Avatar Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: profile.colorHex))
                        .frame(width: 26, height: 26)
                    Image(systemName: profile.sfSymbolIcon)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(profile.name)
                        .font(.system(size: 13, weight: isActive ? .semibold : .medium))
                        .foregroundColor(isActive ? .primary : .primary.opacity(0.85))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "globe")
                            .font(.system(size: 9))
                        Text(profile.browser)
                            .font(.system(size: 11))
                        Text("· \(profile.hotkey)")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(isActive ? Color(hex: "#E9407A").opacity(0.12) : Color.clear)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isActive ? Color(hex: "#E9407A").opacity(0.3) : Color.clear, lineWidth: 1)
            )
            .contextMenu {
                Button("Delete Profile", role: .destructive) {
                    onDelete()
                }
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 8)
    }
}

struct ProfileHeaderView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let profile = appState.activeProfile
        
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: profile.colorHex))
                    .frame(width: 44, height: 44)
                Image(systemName: profile.sfSymbolIcon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(profile.name)
                    .font(.system(size: 18, weight: .bold))
                
                HStack(spacing: 8) {
                    PillBadgeView(icon: "globe", text: profile.browser, colorHex: "#34C759")
                    PillBadgeView(icon: "link", text: "\(profile.urls.count) URLs", colorHex: "#E9407A")
                    PillBadgeView(icon: "keyboard", text: profile.hotkey, colorHex: "#007AFF")
                    PillBadgeView(icon: "macwindow", text: "Space \(profile.virtualSpace)", colorHex: "#AF52DE")
                }
            }
            
            Spacer()
            
            Button(action: {
                if let firstUrl = profile.urls.first, let url = URL(string: firstUrl.urlString) {
                    NSWorkspace.shared.open(url)
                    appState.triggerToast("Opened \(profile.name) workspace in \(profile.browser)")
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.forward.square.fill")
                    Text("Open Profile")
                }
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color(hex: "#E9407A"))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

struct PillBadgeView: View {
    var icon: String
    var text: String
    var colorHex: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.system(size: 11, weight: .semibold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(Color(hex: colorHex).opacity(0.12))
        .foregroundColor(Color(hex: colorHex))
        .cornerRadius(6)
    }
}
