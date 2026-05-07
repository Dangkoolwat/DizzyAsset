import SwiftUI
import Combine

@MainActor
class AssetListViewModel: ObservableObject {
    @Published var assets: [AssetDisplayModel] = []
    @Published var selectedAssetId: Int64?
    @Published var isLoading: Bool = false
    
    private let assetRepository = AssetRepository()
    
    struct AssetDisplayModel: Identifiable {
        let id: Int64
        let filename: String
        let mediaType: String
        let sizeString: String
        let durationString: String?
    }
    
    func refreshAssets() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let rawAssets = try assetRepository.fetchAllAssets()
            self.assets = rawAssets.compactMap { dict in
                guard let id = dict["id"] as? Int64,
                      let filename = dict["filename"] as? String,
                      let size = dict["size"] as? Int64 else { return nil }
                
                return AssetDisplayModel(
                    id: id,
                    filename: filename,
                    mediaType: "media", // Placeholder for extension-based type
                    sizeString: ByteCountFormatter.string(fromByteCount: size, countStyle: .file),
                    durationString: nil // Placeholder until technical_metadata join is implemented
                )
            }
        } catch {
            print("Failed to fetch assets: \(error)")
        }
    }
}
