import SwiftUI

@main
struct DizzyAssetApp: App {
    init() {
        // Initialize Core Systems
        _ = DatabaseManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            MainWindowView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
    }
}
