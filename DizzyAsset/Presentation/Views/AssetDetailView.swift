import SwiftUI

struct AssetDetailView: View {
    let assetId: Int64?
    @StateObject private var previewViewModel = PreviewViewModel()
    @State private var tags: [String] = []
    @State private var categoryName: String = "None"
    
    private let taggingService = TaggingService()
    private let categoryRepository = CategoryRepository()
    
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
                        
                        // Category Section
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Category")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(categoryName)
                                .font(.subheadline)
                        }
                        
                        // Tags Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if tags.isEmpty {
                                Text("No tags assigned")
                                    .font(.caption)
                                    .italic()
                                    .foregroundColor(.secondary)
                            } else {
                                FlowLayout(spacing: 4) {
                                    ForEach(tags, id: \.self) { tag in
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
                loadTags(for: id)
                loadCategory(for: id)
            } else {
                previewViewModel.previewService.stop()
                tags = []
                categoryName = "None"
            }
        }
    }
    
    private func loadTags(for id: Int64) {
        do {
            tags = try taggingService.getTags(for: id)
        } catch {
            print("Failed to load tags: \(error)")
        }
    }
    
    private func loadCategory(for id: Int64) {
        do {
            let categories = try categoryRepository.fetchAssetCategories(for: id)
            if let first = categories.first, let name = first["name"] as? String {
                categoryName = name
            } else {
                categoryName = "None"
            }
        } catch {
            print("Failed to load category: \(error)")
        }
    }
}

// Simple FlowLayout for chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            let point = result.points[index]
            subview.place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var points: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: LayoutSubviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                points.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
                self.size.width = max(self.size.width, currentX)
            }
            self.size.height = currentY + lineHeight
        }
    }
}
