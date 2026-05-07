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
