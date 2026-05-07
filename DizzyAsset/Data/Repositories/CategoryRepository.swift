import Foundation

class CategoryRepository {
    private let db = DatabaseManager.shared.db
    
    func createCategory(name: String, parentId: Int64? = nil) throws -> Int64 {
        let parentSql = parentId != nil ? "\(parentId!)" : "NULL"
        let sql = "INSERT INTO categories (name, parent_id) VALUES ('\(name)', \(parentSql))"
        try db.execute(sql: sql)
        
        let findSql = "SELECT id FROM categories WHERE name = '\(name)' AND (parent_id = \(parentSql) OR (parent_id IS NULL AND \(parentSql) = 'NULL'))"
        let results = try db.query(sql: findSql)
        return results.first?["id"] as? Int64 ?? 0
    }
    
    func fetchAllCategories() throws -> [[String: Any]] {
        let sql = "SELECT * FROM categories ORDER BY name ASC"
        return try db.query(sql: sql)
    }
    
    func fetchSubcategories(for parentId: Int64) throws -> [[String: Any]] {
        let sql = "SELECT * FROM categories WHERE parent_id = \(parentId) ORDER BY name ASC"
        return try db.query(sql: sql)
    }
    
    func assignCategory(assetId: Int64, categoryId: Int64) throws {
        let sql = "INSERT OR REPLACE INTO asset_categories (asset_id, category_id) VALUES (\(assetId), \(categoryId))"
        try db.execute(sql: sql)
    }
    
    func removeCategoryAssignment(assetId: Int64, categoryId: Int64) throws {
        let sql = "DELETE FROM asset_categories WHERE asset_id = \(assetId) AND category_id = \(categoryId)"
        try db.execute(sql: sql)
    }
    
    func fetchAssetCategories(for assetId: Int64) throws -> [[String: Any]] {
        let sql = """
        SELECT c.* FROM categories c
        JOIN asset_categories ac ON c.id = ac.category_id
        WHERE ac.asset_id = \(assetId)
        """
        return try db.query(sql: sql)
    }
}
