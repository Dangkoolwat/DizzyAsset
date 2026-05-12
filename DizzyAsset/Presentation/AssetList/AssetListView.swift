import SwiftUI
import UniformTypeIdentifiers

struct AssetListView: View {
    let selection: String?
    @Binding var selectedAssetIds: Set<Int64>
    @StateObject private var viewModel = AssetListViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.assets.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    Text("No assets imported")
                        .font(.headline)
                    Text("Drag files here or use the Import button")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        openImportPanel()
                    }) {
                        Label("Import", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $selectedAssetIds) {
                    ForEach(viewModel.assets) { asset in
                        AssetRowView(
                            assetId: asset.assetId,
                            fileURL: asset.fileURL,
                            filename: asset.filename,
                            mediaType: asset.mediaType,
                            fileSize: asset.sizeString,
                            duration: asset.durationString,
                            isSelected: selectedAssetIds.contains(asset.id)
                        )
                        .tag(asset.id)
                    }
                }
                .listStyle(.inset)
            }
        }
        .onDrop(of: [.fileURL], isTargeted: nil) { providers in
            Task {
                var droppedURLs: [URL] = []
                for provider in providers {
                    if let url = await withCheckedContinuation({ (continuation: CheckedContinuation<URL?, Never>) in
                        if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (item, error) in
                                if let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                                    continuation.resume(returning: url)
                                } else if let url = item as? URL {
                                    continuation.resume(returning: url)
                                } else {
                                    continuation.resume(returning: nil)
                                }
                            }
                        } else {
                            continuation.resume(returning: nil)
                        }
                    }) {
                        droppedURLs.append(url)
                    }
                }
                
                if !droppedURLs.isEmpty {
                    await viewModel.importFiles(at: droppedURLs)
                }
            }
            return true
        }
        .searchable(text: $viewModel.searchText, prompt: "Search assets...")
        .task {
            await viewModel.refreshAssets()
        }
    }
    
    private func openImportPanel() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        
        if panel.runModal() == .OK {
            Task {
                await viewModel.importFiles(at: panel.urls)
            }
        }
    }
}
