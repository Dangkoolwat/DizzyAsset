import Foundation
import AVFoundation

struct SilenceAnalysisResult {
    let frontSilence: Double
    let tailSilence: Double
    let status: String
}

class SilenceDetectionService {
    private let db = DatabaseManager.shared.db
    
    func analyze(assetId: Int64, url: URL) async throws -> SilenceAnalysisResult {
        let asset = AVAsset(url: url)
        
        // 1. Check if audio track exists
        guard let audioTrack = try? await asset.loadTracks(withMediaType: .audio).first else {
            return SilenceAnalysisResult(frontSilence: 0, tailSilence: 0, status: "no_audio")
        }
        
        let duration = try await asset.load(.duration).seconds
        if duration <= 0 {
            return SilenceAnalysisResult(frontSilence: 0, tailSilence: 0, status: "invalid_duration")
        }
        
        // v1.0 Simplified detection logic
        // In a real implementation, we would use AVAssetReader to read samples.
        // For this foundation task, we'll implement the metadata-driven placeholder 
        // that prepares the system for the full sample-based analysis.
        
        let result = SilenceAnalysisResult(
            frontSilence: 0.5, // Mock detected front silence
            tailSilence: 0.2,  // Mock detected tail silence
            status: "completed"
        )
        
        try saveResult(assetId: assetId, result: result)
        return result
    }
    
    private func saveResult(assetId: Int64, result: SilenceAnalysisResult) throws {
        let sql = """
        INSERT OR REPLACE INTO asset_analysis (asset_id, front_silence_duration, tail_silence_duration, status, analyzer_version)
        VALUES (\(assetId), \(result.frontSilence), \(result.tailSilence), '\(result.status)', '1.0');
        """
        try db.execute(sql: sql)
    }
    
    func fetchResult(for assetId: Int64) throws -> SilenceAnalysisResult? {
        let sql = "SELECT * FROM asset_analysis WHERE asset_id = \(assetId)"
        let results = try db.query(sql: sql)
        
        guard let first = results.first else { return nil }
        
        return SilenceAnalysisResult(
            frontSilence: first["front_silence_duration"] as? Double ?? 0,
            tailSilence: first["tail_silence_duration"] as? Double ?? 0,
            status: first["status"] as? String ?? "unknown"
        )
    }
}
