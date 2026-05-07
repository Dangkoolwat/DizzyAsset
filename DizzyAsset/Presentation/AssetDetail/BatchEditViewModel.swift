import SwiftUI
import Combine

struct CategoryInfo: Identifiable, Hashable {
    let id: Int64
    let name: String
}

@MainActor
class BatchEditViewModel: ObservableObject {
    @Published var selectedIds: [Int64] = []
    @Published var newTagName: String = ""
    @Published var allTags: [String] = []
    @Published var categories: [CategoryInfo] = []
    @Published var selectedCategoryId: Int64?
    
    private let taggingService = TaggingService()
    private let categoryRepository = CategoryRepository()
    private let assetRepository = AssetRepository()
    
    func setup(ids: Set<Int64>) {
        self.selectedIds = Array(ids)
        loadAvailableData()
    }
    
    func loadAvailableData() {
        do {
            self.allTags = try TagRepository().fetchAllTags()
            let rawCats = try categoryRepository.fetchAllCategories()
            self.categories = rawCats.compactMap { dict in
                guard let id = dict["id"] as? Int64, let name = dict["name"] as? String else { return nil }
                return CategoryInfo(id: id, name: name)
            }
        } catch {
            print("Failed to load batch edit data: \(error)")
        }
    }
    
    func addTagToAll() {
        guard !newTagName.isEmpty else { return }
        do {
            try taggingService.batchTagAssets(assetIds: selectedIds, tagName: newTagName)
            newTagName = ""
            // Notify UI to refresh (handled via State in real app, here we just finish)
        } catch {
            print("Batch tagging failed: \(error)")
        }
    }
    
    func removeTagFromAll(tagName: String) {
        do {
            try taggingService.batchRemoveTag(assetIds: selectedIds, tagName: tagName)
        } catch {
            print("Batch tag removal failed: \(error)")
        }
    }
    
    func applyCategoryToAll() {
        guard let catId = selectedCategoryId else { return }
        do {
            try categoryRepository.batchAssignCategory(assetIds: selectedIds, categoryId: catId)
        } catch {
            print("Batch category assignment failed: \(error)")
        }
    }
    
    func clearCategoriesFromAll() {
        do {
            try categoryRepository.batchClearCategories(assetIds: selectedIds)
        } catch {
            print("Batch category clearing failed: \(error)")
        }
    }
}
