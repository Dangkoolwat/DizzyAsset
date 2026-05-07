import Foundation

struct Category: Identifiable, Equatable {
    let id: Int64
    let name: String
    let parentId: Int64?
}

class CategoryService {
    private let repository = CategoryRepository()
    
    enum CategoryError: Error {
        case maxDepthExceeded
        case duplicateName
    }
    
    func createCategory(name: String, parentId: Int64?) throws -> Int64 {
        if let pid = parentId {
            let depth = try calculateDepth(for: pid)
            if depth >= 3 {
                throw CategoryError.maxDepthExceeded
            }
        }
        return try repository.createCategory(name: name, parentId: parentId)
    }
    
    func assignAssetToCategory(assetId: Int64, categoryId: Int64) throws {
        try repository.assignCategory(assetId: assetId, categoryId: categoryId)
    }
    
    func fetchHierarchy() throws -> [CategoryNode] {
        let allRaw = try repository.fetchAllCategories()
        let all = allRaw.compactMap { dict -> Category? in
            guard let id = dict["id"] as? Int64,
                  let name = dict["name"] as? String else { return nil }
            return Category(id: id, name: name, parentId: dict["parent_id"] as? Int64)
        }
        
        return buildTree(categories: all, parentId: nil) ?? []
    }
    
    private func calculateDepth(for categoryId: Int64) throws -> Int {
        let allRaw = try repository.fetchAllCategories()
        var currentId = categoryId
        var depth = 1
        
        while let parentId = allRaw.first(where: { ($0["id"] as? Int64) == currentId })?["parent_id"] as? Int64 {
            depth += 1
            currentId = parentId
            if depth > 10 { break } // Safety break
        }
        
        return depth
    }
    
    private func buildTree(categories: [Category], parentId: Int64?) -> [CategoryNode]? {
        let filtered = categories.filter { $0.parentId == parentId }
        if filtered.isEmpty { return nil }
        
        return filtered.map { CategoryNode(category: $0, children: buildTree(categories: categories, parentId: $0.id)) }
    }
}

struct CategoryNode: Identifiable {
    let category: Category
    let children: [CategoryNode]?
    var id: Int64 { category.id }
}
