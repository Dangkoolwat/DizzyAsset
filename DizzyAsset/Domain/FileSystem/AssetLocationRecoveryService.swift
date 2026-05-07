import Foundation

enum AssetLocationStatus: String {
    case available = "available"
    case resolving = "resolving"
    case missing = "missing"
    case volumeOffline = "volumeOffline"
    case permissionDenied = "permissionDenied"
    case staleBookmark = "staleBookmark"
    case recoverable = "recoverable"
}

class AssetLocationRecoveryService {
    private let db = DatabaseManager.shared.db
    private let bookmarkManager = BookmarkManager.shared
    
    func recoverAll() async throws {
        let locations = try fetchAllLocations()
        
        for location in locations {
            guard let id = location["id"] as? Int64,
                  let bookmarkData = location["bookmark_data"] as? Data else { continue }
            
            let result = bookmarkManager.resolveBookmark(data: bookmarkData)
            let status = mapToStatus(result)
            
            try updateStatus(locationId: id, status: status)
        }
    }
    
    func recoverAsset(assetId: Int64) async throws {
        let sql = "SELECT * FROM asset_locations WHERE asset_id = \(assetId)"
        let locations = try db.query(sql: sql)
        
        for location in locations {
            guard let id = location["id"] as? Int64,
                  let bookmarkData = location["bookmark_data"] as? Data else { continue }
            
            let result = bookmarkManager.resolveBookmark(data: bookmarkData)
            let status = mapToStatus(result)
            
            try updateStatus(locationId: id, status: status)
        }
    }
    
    private func fetchAllLocations() throws -> [[String: Any]] {
        return try db.query(sql: "SELECT id, bookmark_data FROM asset_locations")
    }
    
    private func updateStatus(locationId: Int64, status: AssetLocationStatus) throws {
        let sql = "UPDATE asset_locations SET status = '\(status.rawValue)', last_seen_at = CURRENT_TIMESTAMP WHERE id = \(locationId)"
        try db.execute(sql: sql)
    }
    
    private func mapToStatus(_ result: BookmarkResolutionResult) -> AssetLocationStatus {
        if let error = result.error {
            switch error {
            case .stale: return .staleBookmark
            case .volumeOffline: return .volumeOffline
            case .permissionDenied: return .permissionDenied
            case .missingFile: return .missing
            case .unknown: return .recoverable
            }
        }
        
        if result.isStale {
            return .staleBookmark
        }
        
        return .available
    }
}
