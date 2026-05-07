import Foundation

enum BookmarkResolutionError: Error {
    case stale
    case volumeOffline
    case permissionDenied
    case missingFile
    case unknown(Error)
}

struct BookmarkResolutionResult {
    let url: URL?
    let isStale: Bool
    let error: BookmarkResolutionError?
}

class BookmarkManager {
    static let shared = BookmarkManager()
    
    private init() {}
    
    func createBookmark(for url: URL) throws -> Data {
        return try url.bookmarkData(options: .withSecurityScope,
                                   includingResourceValuesForKeys: nil,
                                   relativeTo: nil)
    }
    
    func resolveBookmark(data: Data) -> BookmarkResolutionResult {
        var isStale = false
        do {
            let url = try URL(resolvingBookmarkData: data,
                              options: .withSecurityScope,
                              relativeTo: nil,
                              bookmarkDataIsStale: &isStale)
            
            // Check if file physically exists
            if !FileManager.default.fileExists(atPath: url.path) {
                // Check if volume is online
                if let volumeURL = getVolumeURL(for: url), !FileManager.default.fileExists(atPath: volumeURL.path) {
                    return BookmarkResolutionResult(url: url, isStale: isStale, error: .volumeOffline)
                }
                return BookmarkResolutionResult(url: url, isStale: isStale, error: .missingFile)
            }
            
            return BookmarkResolutionResult(url: url, isStale: isStale, error: nil)
        } catch {
            let nsError = error as NSError
            if nsError.domain == NSCocoaErrorDomain && nsError.code == NSFileReadNoPermissionError {
                return BookmarkResolutionResult(url: nil, isStale: false, error: .permissionDenied)
            }
            return BookmarkResolutionResult(url: nil, isStale: false, error: .unknown(error))
        }
    }
    
    func startAccessing(_ url: URL) -> Bool {
        return url.startAccessingSecurityScopedResource()
    }
    
    func stopAccessing(_ url: URL) {
        url.stopAccessingSecurityScopedResource()
    }
    
    private func getVolumeURL(for url: URL) -> URL? {
        let values = try? url.resourceValues(forKeys: [.volumeURLKey])
        return values?.volume
    }
}
