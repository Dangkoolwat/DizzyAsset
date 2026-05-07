import SwiftUI

struct SidebarView: View {
    @Binding var selection: String?
    @State private var categories: [CategoryNode] = []
    private let categoryService = CategoryService()
    
    var body: some View {
        List(selection: $selection) {
            librarySection
            categorySection
        }
        .navigationTitle("DizzyAsset")
        .task {
            loadCategories()
        }
    }
    
    private var librarySection: some View {
        Section("Library") {
            Label("All Assets", systemImage: "square.grid.2x2")
                .tag("All Assets")
            Label("Recent", systemImage: "clock")
                .tag("Recent")
            Label("Favorites", systemImage: "star")
                .tag("Favorites")
        }
    }
    
    private var categorySection: some View {
        Section("Categories") {
            ForEach(categories) { node in
                categoryRow(node)
            }
        }
    }
    
    private func categoryRow(_ node: CategoryNode) -> some View {
        OutlineGroup(node, children: \.children) { item in
            Label(item.category.name, systemImage: "folder")
                .tag(item.category.name)
                .onDrop(of: [.text], isTargeted: nil) { providers in
                    guard let provider = providers.first else { return false }
                    provider.loadObject(ofClass: NSString.self) { (idString, error) in
                        guard let idString = idString as? String, let assetId = Int64(idString) else { return }
                        DispatchQueue.main.async {
                            handleDrop(assetId: assetId, categoryId: item.category.id)
                        }
                    }
                    return true
                }
        }
    }
    
    private func handleDrop(assetId: Int64, categoryId: Int64) {
        do {
            try categoryService.assignAssetToCategory(assetId: assetId, categoryId: categoryId)
        } catch {
            print("Failed to assign asset to category: \(error)")
        }
    }
    
    private func loadCategories() {
        do {
            categories = try categoryService.fetchHierarchy()
        } catch {
            print("Failed to load categories: \(error)")
        }
    }
}
