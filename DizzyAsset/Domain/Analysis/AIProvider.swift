import Foundation

struct AnalysisResult {
    let providerId: String
    let providerVersion: String
    let rawJson: String?
    let normalizedTags: [String]
    let confidence: Double
    let status: AnalysisStatus
}

enum AnalysisStatus: String {
    case pending = "pending"
    case running = "running"
    case succeeded = "succeeded"
    case failed = "failed"
}

protocol AIProvider {
    var identifier: String { get }
    var version: String { get }
    func canAnalyze(assetId: Int64, filename: String, url: URL?) -> Bool
    func analyze(assetId: Int64, filename: String, url: URL?) async throws -> AnalysisResult
}
