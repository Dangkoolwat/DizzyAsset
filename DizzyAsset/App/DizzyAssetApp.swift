import SwiftUI

@main
struct DizzyAssetApp: App {
    var body: some Scene {
        WindowGroup {
            MainWindowView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
    }
}
