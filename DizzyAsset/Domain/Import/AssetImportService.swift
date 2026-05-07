import Foundation

class AssetImportService {
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
                    try process(url: fileURL, result: &result)
                }
            } else {
                try process(url: rootURL, result: &result)
            }
        }
        
        return result
    }
    
    private func process(url: URL, result: inout ImportScanResult) throws {
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
            result.candidates.append(candidate)
            result.discoveredCount += 1
        } else {
            result.unsupportedCount += 1
        }
    }
}
