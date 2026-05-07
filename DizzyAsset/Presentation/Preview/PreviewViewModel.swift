import SwiftUI
import Combine

class PreviewViewModel: ObservableObject {
    @Published var previewService = PreviewService()
    private var cancellables = Set<AnyCancellable>()
    
    private let assetRepository = AssetRepository()
    private var currentSecurityScopedURL: URL?
    
    func loadPreview(for assetId: Int64) {
        // Stop current playback and release security scope
        stopPreview()
        
        do {
            let locations = try assetRepository.fetchLocations(for: assetId)
            guard let location = locations.first else {
                previewService.status = .failed(reason: "No location found")
                return
            }
            
            guard let urlString = location["url"] as? String,
                  let url = URL(string: urlString) else {
                previewService.status = .failed(reason: "Invalid URL")
                return
            }
            
            // Resolve bookmark for sandbox access
            if let bookmarkData = location["bookmark_data"] as? Data {
                let result = BookmarkManager.shared.resolveBookmark(data: bookmarkData)
                if let resolvedURL = result.url, BookmarkManager.shared.startAccessing(resolvedURL) {
                    currentSecurityScopedURL = resolvedURL
                    previewService.prepare(url: resolvedURL)
                } else {
                    let reason = result.error.map { "\($0)" } ?? "Permission denied"
                    previewService.status = .failed(reason: reason)
                }
            } else {
                // Direct access if possible
                previewService.prepare(url: url)
            }
            
        } catch {
            previewService.status = .failed(reason: "Failed to load asset location")
        }
    }
    
    func togglePlayback() {
        previewService.togglePlayPause()
    }
    
    func stopPreview() {
        previewService.stop()
        if let url = currentSecurityScopedURL {
            BookmarkManager.shared.stopAccessing(url)
            currentSecurityScopedURL = nil
        }
    }
    
    deinit {
        // Ensure security scope is released
        if let url = currentSecurityScopedURL {
            url.stopAccessingSecurityScopedResource()
        }
    }
}
