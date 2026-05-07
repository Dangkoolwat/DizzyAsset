import Foundation

struct ImportCandidate {
    let url: URL
    let filename: String
    let fileExtension: String
    let fileSize: Int64
    let modifiedAt: Date
    let mediaType: String
}

struct ImportScanResult {
    var discoveredCount: Int = 0
    var folderCount: Int = 0
    var unsupportedCount: Int = 0
    var errorCount: Int = 0
    var candidates: [ImportCandidate] = []
}

enum MediaFileType {
    static let audio = ["mp3", "wav", "aiff", "m4a"]
    static let video = ["mp4", "mov"]
    static let image = ["png", "jpg", "jpeg", "gif"]
    
    static func type(for extension: String) -> String? {
        let ext = `extension`.lowercased()
        if audio.contains(ext) { return "audio" }
        if video.contains(ext) { return "video" }
        if image.contains(ext) { return "image" }
        return nil
    }
}
