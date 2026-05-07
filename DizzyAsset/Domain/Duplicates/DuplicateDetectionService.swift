import Foundation

enum DuplicateType {
    case unique
    case pathDuplicate
    case contentCandidate // Matches size/metadata
    case contentPartialMatch // Matches partial hash
    case contentConfirmed // Matches full hash
    case failed(Error)
}

struct DuplicateDetectionResult {
    let type: DuplicateType
    let existingAssetId: Int64?
}

class DuplicateDetectionService {
    private let assetRepository = AssetRepository()
    private let hashService = HashService()
    
    func detectDuplicate(for candidate: ImportCandidate) async -> DuplicateDetectionResult {
        do {
            // Stage 1: Path Duplicate Check (Fastest)
            if let existingId = try assetRepository.findAssetByPath(candidate.url.path) {
                return DuplicateDetectionResult(type: .pathDuplicate, existingAssetId: existingId)
            }
            
            // Stage 2: Metadata Match (Size Check)
            let metadataMatches = try assetRepository.findAssetsBySize(candidate.fileSize)
            if metadataMatches.isEmpty {
                return DuplicateDetectionResult(type: .unique, existingAssetId: nil)
            }
            
            // Stage 3: Partial Hash Match
            // Note: In DA-005, we compute the partial hash for the candidate 
            // and compare it against existing asset fingerprints if they are hashes.
            let partialHash = try hashService.computePartialHash(for: candidate.url)
            
            // For now, if metadata matches exist, we mark as partial match candidate
            // A more thorough comparison would require fetching existing asset fingerprints.
            return DuplicateDetectionResult(type: .contentPartialMatch, existingAssetId: metadataMatches.first)
        } catch {
            return DuplicateDetectionResult(type: .failed(error), existingAssetId: nil)
        }
    }
}
