import SwiftUI

struct AssetDetailView: View {
    let assetId: Int64?
    @StateObject private var previewViewModel = PreviewViewModel()
    @StateObject private var hubViewModel = AssetInformationHubViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if let id = assetId {
                content(for: id)
            } else {
                emptyState
            }
        }
        .navigationTitle("Details")
        .frame(minWidth: 300)
        .onChange(of: assetId) { newId in
            if let id = newId {
                previewViewModel.loadPreview(for: id)
                hubViewModel.loadAssetDetails(for: id)
            } else {
                previewViewModel.previewService.stop()
            }
        }
    }
    
    private func content(for id: Int64) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Preview Section
                PreviewView(viewModel: previewViewModel)
                    .frame(height: 250)
                    .cornerRadius(8)
                    .padding(.bottom, 10)
                
                // Status Section
                statusSection
                
                Divider()
                
                // Metadata Section
                AssetInfoSection(title: "Technical Metadata", details: hubViewModel.technicalMetadata)
                
                Divider()
                
                // Category Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.headline)
                    Text(hubViewModel.categoryName)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                Divider()
                
                // Tags Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tags")
                        .font(.headline)
                    
                    if hubViewModel.tags.isEmpty {
                        Text("No tags assigned")
                            .font(.caption)
                            .italic()
                            .foregroundColor(.secondary)
                    } else {
                        FlowLayout(spacing: 4) {
                            ForEach(hubViewModel.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.accentColor.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var statusSection: some View {
        HStack(spacing: 16) {
            Label(hubViewModel.isOnline ? "Online" : "Offline", 
                  systemImage: hubViewModel.isOnline ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundColor(hubViewModel.isOnline ? .green : .red)
            
            if hubViewModel.isDuplicate {
                Label("Duplicate", systemImage: "doc.on.doc.fill")
                    .foregroundColor(.orange)
            }
            
            Spacer()
        }
        .font(.caption)
        .padding(.horizontal, 4)
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "info.circle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("No Asset Selected")
                .font(.title3)
                .bold()
            Text("Select an asset from the list to view its technical details, tags, and preview.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
    }
}
