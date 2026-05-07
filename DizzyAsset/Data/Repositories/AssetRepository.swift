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
        let sql = """
        SELECT a.*, al.url 
        FROM assets a
        LEFT JOIN asset_locations al ON a.id = al.asset_id
        """
        return try db.query(sql: sql)
    }
    
    func findAssetByPath(_ path: String) throws -> Int64? {
        let sql = "SELECT asset_id FROM asset_locations WHERE url = '\(path.replacingOccurrences(of: "'", with: "''"))' LIMIT 1"
        let results = try db.query(sql: sql)
        return results.first?["asset_id"] as? Int64
    }
    
    func findAssetsBySize(_ size: Int64) throws -> [Int64] {
        let sql = "SELECT id FROM assets WHERE size = \(size)"
        let results = try db.query(sql: sql)
        return results.compactMap { $0["id"] as? Int64 }
    }
    
    func updateFingerprint(assetId: Int64, fingerprint: String) throws {
        let sql = "UPDATE assets SET fingerprint = '\(fingerprint)' WHERE id = \(assetId)"
        try db.execute(sql: sql)
    }
    
    func saveTechnicalMetadata(assetId: Int64, metadata: AssetMetadata) throws {
        let sql = """
        INSERT OR REPLACE INTO technical_metadata (asset_id, duration, width, height, codec, frame_rate)
        VALUES (
            \(assetId), 
            \(metadata.duration ?? 0), 
            \(metadata.width ?? 0), 
            \(metadata.height ?? 0), 
            '\(metadata.codec ?? "")', 
            \(metadata.frameRate ?? 0)
        );
        """
        try db.execute(sql: sql)
    }
    
    func fetchLocations(for assetId: Int64) throws -> [[String: Any]] {
        let sql = "SELECT * FROM asset_locations WHERE asset_id = \(assetId)"
        return try db.query(sql: sql)
    }
    
    func searchAssets(query: String) throws -> [[String: Any]] {
        let escapedQuery = query.replacingOccurrences(of: "'", with: "''")
        let sql = """
        SELECT DISTINCT a.*, al.url FROM assets a
        LEFT JOIN asset_locations al ON a.id = al.asset_id
        LEFT JOIN asset_tags at ON a.id = at.asset_id
        LEFT JOIN tags t ON at.tag_id = t.id
        LEFT JOIN asset_categories ac ON a.id = ac.asset_id
        LEFT JOIN categories c ON ac.category_id = c.id
        WHERE a.filename LIKE '%\(escapedQuery)%'
           OR t.name LIKE '%\(escapedQuery)%'
           OR c.name LIKE '%\(escapedQuery)%'
        ORDER BY a.filename ASC
        """
        return try db.query(sql: sql)
    }
}
