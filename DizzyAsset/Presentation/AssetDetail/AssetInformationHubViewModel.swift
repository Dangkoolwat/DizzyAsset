import SwiftUI
import Combine

@MainActor
class AssetInformationHubViewModel: ObservableObject {
    @Published var assetId: Int64?
    @Published var technicalMetadata: [String: String] = [:]
    @Published var tags: [String] = []
    @Published var categoryName: String = "None"
    @Published var isDuplicate: Bool = false
    @Published var isOnline: Bool = false
    
    private let assetRepository = AssetRepository()
    private let taggingService = TaggingService()
    private let categoryRepository = CategoryRepository()
    private let duplicateService = DuplicateDetectionService()
    
    func loadAssetDetails(for id: Int64) {
        self.assetId = id
        fetchTechnicalMetadata(for: id)
        fetchTags(for: id)
        fetchCategory(for: id)
        checkDuplicateStatus(for: id)
        checkOnlineStatus(for: id)
    }
    
    private func fetchTechnicalMetadata(for id: Int64) {
        // Implementation note: This should ideally come from a structured query
        // For foundation, we fetch from technical_metadata table
        do {
            let sql = "SELECT * FROM technical_metadata WHERE asset_id = \(id)"
            let results = try DatabaseManager.shared.db.query(sql: sql)
            if let first = results.first {
                technicalMetadata = [
                    "Duration": String(format: "%.2f s", first["duration"] as? Double ?? 0),
                    "Resolution": "\(first["width"] as? Int64 ?? 0) x \(first["height"] as? Int64 ?? 0)",
                    "Codec": first["codec"] as? String ?? "Unknown",
                    "Frame Rate": String(format: "%.2f fps", first["frame_rate"] as? Double ?? 0)
                ]
            } else {
                technicalMetadata = [:]
            }
        } catch {
            technicalMetadata = [:]
        }
    }
    
    private func fetchTags(for id: Int64) {
        do {
            tags = try taggingService.getTags(for: id)
        } catch {
            tags = []
        }
    }
    
    private func fetchCategory(for id: Int64) {
        do {
            let categories = try categoryRepository.fetchAssetCategories(for: id)
            categoryName = categories.first?["name"] as? String ?? "None"
        } catch {
            categoryName = "None"
        }
    }
    
    private func checkDuplicateStatus(for id: Int64) {
        // Placeholder check for DA-014 foundation
        isDuplicate = false 
    }
    
    private func checkOnlineStatus(for id: Int64) {
        do {
            let locations = try assetRepository.fetchLocations(for: id)
            if let first = locations.first, let urlString = first["url"] as? String, let url = URL(string: urlString) {
                isOnline = FileManager.default.fileExists(atPath: url.path)
            } else {
                isOnline = false
            }
        } catch {
            isOnline = false
        }
    }
}
