import SwiftUI

struct AssetRowView: View {
    let assetId: Int64
    let fileURL: URL?
    let filename: String
    let mediaType: String
    let fileSize: String
    let duration: String?
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(filename)
                    .font(.body)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(mediaType.uppercased())
                        .font(.caption2)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(3)
                    
                    Text(fileSize)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if let duration = duration {
                        Text(duration)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onDrag {
            let provider = NSItemProvider(object: String(assetId) as NSString)
            
            if let url = fileURL {
                // Register the file URL for external applications (like FCP)
                provider.registerObject(url as NSURL, visibility: .all)
            }
            
            return provider
        }
    }
    
    private var iconName: String {
        switch mediaType.lowercased() {
        case "video": return "video.fill"
        case "audio": return "waveform"
        case "image": return "photo"
        default: return "doc.fill"
        }
    }
}
