import SwiftUI

struct QuickPeekView: View {
    @StateObject private var viewModel = QuickPeekViewModel()
    @StateObject private var previewViewModel = PreviewViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Input
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                TextField("Search Assets...", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                    .font(.title2)
                    .onSubmit {
                        // Handle action on Enter if needed
                    }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor).opacity(0.8))
            
            Divider()
            
            HStack(spacing: 0) {
                // Results List
                List(selection: Binding(get: { viewModel.selectedIndex }, set: { viewModel.selectedIndex = $0 ?? 0 })) {
                    ForEach(Array(viewModel.results.enumerated()), id: \.offset) { index, asset in
                        HStack {
                            Image(systemName: "doc.fill")
                                .foregroundColor(.secondary)
                            Text(asset.filename)
                                .lineLimit(1)
                            Spacer()
                            Text(asset.sizeString)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        .tag(index)
                    }
                }
                .listStyle(.inset)
                .frame(width: 300)
                
                Divider()
                
                // Preview Area
                VStack {
                    if let selectedAsset = viewModel.selectedAsset {
                        PreviewView(viewModel: previewViewModel)
                            .onChange(of: selectedAsset.id) { newId in
                                previewViewModel.loadPreview(for: newId)
                            }
                            .onAppear {
                                previewViewModel.loadPreview(for: selectedAsset.id)
                            }
                    } else {
                        VStack {
                            Image(systemName: "eye.slash")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("Select an asset to preview")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.05))
            }
            .frame(height: 400)
        }
        .frame(width: 700)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
