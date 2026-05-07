import SwiftUI

@main
struct DizzyAssetApp: App {
    init() {
        // Initialize Core Systems
        _ = DatabaseManager.shared
        try? WorkspaceManager.shared.initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            MainWindowView()
        }
        .commands {
            SidebarCommands()
            CommandGroup(replacing: .newItem) { } // Disable New Item for now
            
            CommandMenu("Quick Peek") {
                Button("Open Quick Peek") {
                    QuickPeekManager.shared.show()
                }
                .keyboardShortcut("p", modifiers: .command)
            }
        }
        
        Settings {
            SettingsView()
        }
    }
}
