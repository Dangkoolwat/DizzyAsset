import Foundation

enum WorkspaceItemType: String {
    case temp = "temp"
    case previewCache = "previewCache"
    case analysisOutput = "analysisOutput"
    case derivedAsset = "derivedAsset"
    case exportOutput = "exportOutput"
    case proxy = "proxy"
    case unknown = "unknown"
}

enum WorkspaceItemStatus: String {
    case active = "active"
    case stale = "stale"
    case orphaned = "orphaned"
    case missingSource = "missingSource"
    case recoverable = "recoverable"
    case cleanupCandidate = "cleanupCandidate"
}

struct WorkspaceCleanupReport {
    let totalItems: Int
    let candidateCount: Int
    let totalBytes: Int64
    let items: [WorkspaceItemInfo]
}

struct WorkspaceItemInfo {
    let path: String
    let type: WorkspaceItemType
    let size: Int64
}

class WorkspaceLifecycleManager {
    private let db = DatabaseManager.shared.db
    
    func classifyItem(at path: String) -> WorkspaceItemType {
        let ws = WorkspaceManager.shared.currentWorkspace
        let url = URL(fileURLWithPath: path)
        
        if path.contains(ws.tempURL.path) { return .temp }
        if path.contains(ws.generatedURL.appendingPathComponent("Preview").path) { return .previewCache }
        if path.contains(ws.analysisURL.path) { return .analysisOutput }
        if path.contains(ws.derivedURL.path) { return .derivedAsset }
        if path.contains(ws.generatedURL.appendingPathComponent("Export").path) { return .exportOutput }
        
        return .unknown
    }
    
    func generateCleanupReport() async throws -> WorkspaceCleanupReport {
        let ws = WorkspaceManager.shared.currentWorkspace
        let fm = FileManager.default
        
        var items: [WorkspaceItemInfo] = []
        var totalBytes: Int64 = 0
        
        // Scan temp directory for cleanup candidates
        if let enumerator = fm.enumerator(at: ws.tempURL, includingPropertiesForKeys: [.fileSizeKey]) {
            for case let fileURL as URL in enumerator {
                let resourceValues = try? fileURL.resourceValues(forKeys: [.fileSizeKey])
                let size = Int64(resourceValues?.fileSize ?? 0)
                
                items.append(WorkspaceItemInfo(path: fileURL.path, type: .temp, size: size))
                totalBytes += size
            }
        }
        
        return WorkspaceCleanupReport(
            totalItems: items.count,
            candidateCount: items.count,
            totalBytes: totalBytes,
            items: items
        )
    }
    
    func registerItem(assetId: Int64?, path: String, type: WorkspaceItemType, status: WorkspaceItemStatus) throws {
        let fm = FileManager.default
        let attr = try? fm.attributesOfItem(atPath: path)
        let size = attr?[.size] as? Int64 ?? 0
        
        let assetIdValue = assetId != nil ? "\(assetId!)" : "NULL"
        let escapedPath = path.replacingOccurrences(of: "'", with: "''")
        
        let sql = """
        INSERT OR REPLACE INTO workspace_items (asset_id, file_path, item_type, status, size_bytes, updated_at)
        VALUES (\(assetIdValue), '\(escapedPath)', '\(type.rawValue)', '\(status.rawValue)', \(size), CURRENT_TIMESTAMP);
        """
        try db.execute(sql: sql)
    }
    
    func updateOrphanedStatus() async throws {
        // Logic to cross-reference workspace_items with AssetLocationStatus (from DA-021)
        // For foundation, we'll mark derivedAssets as orphaned if their source is offline.
        let sql = """
        SELECT wi.id, wi.file_path 
        FROM workspace_items wi
        JOIN asset_derivations ad ON wi.asset_id = ad.derived_asset_id
        JOIN asset_locations al ON ad.source_asset_id = al.asset_id
        WHERE al.status IN ('volumeOffline', 'missing', 'permissionDenied')
        """
        
        let results = try db.query(sql: sql)
        for row in results {
            if let id = row["id"] as? Int64 {
                try db.execute(sql: "UPDATE workspace_items SET status = 'orphaned' WHERE id = \(id)")
            }
        }
    }
}
