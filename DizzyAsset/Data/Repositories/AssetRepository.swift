import Foundation

class AssetRepository {
    private let db = DatabaseManager.shared.db
    
    func saveImportCandidate(_ candidate: ImportCandidate, bookmarkData: Data?) throws -> Int64 {
        // 1. Insert into assets table
        // Note: Using ? for parameters to avoid SQL injection and handle blobs
        // SQLiteConnector needs to support parameters. For now, using formatted SQL for strings/ints.
        
        let insertAssetSQL = """
        INSERT INTO assets (filename, size, modified_at)
        VALUES ('\(candidate.filename.replacingOccurrences(of: "'", with: "''"))', \(candidate.fileSize), '\(candidate.modifiedAt.timeIntervalSince1970)');
        """
        try db.execute(sql: insertAssetSQL)
        let assetId = db.lastInsertId()
        
        // 2. Insert into asset_locations table
        // status is 'available' by default for new imports
        let insertLocationSQL = """
        INSERT INTO asset_locations (asset_id, url, status)
        VALUES (\(assetId), '\(candidate.url.path.replacingOccurrences(of: "'", with: "''"))', 'available');
        """
        try db.execute(sql: insertLocationSQL)
        
        // TODO: Handle bookmark_data blob in SQLiteConnector in a future refactor
        
        return assetId
    }
    
    func fetchAllAssets() throws -> [[String: Any]] {
        return try db.query(sql: "SELECT * FROM assets")
    }
}
