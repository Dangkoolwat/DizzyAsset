import SwiftUI

struct AssetListView: View {
    let selection: String?
    @Binding var selectedAssetId: Int64?
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $selectedAssetId) {
                    ForEach(viewModel.assets) { asset in
                        AssetRowView(
                            assetId: asset.assetId,
                            fileURL: asset.fileURL,
                            filename: asset.filename,
                            mediaType: asset.mediaType,
                            fileSize: asset.sizeString,
                            duration: asset.durationString,
                            isSelected: selectedAssetId == asset.id
                        )
                        .tag(asset.id)
                    }
                }
                .listStyle(.inset)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search assets...")
        .task {
            await viewModel.refreshAssets()
        }
    }
}
