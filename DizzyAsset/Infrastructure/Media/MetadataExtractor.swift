import Foundation
import AVFoundation

struct AssetMetadata {
    let duration: Double?
    let width: Int?
    let height: Int?
    let codec: String?
    let frameRate: Double?
    let createdAt: Date?
    let modifiedAt: Date?
}

class MetadataExtractor {
    enum ExtractionError: Error {
        case unsupportedFormat
        case readFailure
    }
    
    func extractMetadata(from url: URL) async throws -> AssetMetadata {
        let asset = AVAsset(url: url)
        
        // Load properties asynchronously
        let duration = try? await asset.load(.duration).seconds
        let tracks = try? await asset.load(.tracks)
        
        var width: Int?
        var height: Int?
        var codec: String?
        var frameRate: Double?
        
        if let videoTrack = tracks?.first(where: { $0.mediaType == .video }) {
            let size = try? await videoTrack.load(.naturalSize)
            width = Int(size?.width ?? 0)
            height = Int(size?.height ?? 0)
            
            // nominalFrameRate is Float
            if let fr = try? await videoTrack.load(.nominalFrameRate) {
                frameRate = Double(fr)
            }
            
            let formatDescriptions = try? await videoTrack.load(.formatDescriptions)
            if let firstFormat = formatDescriptions?.first {
                codec = CMFormatDescriptionGetMediaSubType(firstFormat).toString()
            }
        }
        
        let resourceValues = try? url.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
        
        return AssetMetadata(
            duration: duration,
            width: (width ?? 0) > 0 ? width : nil,
            height: (height ?? 0) > 0 ? height : nil,
            codec: codec,
            frameRate: (frameRate ?? 0) > 0 ? frameRate : nil,
            createdAt: resourceValues?.creationDate,
            modifiedAt: resourceValues?.contentModificationDate
        )
    }
}

extension FourCharCode {
    func toString() -> String {
        let n = Int(self)
        var s: String = ""
        s.append(Character(UnicodeScalar((n >> 24) & 255)!))
        s.append(Character(UnicodeScalar((n >> 16) & 255)!))
        s.append(Character(UnicodeScalar((n >> 8) & 255)!))
        s.append(Character(UnicodeScalar(n & 255)!))
        return s.trimmingCharacters(in: .whitespaces)
    }
}
