import Foundation
import Combine
import AppKit

public class AppState: ObservableObject {
    @Published public var profiles: [WorkspaceProfile]
    @Published public var activeProfileId: String
    @Published public var activeTab: String
    
    // System Settings
    @Published public var launchAtLogin: Bool
    @Published public var autoRestoreOnBoot: Bool
    @Published public var keepAliveInMenuBar: Bool
    @Published public var quitIrrelevantApps: Bool
    @Published public var askBeforeQuitting: Bool
    
    // Status text
    @Published public var statusMessage: String = "● Auto-Saved to Mac"
    @Published public var showToast: Bool = false
    @Published public var toastText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let storagePath: URL
    
    public init() {
        let fileManager = FileManager.default
        let configDir = fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".config")
            .appendingPathComponent("SpaceSwitch")
        
        try? fileManager.createDirectory(at: configDir, withIntermediateDirectories: true)
        self.storagePath = configDir.appendingPathComponent("session_state.json")
        
        self.profiles = WorkspaceProfile.defaults
        self.activeProfileId = "work"
        self.activeTab = "tab-apps"
        self.launchAtLogin = true
        self.autoRestoreOnBoot = true
        self.keepAliveInMenuBar = true
        self.quitIrrelevantApps = true
        self.askBeforeQuitting = false
        
        loadStateFromDisk()
        setupAutoSave()
        setupPowerMonitorObservers()
    }
    
    public var activeProfile: WorkspaceProfile {
        get {
            profiles.first(where: { $0.id == activeProfileId }) ?? (profiles.first ?? WorkspaceProfile.defaults[0])
        }
        set {
            if let index = profiles.firstIndex(where: { $0.id == activeProfileId }) {
                profiles[index] = newValue
                saveStateToDisk()
            }
        }
    }
    
    public func selectProfile(id: String) {
        self.activeProfileId = id
        triggerToast("Switched to \(activeProfile.name) — State Saved")
        saveStateToDisk()
    }
    
    public func createNewProfile(name: String, browser: String = "Google Chrome", colorHex: String = "#34C759", icon: String = "folder.fill") {
        let newId = "profile_\(UUID().uuidString.prefix(6).lowercased())"
        let newProfile = WorkspaceProfile(
            id: newId,
            name: name.isEmpty ? "New Workspace" : name,
            colorHex: colorHex,
            browser: browser,
            hotkey: "⌃⇧\(min(profiles.count + 1, 9))",
            virtualSpace: 1,
            sfSymbolIcon: icon,
            urls: [],
            deeplinks: [],
            envVars: [:]
        )
        profiles.append(newProfile)
        self.activeProfileId = newId
        saveStateToDisk()
        triggerToast("Created workspace: \(newProfile.name)")
    }
    
    public func deleteProfile(id: String) {
        guard profiles.count > 1 else {
            triggerToast("Cannot delete the only remaining profile")
            return
        }
        profiles.removeAll(where: { $0.id == id })
        if activeProfileId == id {
            activeProfileId = profiles.first?.id ?? ""
        }
        saveStateToDisk()
        triggerToast("Profile deleted")
    }
    
    public func updateActiveBrowser(_ browser: String) {
        if let idx = profiles.firstIndex(where: { $0.id == activeProfileId }) {
            profiles[idx].browser = browser
            saveStateToDisk()
        }
    }
    
    public func updateActiveVirtualSpace(_ space: Int) {
        if let idx = profiles.firstIndex(where: { $0.id == activeProfileId }) {
            profiles[idx].virtualSpace = space
            saveStateToDisk()
        }
    }
    
    public func addUrlToActiveProfile(title: String, urlString: String) {
        if let idx = profiles.firstIndex(where: { $0.id == activeProfileId }) {
            profiles[idx].urls.append(WorkspaceUrlItem(title: title, urlString: urlString))
            saveStateToDisk()
            triggerToast("Added URL to \(profiles[idx].name)")
        }
    }
    
    public func removeUrlFromActiveProfile(id: UUID) {
        if let idx = profiles.firstIndex(where: { $0.id == activeProfileId }) {
            profiles[idx].urls.removeAll(where: { $0.id == id })
            saveStateToDisk()
        }
    }
    
    public func addEnvVarToActiveProfile(key: String, value: String) {
        if let idx = profiles.firstIndex(where: { $0.id == activeProfileId }) {
            profiles[idx].envVars[key] = value
            saveStateToDisk()
            triggerToast("Added ENV: \(key)")
        }
    }
    
    public func removeEnvVarFromActiveProfile(key: String) {
        if let idx = profiles.firstIndex(where: { $0.id == activeProfileId }) {
            profiles[idx].envVars.removeValue(forKey: key)
            saveStateToDisk()
        }
    }
    
    public func triggerToast(_ message: String) {
        self.toastText = message
        self.showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.showToast = false
        }
    }
    
    public func simulateRebootRecovery() {
        triggerToast("🔄 Simulating macOS Reboot... Restoring all apps & windows!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.loadStateFromDisk()
            self.triggerToast("✅ Workspaces & Apps Restored Successfully!")
        }
    }
    
    private func setupAutoSave() {
        $activeProfileId
            .dropFirst()
            .sink { [weak self] _ in self?.saveStateToDisk() }
            .store(in: &cancellables)
    }
    
    public func saveStateToDisk() {
        let snapshot = SessionSnapshot(
            activeProfileId: activeProfileId,
            activeTab: activeTab,
            launchAtLogin: launchAtLogin,
            autoRestoreOnBoot: autoRestoreOnBoot,
            keepAliveInMenuBar: keepAliveInMenuBar,
            profiles: profiles
        )
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(snapshot)
            try data.write(to: storagePath)
            self.statusMessage = "● Auto-Saved to Mac"
        } catch {
            print("Failed to save session state: \(error)")
        }
    }
    
    public func loadStateFromDisk() {
        guard let data = try? Data(contentsOf: storagePath) else { return }
        do {
            let decoder = JSONDecoder()
            let snapshot = try decoder.decode(SessionSnapshot.self, from: data)
            self.activeProfileId = snapshot.activeProfileId
            self.activeTab = snapshot.activeTab
            self.launchAtLogin = snapshot.launchAtLogin
            self.autoRestoreOnBoot = snapshot.autoRestoreOnBoot
            self.keepAliveInMenuBar = snapshot.keepAliveInMenuBar
            if !snapshot.profiles.isEmpty {
                self.profiles = snapshot.profiles
            }
        } catch {
            print("Failed to load session state: \(error)")
        }
    }
    
    private func setupPowerMonitorObservers() {
        let workspaceNotificationCenter = NSWorkspace.shared.notificationCenter
        
        workspaceNotificationCenter.addObserver(
            forName: NSWorkspace.willSleepNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            print("[SpaceSwitch Swift] Mac sleeping. Saving session snapshot...")
            self?.saveStateToDisk()
        }
        
        workspaceNotificationCenter.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            print("[SpaceSwitch Swift] Mac woke up. Restoring session state...")
            self?.loadStateFromDisk()
            self?.triggerToast("Restored workspace session after wake")
        }
    }
}

public struct SessionSnapshot: Codable {
    public var activeProfileId: String
    public var activeTab: String
    public var launchAtLogin: Bool
    public var autoRestoreOnBoot: Bool
    public var keepAliveInMenuBar: Bool
    public var profiles: [WorkspaceProfile]
}
