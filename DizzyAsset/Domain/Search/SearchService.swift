import Foundation

class SearchService {
    private let assetRepository = AssetRepository()
    
    func search(text: String) async throws -> [AssetDisplayModel] {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if query.isEmpty {
            return try await fetchAll()
        }
        
        // Use FTS5 MATCH with custom ranking
        let escapedQuery = query.replacingOccurrences(of: "'", with: "''")
        let ftsQuery = "\(escapedQuery)*"
        
        let sql = """
        SELECT DISTINCT 
            a.*, 
            al.url,
            -- bm25 returns smaller value for better matches. We negate it for DESC sorting.
            -- Weights: asset_id=0, filename=10.0, tags=3.0, categories=2.0, aliases=1.0
            (-bm25(asset_search_index, 0, 10.0, 3.0, 2.0, 1.0)) as fts_score,
            -- Exact match bonus (case-insensitive)
            CASE WHEN a.filename LIKE '\(escapedQuery)' THEN 10.0 ELSE 0.0 END as exact_bonus,
            -- Recency bonus: +1.0 if modified in the last 7 days
            CASE WHEN a.modified_at > DATETIME('now', '-7 days') THEN 1.0 ELSE 0.0 END as recency_bonus,
            -- Duplicate penalty: -1.0 if asset has duplicates (same fingerprint)
            (SELECT COUNT(*) FROM assets a2 WHERE a2.fingerprint = a.fingerprint AND a2.id != a.id) as dup_count
        FROM asset_search_index idx
        JOIN assets a ON idx.asset_id = a.id
        LEFT JOIN asset_locations al ON a.id = al.asset_id
        WHERE asset_search_index MATCH '\(ftsQuery)'
        ORDER BY (fts_score + exact_bonus + recency_bonus - (CASE WHEN dup_count > 0 THEN 1.0 ELSE 0.0 END)) DESC, 
                 a.filename ASC
        """
        
        let results = try DatabaseManager.shared.db.query(sql: sql)
        return transform(results)
    }
    
    private func fetchAll() async throws -> [AssetDisplayModel] {
        let results = try assetRepository.fetchAllAssets()
        return transform(results)
    }
    
    private func transform(_ results: [[String: Any]]) -> [AssetDisplayModel] {
        return results.compactMap { dict in
            guard let id = dict["id"] as? Int64,
                  let filename = dict["filename"] as? String,
                  let size = dict["size"] as? Int64 else { return nil }
            
            return AssetDisplayModel(
                assetId: id,
                fileURL: (dict["url"] as? String).flatMap { URL(string: $0) },
                filename: filename,
                mediaType: "media",
                sizeString: ByteCountFormatter.string(fromByteCount: size, countStyle: .file),
                durationString: nil,
                url: dict["url"] as? String
            )
        }
    }
}

// Note: AssetDisplayModel is duplicated here for service boundary. 
// In a larger refactor, it should move to a Shared Domain entity.
struct AssetDisplayModel: Identifiable {
    let assetId: Int64
    let fileURL: URL?
    let filename: String
    let mediaType: String
    let sizeString: String
    let durationString: String?
    let url: String?
    
    var id: Int64 { assetId }
}
