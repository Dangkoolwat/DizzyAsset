import Foundation

struct Workspace {
    let rootURL: URL
    let internalURL: URL
    
    static var `default`: Workspace {
        let fileManager = FileManager.default
        
        // Workspace: ~/DizzyAsset/
        let homeURL = fileManager.homeDirectoryForCurrentUser
        let workspaceURL = homeURL.appendingPathComponent("DizzyAsset", isDirectory: true)
        
        // Internal: ~/Library/Application Support/DizzyAsset/
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let internalRootURL = appSupportURL.appendingPathComponent("DizzyAsset", isDirectory: true)
        
        return Workspace(rootURL: workspaceURL, internalURL: internalRootURL)
    }
    
    // Workspace Subdirectories
    var derivedURL: URL { rootURL.appendingPathComponent("Derived", isDirectory: true) }
    var generatedURL: URL { rootURL.appendingPathComponent("Generated", isDirectory: true) }
    var analysisURL: URL { rootURL.appendingPathComponent("Analysis", isDirectory: true) }
    var tempURL: URL { rootURL.appendingPathComponent("Temp", isDirectory: true) }
    
    // Internal Subdirectories
    var databaseURL: URL { internalURL.appendingPathComponent("Database", isDirectory: true) }
    var settingsURL: URL { internalURL.appendingPathComponent("Settings", isDirectory: true) }
    var indexURL: URL { internalURL.appendingPathComponent("Index", isDirectory: true) }
    var bookmarksURL: URL { internalURL.appendingPathComponent("Bookmarks", isDirectory: true) }
    var aiAnalysisURL: URL { internalURL.appendingPathComponent("AIAnalysis", isDirectory: true) }
}
