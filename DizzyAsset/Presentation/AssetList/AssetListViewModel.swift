import SwiftUI
import Combine

@MainActor
class AssetListViewModel: ObservableObject {
    @Published var assets: [AssetDisplayModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                Task { await refreshAssets() }
            }
        }
    }
    
    private let searchService = SearchService()
    
    func refreshAssets() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.assets = try await searchService.search(text: searchText)
        } catch {
            print("Failed to fetch assets: \(error)")
        }
    }
}
