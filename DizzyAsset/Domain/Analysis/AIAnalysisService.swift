import Foundation

class AIAnalysisService {
    private let aiRepository = AIRepository()
    private let providers: [AIProvider] = [LocalMetadataProvider()]
    
    func analyzeAsset(assetId: Int64, filename: String, url: URL?) async {
        for provider in providers {
            guard provider.canAnalyze(assetId: assetId, filename: filename, url: url) else { continue }
            
            do {
                let result = try await provider.analyze(assetId: assetId, filename: filename, url: url)
                try aiRepository.saveAnalysisResult(result, for: assetId)
            } catch {
                print("Analysis failed for provider \(provider.identifier): \(error)")
            }
        }
    }
    
    func fetchSuggestions(for assetId: Int64) -> [String] {
        do {
            let rows = try aiRepository.fetchSuggestedTags(for: assetId)
            return rows.compactMap { $0["tag_name"] as? String }
        } catch {
            print("Failed to fetch suggestions: \(error)")
            return []
        }
    }
    
    func acceptSuggestion(assetId: Int64, tagName: String) throws {
        let taggingService = TaggingService()
        try taggingService.tagAsset(assetId: assetId, tagName: tagName)
        try aiRepository.removeSuggestedTag(assetId: assetId, tagName: tagName)
    }
    
    func rejectSuggestion(assetId: Int64, tagName: String) throws {
        try aiRepository.removeSuggestedTag(assetId: assetId, tagName: tagName)
    }
}
