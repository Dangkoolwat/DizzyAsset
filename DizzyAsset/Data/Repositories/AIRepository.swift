import Foundation

class AIRepository {
    private let db = DatabaseManager.shared.db
    
    func saveAnalysisResult(_ result: AnalysisResult, for assetId: Int64) throws {
        let sql = """
        INSERT OR REPLACE INTO asset_ai_results (
            asset_id, provider_id, provider_version, raw_json, normalized_json, confidence, status
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
        """
        
        var normalizedJson: String?
        if let data = try? JSONEncoder().encode(result.normalizedTags) {
            normalizedJson = String(data: data, encoding: .utf8)
        }
        
        try db.execute(sql: sql, parameters: [
            assetId,
            result.providerId,
            result.providerVersion,
            result.rawJson ?? NSNull(),
            normalizedJson ?? NSNull(),
            result.confidence,
            result.status.rawValue
        ])
        
        // Also save to suggested_tags
        try saveSuggestedTags(result.normalizedTags, for: assetId, source: result.providerId, confidence: result.confidence)
    }
    
    func saveSuggestedTags(_ tags: [String], for assetId: Int64, source: String, confidence: Double) throws {
        // Clear old suggestions for this source
        try db.execute(sql: "DELETE FROM suggested_tags WHERE asset_id = ? AND source = ?", parameters: [assetId, source])
        
        let sql = "INSERT INTO suggested_tags (asset_id, tag_name, confidence, source) VALUES (?, ?, ?, ?)"
        for tag in tags {
            try db.execute(sql: sql, parameters: [assetId, tag, confidence, source])
        }
    }
    
    func fetchSuggestedTags(for assetId: Int64) throws -> [[String: Any]] {
        return try db.query(sql: "SELECT * FROM suggested_tags WHERE asset_id = ?", parameters: [assetId])
    }
    
    func removeSuggestedTag(assetId: Int64, tagName: String) throws {
        try db.execute(sql: "DELETE FROM suggested_tags WHERE asset_id = ? AND tag_name = ?", parameters: [assetId, tagName])
    }
}
