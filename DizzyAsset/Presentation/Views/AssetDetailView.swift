import SwiftUI

struct AssetDetailView: View {
    let assetId: Int64?
    @StateObject private var previewViewModel = PreviewViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Preview Section
            PreviewView(viewModel: previewViewModel)
                .frame(height: 300)
            
            Divider()
            
            // Metadata Section
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Asset Information")
                        .font(.headline)
                    
                    if let assetId = assetId {
                        Text("Asset ID: \(assetId)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Placeholder for more detailed metadata (DA-011)
                    } else {
                        Text("No asset selected")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
        .onChange(of: assetId) { newId in
            if let id = newId {
                previewViewModel.loadPreview(for: id)
            } else {
                previewViewModel.previewService.stop()
            }
        }
    }
}
