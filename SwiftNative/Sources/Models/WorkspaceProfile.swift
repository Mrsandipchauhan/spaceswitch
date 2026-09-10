import Foundation

public struct WorkspaceUrlItem: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var title: String
    public var urlString: String
    public var iconName: String
    
    public init(id: UUID = UUID(), title: String, urlString: String, iconName: String = "globe") {
        self.id = id
        self.title = title
        self.urlString = urlString
        self.iconName = iconName
    }
}

public struct AppDeeplinkItem: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    public var name: String
    public var bundleIdentifier: String
    public var urlScheme: String
    public var shortcut: String
    public var isPinnedToMenuBar: Bool
    
    public init(id: UUID = UUID(), name: String, bundleIdentifier: String, urlScheme: String, shortcut: String, isPinnedToMenuBar: Bool = true) {
        self.id = id
        self.name = name
        self.bundleIdentifier = bundleIdentifier
        self.urlScheme = urlScheme
        self.shortcut = shortcut
        self.isPinnedToMenuBar = isPinnedToMenuBar
    }
}

public struct WorkspaceProfile: Identifiable, Codable, Hashable {
    public var id: String
    public var name: String
    public var colorHex: String
    public var browser: String
    public var hotkey: String
    public var virtualSpace: Int
    public var sfSymbolIcon: String
    public var urls: [WorkspaceUrlItem]
    public var deeplinks: [AppDeeplinkItem]
    public var envVars: [String: String]
    public var isMenuVisible: Bool
    
    public init(
        id: String,
        name: String,
        colorHex: String,
        browser: String,
        hotkey: String,
        virtualSpace: Int,
        sfSymbolIcon: String,
        urls: [WorkspaceUrlItem] = [],
        deeplinks: [AppDeeplinkItem] = [],
        envVars: [String: String] = [:],
        isMenuVisible: Bool = true
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.browser = browser
        self.hotkey = hotkey
        self.virtualSpace = virtualSpace
        self.sfSymbolIcon = sfSymbolIcon
        self.urls = urls
        self.deeplinks = deeplinks
        self.envVars = envVars
        self.isMenuVisible = isMenuVisible
    }
    
    public static var defaults: [WorkspaceProfile] {
        [
            WorkspaceProfile(
                id: "work",
                name: "Workspace_1",
                colorHex: "#E9407A",
                browser: "Google Chrome",
                hotkey: "⌃⇧4",
                virtualSpace: 2,
                sfSymbolIcon: "briefcase.fill",
                urls: [
                    WorkspaceUrlItem(title: "Figma App Wireframes", urlString: "https://figma.com/file/space1"),
                    WorkspaceUrlItem(title: "Linear Issues Board", urlString: "https://linear.app/team/space1"),
                    WorkspaceUrlItem(title: "GitHub Repository", urlString: "https://github.com/org/repo")
                ],
                deeplinks: [
                    AppDeeplinkItem(name: "Spotify Playlist", bundleIdentifier: "com.spotify.client", urlScheme: "spotify:playlist/37i9dQZF1DXcBWIGoYBM5M", shortcut: "⌘⇧P")
                ],
                envVars: ["NODE_ENV": "development", "PORT": "8082", "API_KEY": "sk_test_9921"]
            ),
            WorkspaceProfile(
                id: "personal",
                name: "Personal",
                colorHex: "#007AFF",
                browser: "Brave Browser",
                hotkey: "⌘⇧2",
                virtualSpace: 1,
                sfSymbolIcon: "house.fill",
                urls: [
                    WorkspaceUrlItem(title: "YouTube Music", urlString: "https://music.youtube.com"),
                    WorkspaceUrlItem(title: "Reddit Feed", urlString: "https://reddit.com")
                ]
            ),
            WorkspaceProfile(
                id: "design",
                name: "Design Studio",
                colorHex: "#AF52DE",
                browser: "Arc Browser",
                hotkey: "⌃⇧3",
                virtualSpace: 3,
                sfSymbolIcon: "paintbrush.fill",
                urls: [
                    WorkspaceUrlItem(title: "Dribbble Daily", urlString: "https://dribbble.com"),
                    WorkspaceUrlItem(title: "Pinterest Board", urlString: "https://pinterest.com")
                ]
            ),
            WorkspaceProfile(
                id: "devops",
                name: "DevOps & Infra",
                colorHex: "#30B0C7",
                browser: "Firefox",
                hotkey: "⌃⇧5",
                virtualSpace: 2,
                sfSymbolIcon: "terminal.fill",
                urls: [
                    WorkspaceUrlItem(title: "AWS Management Console", urlString: "https://aws.amazon.com/console"),
                    WorkspaceUrlItem(title: "Datadog Dashboards", urlString: "https://datadoghq.com")
                ]
            ),
            WorkspaceProfile(
                id: "email",
                name: "Email & Admin",
                colorHex: "#FF9500",
                browser: "Google Chrome",
                hotkey: "⌃⇧6",
                virtualSpace: 4,
                sfSymbolIcon: "envelope.fill",
                urls: [
                    WorkspaceUrlItem(title: "Gmail Inbox", urlString: "https://mail.google.com"),
                    WorkspaceUrlItem(title: "Notion Workspace", urlString: "https://notion.so")
                ]
            )
        ]
    }
}
