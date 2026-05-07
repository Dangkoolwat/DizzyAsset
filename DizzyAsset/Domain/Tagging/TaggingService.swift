import Foundation

struct Tag: Identifiable, Equatable {
    let id: Int64
    let name: String
}

class TaggingService {
    private let repository = TagRepository()
    
    /// Normalizes and assigns a tag to an asset
    func tagAsset(assetId: Int64, tagName: String) throws {
        let tagId = try repository.findOrCreateTag(name: tagName)
        try repository.assignTag(assetId: assetId, tagId: tagId)
    }
    
    func removeTag(assetId: Int64, tagName: String) throws {
        let tagId = try repository.findOrCreateTag(name: tagName)
        try repository.removeTag(assetId: assetId, tagId: tagId)
    }
    
    func getTags(for assetId: Int64) throws -> [String] {
        return try repository.fetchTags(for: assetId)
    }
    
    /// Seed common editor-language tags
    func seedEditorTags() throws {
        let seeds = [
            "예능", "긴장", "타격", "Impact", "전환", "Transition",
            "쇼츠", "Shorts", "실패", "Fail", "리액션", "Reaction", "밈", "Meme"
        ]
        for tag in seeds {
            _ = try repository.findOrCreateTag(name: tag)
        }
    }
    
    func batchTagAssets(assetIds: [Int64], tagName: String) throws {
        let db = DatabaseManager.shared.db
        try db.beginTransaction()
        do {
            let tagId = try repository.findOrCreateTag(name: tagName)
            for id in assetIds {
                try repository.assignTag(assetId: id, tagId: tagId)
            }
            try db.commitTransaction()
        } catch {
            try? db.rollbackTransaction()
            throw error
        }
    }
    
    func batchRemoveTag(assetIds: [Int64], tagName: String) throws {
        let db = DatabaseManager.shared.db
        try db.beginTransaction()
        do {
            let tagId = try repository.findOrCreateTag(name: tagName)
            for id in assetIds {
                try repository.removeTag(assetId: id, tagId: tagId)
            }
            try db.commitTransaction()
        } catch {
            try? db.rollbackTransaction()
            throw error
        }
    }
}
