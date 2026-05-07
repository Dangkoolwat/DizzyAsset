import Foundation

class SettingsRepository {
    private let db = DatabaseManager.shared.db
    
    func setSetting(key: String, value: String) throws {
        let escapedValue = value.replacingOccurrences(of: "'", with: "''")
        let sql = """
        INSERT OR REPLACE INTO app_settings (key, value, updated_at)
        VALUES ('\(key)', '\(escapedValue)', CURRENT_TIMESTAMP);
        """
        try db.execute(sql: sql)
    }
    
    func getSetting(key: String) throws -> String? {
        let sql = "SELECT value FROM app_settings WHERE key = '\(key)'"
        let results = try db.query(sql: sql)
        return results.first?["value"] as? String
    }
    
    func getAllSettings() throws -> [String: String] {
        let sql = "SELECT key, value FROM app_settings"
        let results = try db.query(sql: sql)
        var settings: [String: String] = [:]
        for row in results {
            if let key = row["key"] as? String, let value = row["value"] as? String {
                settings[key] = value
            }
        }
        return settings
    }
}
