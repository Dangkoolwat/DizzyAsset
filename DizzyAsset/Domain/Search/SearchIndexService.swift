import Foundation

class SearchIndexService {
    private let db = DatabaseManager.shared.db
    
    func rebuildIndex() async throws {
        // 1. Clear existing index
        try db.execute(sql: "DELETE FROM asset_search_index")
        
        // 2. Fetch all assets with their tags and categories
        // In a real implementation, we'd use a more efficient join.
        // For foundation, we'll perform an aggregation query.
        let sql = """
        SELECT 
            a.id, 
            a.filename, 
            GROUP_CONCAT(DISTINCT t.name) as tags, 
            GROUP_CONCAT(DISTINCT c.name) as categories
        FROM assets a
        LEFT JOIN asset_tags at ON a.id = at.asset_id
        LEFT JOIN tags t ON at.tag_id = t.id
        LEFT JOIN asset_categories ac ON a.id = ac.asset_id
        LEFT JOIN categories c ON ac.category_id = c.id
        GROUP BY a.id
        """
        
        let results = try db.query(sql: sql)
        
        for row in results {
            guard let id = row["id"] as? Int64,
                  let filename = row["filename"] as? String else { continue }
            
            let tags = row["tags"] as? String ?? ""
            let categories = row["categories"] as? String ?? ""
            
            // We'll handle aliases in a future update or join
            let aliases = "" 
            
            try updateIndex(assetId: id, filename: filename, tags: tags, categories: categories, aliases: aliases)
        }
    }
    
    func updateIndex(assetId: Int64, filename: String, tags: String, categories: String, aliases: String) throws {
        let escapedFilename = filename.replacingOccurrences(of: "'", with: "''")
        let escapedTags = tags.replacingOccurrences(of: "'", with: "''")
        let escapedCategories = categories.replacingOccurrences(of: "'", with: "''")
        let escapedAliases = aliases.replacingOccurrences(of: "'", with: "''")
        
        let sql = """
        INSERT OR REPLACE INTO asset_search_index (asset_id, filename, tags, categories, aliases)
        VALUES (\(assetId), '\(escapedFilename)', '\(escapedTags)', '\(escapedCategories)', '\(escapedAliases)');
        """
        try db.execute(sql: sql)
    }
    
    func removeFromIndex(assetId: Int64) throws {
        try db.execute(sql: "DELETE FROM asset_search_index WHERE asset_id = \(assetId)")
    }
}
