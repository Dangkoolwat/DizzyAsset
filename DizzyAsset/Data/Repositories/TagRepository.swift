import Foundation

class TagRepository {
    private let db = DatabaseManager.shared.db
    
    func findOrCreateTag(name: String) throws -> Int64 {
        let normalized = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Try to find existing
        let findSql = "SELECT id FROM tags WHERE name = '\(normalized)'"
        let results = try db.query(sql: findSql)
        if let id = results.first?["id"] as? Int64 {
            return id
        }
        
        // Create new
        let insertSql = "INSERT INTO tags (name) VALUES ('\(normalized)')"
        try db.execute(sql: insertSql)
        return try findOrCreateTag(name: normalized)
    }
    
    func assignTag(assetId: Int64, tagId: Int64) throws {
        let sql = "INSERT OR IGNORE INTO asset_tags (asset_id, tag_id) VALUES (\(assetId), \(tagId))"
        try db.execute(sql: sql)
    }
    
    func removeTag(assetId: Int64, tagId: Int64) throws {
        let sql = "DELETE FROM asset_tags WHERE asset_id = \(assetId) AND tag_id = \(tagId)"
        try db.execute(sql: sql)
    }
    
    func fetchTags(for assetId: Int64) throws -> [String] {
        let sql = """
        SELECT t.name FROM tags t
        JOIN asset_tags at ON t.id = at.tag_id
        WHERE at.asset_id = \(assetId)
        ORDER BY t.name ASC
        """
        let results = try db.query(sql: sql)
        return results.compactMap { $0["name"] as? String }
    }
    
    func fetchAllTags() throws -> [String] {
        let sql = "SELECT name FROM tags ORDER BY name ASC"
        let results = try db.query(sql: sql)
        return results.compactMap { $0["name"] as? String }
    }
}
