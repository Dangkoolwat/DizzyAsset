import Foundation

struct AssetRecord {
    let filename: String
    let size: Int64
    let modifiedAt: Date
}

class AssetRepository {
    private let db = DatabaseManager.shared.db
    
    func insertAsset(_ record: AssetRecord) throws -> Int64 {
        let sql = """
        INSERT INTO assets (filename, size, modified_at)
        VALUES ('\(record.filename)', \(record.size), '\(record.modifiedAt.timeIntervalSince1970)');
        """
        try db.execute(sql: sql)
        return db.lastInsertId()
    }
    
    func fetchAllAssets() throws -> [[String: Any]] {
        return try db.query(sql: "SELECT * FROM assets")
    }
}
