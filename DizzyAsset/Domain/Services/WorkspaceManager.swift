import Foundation

class WorkspaceManager {
    static let shared = WorkspaceManager()
    
    let currentWorkspace: Workspace
    
    private init() {
        // TODO: In DA-019/DA-022, load custom workspace location if set.
        self.currentWorkspace = Workspace.default
    }
    
    func initialize() throws {
        let fm = FileManager.default
        let ws = currentWorkspace
        
        let internalDirs = [
            ws.internalURL,
            ws.databaseURL,
            ws.settingsURL,
            ws.indexURL,
            ws.bookmarksURL,
            ws.aiAnalysisURL
        ]
        
        let workspaceDirs = [
            ws.rootURL,
            ws.derivedURL,
            ws.derivedURL.appendingPathComponent("Trimmed"),
            ws.derivedURL.appendingPathComponent("Converted"),
            ws.derivedURL.appendingPathComponent("Proxy"),
            ws.generatedURL,
            ws.generatedURL.appendingPathComponent("Preview"),
            ws.generatedURL.appendingPathComponent("Export"),
            ws.analysisURL,
            ws.analysisURL.appendingPathComponent("Waveforms"),
            ws.analysisURL.appendingPathComponent("Speech"),
            ws.analysisURL.appendingPathComponent("Vision"),
            ws.tempURL
        ]
        
        // Create internal directories
        for url in internalDirs {
            try createDirectoryIfNeeded(at: url)
        }
        
        // Create workspace directories
        for url in workspaceDirs {
            try createDirectoryIfNeeded(at: url)
        }
        
        // Persist workspace root in settings
        try saveWorkspaceRoot(ws.rootURL.path)
        
        // Initial search index build
        Task {
            try? await SearchIndexService().rebuildIndex()
        }
    }
    
    private func createDirectoryIfNeeded(at url: URL) throws {
        let fm = FileManager.default
        if !fm.fileExists(atPath: url.path) {
            try fm.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
    
    private func saveWorkspaceRoot(_ path: String) throws {
        let sql = """
        INSERT OR REPLACE INTO app_settings (key, value, updated_at)
        VALUES ('workspace_root', '\(path)', CURRENT_TIMESTAMP);
        """
        try DatabaseManager.shared.db.execute(sql: sql)
    }
}
