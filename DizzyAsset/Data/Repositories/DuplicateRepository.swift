import Foundation

class DuplicateRepository {
    private let db = DatabaseManager.shared.db
    
    func startScanSession() throws -> Int64 {
        let sql = "INSERT INTO duplicate_scan_sessions (status) VALUES ('running');"
        try db.execute(sql: sql)
        return db.lastInsertId()
    }
    
    func completeScanSession(id: Int64, summary: String) throws {
        let sql = """
        UPDATE duplicate_scan_sessions 
        SET status = 'completed', completed_at = CURRENT_TIMESTAMP, summary = '\(summary.replacingOccurrences(of: "'", with: "''"))'
        WHERE id = \(id);
        """
        try db.execute(sql: sql)
    }
    
    func failScanSession(id: Int64, error: String) throws {
        let sql = """
        UPDATE duplicate_scan_sessions 
        SET status = 'failed', completed_at = CURRENT_TIMESTAMP, summary = '\(error.replacingOccurrences(of: "'", with: "''"))'
        WHERE id = \(id);
        """
        try db.execute(sql: sql)
    }
}
