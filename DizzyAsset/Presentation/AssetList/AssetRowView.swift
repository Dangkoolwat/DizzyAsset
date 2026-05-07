import SwiftUI

struct AssetRowView: View {
    let assetId: Int64
    let fileURL: URL?
    let filename: String
    let mediaType: String
    let fileSize: String
    let duration: String?
    let isSelected: Bool
    
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Image(systemName: iconName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(filename)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(mediaType.uppercased())
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(iconColor.opacity(0.1))
                        .foregroundColor(iconColor)
                        .cornerRadius(3)
                    
                    Text(fileSize)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    if let duration = duration {
                        Text(duration)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 14))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.accentColor.opacity(0.08) : (isHovered ? Color.primary.opacity(0.03) : Color.clear))
        )
        .scaleEffect(isHovered ? 1.015 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHovered)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
        .onHover { hovering in
            isHovered = hovering
        }
        .contentShape(Rectangle())
        .onDrag {
            let provider = NSItemProvider(object: String(assetId) as NSString)
            
            if let url = fileURL {
                provider.registerObject(url as NSURL, visibility: .all)
            }
            
            return provider
        }
    }
    
    private var iconName: String {
        switch mediaType.lowercased() {
        case "video": return "video.fill"
        case "audio": return "waveform"
        case "image": return "photo.fill"
        default: return "doc.fill"
        }
    }
    
    private var iconColor: Color {
        switch mediaType.lowercased() {
        case "video": return .purple
        case "audio": return .blue
        case "image": return .green
        default: return .secondary
        }
    }
}
