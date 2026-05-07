import Foundation

class BookmarkManager {
    static let shared = BookmarkManager()
    
    private init() {}
    
    func createBookmark(for url: URL) throws -> Data {
        return try url.bookmarkData(options: .withSecurityScope,
                                   includingResourceValuesForKeys: nil,
                                   relativeTo: nil)
    }
    
    func resolveBookmark(data: Data) throws -> (URL, Bool) {
        var isStale = false
        let url = try URL(resolvingBookmarkData: data,
                          options: .withSecurityScope,
                          relativeTo: nil,
                          bookmarkDataIsStale: &isStale)
        return (url, isStale)
    }
    
    func startAccessing(_ url: URL) -> Bool {
        return url.startAccessingSecurityScopedResource()
    }
    
    func stopAccessing(_ url: URL) {
        url.stopAccessingSecurityScopedResource()
    }
}
