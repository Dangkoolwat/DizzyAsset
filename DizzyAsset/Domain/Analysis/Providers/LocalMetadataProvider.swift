import Foundation

class LocalMetadataProvider: AIProvider {
    let identifier = "com.dangkoolwat.analyzer.local_metadata"
    let version = "1.0.0"
    
    func canAnalyze(assetId: Int64, filename: String, url: URL?) -> Bool {
        return true // Can always analyze filename
    }
    
    func analyze(assetId: Int64, filename: String, url: URL?) async throws -> AnalysisResult {
        // Simple filename parsing
        let stem = (filename as NSString).deletingPathExtension
        let components = stem.components(separatedBy: CharacterSet(charactersIn: "_- ."))
        
        var suggestedTags: [String] = []
        
        for component in components {
            let trimmed = component.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.count > 2 {
                suggestedTags.append(trimmed)
            }
        }
        
        // Add extension as a tag
        let ext = (filename as NSString).pathExtension.lowercased()
        if !ext.isEmpty {
            suggestedTags.append(ext)
        }
        
        return AnalysisResult(
            providerId: identifier,
            providerVersion: version,
            rawJson: nil,
            normalizedTags: Array(Set(suggestedTags)), // Unique tags
            confidence: 1.0,
            status: .succeeded
        )
    }
}
