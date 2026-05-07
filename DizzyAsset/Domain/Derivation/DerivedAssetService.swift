import Foundation

enum DerivationType: String {
    case silenceTrim = "silenceTrim"
    case normalizedVolume = "normalizedVolume"
    case convertedFormat = "convertedFormat"
    case proxy = "proxy"
    case preview = "preview"
    case export = "export"
}

enum DerivationStatus: String {
    case active = "active"
    case orphaned = "orphaned"
    case missingSource = "missingSource"
    case recoverable = "recoverable"
    case missingFile = "missingFile"
}

struct AssetDerivation {
    let id: Int64
    let sourceAssetId: Int64
    let derivedAssetId: Int64?
    let derivationType: DerivationType
    let derivedFilePath: String?
    let status: DerivationStatus
    let createdAt: Date
}

class DerivedAssetService {
    private let db = DatabaseManager.shared.db
    
    func createDerivation(sourceId: Int64, 
                         derivedId: Int64? = nil, 
                         type: DerivationType, 
                         path: String? = nil) throws -> Int64 {
        let sql = """
        INSERT INTO asset_derivations (source_asset_id, derived_asset_id, derivation_type, derived_file_path, status)
        VALUES (\(sourceId), \(derivedId != nil ? String(derivedId!) : "NULL"), '\(type.rawValue)', \(path != nil ? "'\(path!.replacingOccurrences(of: "'", with: "''"))'" : "NULL"), 'active');
        """
        try db.execute(sql: sql)
        return db.lastInsertId()
    }
    
    func fetchDerivations(for sourceId: Int64) throws -> [AssetDerivation] {
        let sql = "SELECT * FROM asset_derivations WHERE source_asset_id = \(sourceId)"
        let results = try db.query(sql: sql)
        return try results.map { try mapToDerivation($0) }
    }
    
    func fetchSource(for derivedId: Int64) throws -> AssetDerivation? {
        let sql = "SELECT * FROM asset_derivations WHERE derived_asset_id = \(derivedId) LIMIT 1"
        let results = try db.query(sql: sql)
        guard let first = results.first else { return nil }
        return try mapToDerivation(first)
    }
    
    private func mapToDerivation(_ dict: [String: Any]) throws -> AssetDerivation {
        guard let id = dict["id"] as? Int64,
              let sourceId = dict["source_asset_id"] as? Int64,
              let typeString = dict["derivation_type"] as? String,
              let type = DerivationType(rawValue: typeString),
              let statusString = dict["status"] as? String,
              let status = DerivationStatus(rawValue: statusString) else {
            throw DatabaseError.mappingFailed
        }
        
        let createdAt: Date
        if let timeString = dict["created_at"] as? String {
            // SQLite default format: YYYY-MM-DD HH:MM:SS
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            createdAt = formatter.date(from: timeString) ?? Date()
        } else {
            createdAt = Date()
        }
        
        return AssetDerivation(
            id: id,
            sourceAssetId: sourceId,
            derivedAssetId: dict["derived_asset_id"] as? Int64,
            derivationType: type,
            derivedFilePath: dict["derived_file_path"] as? String,
            status: status,
            createdAt: createdAt
        )
    }
}

enum DatabaseError: Error {
    case mappingFailed
}
