import Foundation

class AssetImportService {
    private let duplicateDetector = DuplicateDetectionService()
    private let assetRepository = AssetRepository()

    func scan(urls: [URL]) async throws -> ImportScanResult {
        var result = ImportScanResult()
        let fileManager = FileManager.default
        let resourceKeys: [URLResourceKey] = [.nameKey, .isDirectoryKey, .fileSizeKey, .contentModificationDateKey]
        
        for rootURL in urls {
            if Task.isCancelled { break }
            
            let isScoped = rootURL.startAccessingSecurityScopedResource()
            defer { if isScoped { rootURL.stopAccessingSecurityScopedResource() } }
            
            var isDirectory: ObjCBool = false
            guard fileManager.fileExists(atPath: rootURL.path, isDirectory: &isDirectory) else {
                result.errorCount += 1
                continue
            }
            
            if isDirectory.boolValue {
                result.folderCount += 1
                guard let enumerator = fileManager.enumerator(at: rootURL,
                                                            includingPropertiesForKeys: resourceKeys,
                                                            options: [.skipsHiddenFiles, .skipsPackageDescendants]) else {
                    result.errorCount += 1
                    continue
                }
                
                for case let fileURL as URL in enumerator {
                    if Task.isCancelled { break }
                    try await process(url: fileURL, result: &result)
                }
            } else {
                try await process(url: rootURL, result: &result)
            }
        }
        
        return result
    }
    
    private func process(url: URL, result: inout ImportScanResult) async throws {
        let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey, .contentModificationDateKey])
        
        if resourceValues.isDirectory == true {
            result.folderCount += 1
            return
        }
        
        let ext = url.pathExtension.lowercased()
        if let type = MediaFileType.type(for: ext) {
            let candidate = ImportCandidate(
                url: url,
                filename: url.lastPathComponent,
                fileExtension: ext,
                fileSize: Int64(resourceValues.fileSize ?? 0),
                modifiedAt: resourceValues.contentModificationDate ?? Date(),
                mediaType: type
            )
            
            // Duplicate Detection Hook
            let duplicateResult = await duplicateDetector.detectDuplicate(for: candidate)
            switch duplicateResult.type {
            case .unique:
                result.candidates.append(candidate)
                result.discoveredCount += 1
            case .pathDuplicate:
                // Skip path duplicates during import
                break
            case .contentPartialMatch, .contentConfirmed:
                // Report content duplicates but keep in discovery for now
                result.candidates.append(candidate)
                result.discoveredCount += 1
            case .failed:
                result.errorCount += 1
            default:
                break
            }
        } else {
            result.unsupportedCount += 1
        }
    }
}
