import Foundation
import CryptoKit

class HashService {
    enum HashError: Error {
        case fileNotReadable
        case readFailure
    }
    
    /// Computes a partial hash by reading 8KB from the start, middle, and end of the file.
    func computePartialHash(for url: URL) throws -> String {
        let fileHandle = try FileHandle(forReadingFrom: url)
        defer { try? fileHandle.close() }
        
        // fileSize from URLResourceValues is Int?
        let fileSizeInt = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
        let fileSize = Int64(fileSizeInt)
        let chunkSize = Int64(8192) // 8KB
        
        var hasher = SHA256()
        
        // Start 8KB
        if let startData = try fileHandle.read(upToCount: Int(chunkSize)) {
            hasher.update(data: startData)
        }
        
        // Middle 8KB
        if fileSize > (chunkSize * 3) {
            let middleOffset = (fileSize / 2) - (chunkSize / 2)
            try fileHandle.seek(toOffset: UInt64(middleOffset))
            if let middleData = try fileHandle.read(upToCount: Int(chunkSize)) {
                hasher.update(data: middleData)
            }
        }
        
        // End 8KB
        if fileSize > chunkSize {
            let endOffset = max(Int64(0), fileSize - chunkSize)
            try fileHandle.seek(toOffset: UInt64(endOffset))
            if let endData = try fileHandle.read(upToCount: Int(chunkSize)) {
                hasher.update(data: endData)
            }
        }
        
        return hasher.finalize().map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Computes a full SHA256 hash of the file.
    func computeFullHash(for url: URL) throws -> String {
        let fileHandle = try FileHandle(forReadingFrom: url)
        defer { try? fileHandle.close() }
        
        var hasher = SHA256()
        let bufferSize = 64 * 1024 // 64KB buffer
        
        while let data = try fileHandle.read(upToCount: bufferSize), !data.isEmpty {
            hasher.update(data: data)
        }
        
        return hasher.finalize().map { String(format: "%02hhx", $0) }.joined()
    }
}
