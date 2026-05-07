import SwiftUI
import Combine

@MainActor
class QuickPeekViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [AssetDisplayModel] = []
    @Published var selectedIndex: Int = 0
    @Published var isLoading: Bool = false
    
    private let searchService = SearchService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                Task {
                    await self?.performSearch(text: text)
                }
            }
            .store(in: &cancellables)
    }
    
    func performSearch(text: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            results = try await searchService.search(text: text)
            selectedIndex = 0
        } catch {
            print("Quick Peek Search failed: \(error)")
            results = []
        }
    }
    
    func moveSelection(down: Bool) {
        guard !results.isEmpty else { return }
        if down {
            selectedIndex = min(selectedIndex + 1, results.count - 1)
        } else {
            selectedIndex = max(selectedIndex - 1, 0)
        }
    }
    
    var selectedAsset: AssetDisplayModel? {
        guard !results.isEmpty, selectedIndex < results.count else { return nil }
        return results[selectedIndex]
    }
}
