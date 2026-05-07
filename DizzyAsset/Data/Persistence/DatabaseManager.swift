import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let connector: SQLiteConnector
    
    private init() {
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dbFolderURL = appSupportURL.appendingPathComponent("DizzyAsset", isDirectory: true)
        
        try? fileManager.createDirectory(at: dbFolderURL, withIntermediateDirectories: true)
        
        let dbURL = dbFolderURL.appendingPathComponent("dizzyasset.sqlite")
        
        do {
            self.connector = try SQLiteConnector(path: dbURL.path)
            try setupSchema()
        } catch {
            // In a production app, we would handle this more gracefully (e.g. alert the user)
            fatalError("Failed to initialize database: \(error)")
        }
    }
    
    private func setupSchema() throws {
        // 1. Ensure migrations table exists
        try connector.execute(sql: Schema.createMigrationsTable)
        
        // 2. Check current version
        let results = try connector.query(sql: "SELECT MAX(version) as current_version FROM schema_migrations")
        let currentVersion = (results.first?["current_version"] as? Int) ?? 0
        
        // 3. Apply migrations if needed
        if currentVersion < Schema.version {
            try applyInitialSchema()
            try connector.execute(sql: "INSERT INTO schema_migrations (version) VALUES (\(Schema.version))")
        }
    }
    
    private func applyInitialSchema() throws {
        try connector.execute(sql: Schema.createAssetsTable)
        try connector.execute(sql: Schema.createAssetLocationsTable)
        try connector.execute(sql: Schema.createTagsTable)
        try connector.execute(sql: Schema.createAssetTagsTable)
        try connector.execute(sql: Schema.createCategoriesTable)
        try connector.execute(sql: Schema.createAssetCategoriesTable)
        try connector.execute(sql: Schema.createDuplicateScanSessionsTable)
        try connector.execute(sql: Schema.createAppSettingsTable)
        try connector.execute(sql: Schema.createTechnicalMetadataTable)
    }
    
    var db: SQLiteConnector {
        return connector
    }
}
