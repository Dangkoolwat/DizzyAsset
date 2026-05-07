import Foundation

class SearchService {
    private let assetRepository = AssetRepository()
    
    func search(text: String) async throws -> [AssetDisplayModel] {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if query.isEmpty {
            return try await fetchAll()
        }
        
        // Use FTS5 MATCH for high performance search
        // We add * to support prefix matching (e.g. "vid" matches "video")
        let escapedQuery = query.replacingOccurrences(of: "'", with: "''")
        let ftsQuery = "\(escapedQuery)*"
        
        let sql = """
        SELECT DISTINCT a.*, al.url 
        FROM asset_search_index idx
        JOIN assets a ON idx.asset_id = a.id
        LEFT JOIN asset_locations al ON a.id = al.asset_id
        WHERE asset_search_index MATCH '\(ftsQuery)'
        ORDER BY rank, a.filename ASC
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
