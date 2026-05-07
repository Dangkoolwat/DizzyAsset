import SwiftUI

struct AssetInfoSection: View {
    let title: String
    let details: [String: String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            ForEach(details.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                HStack {
                    Text(key)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(value)
                        .bold()
                }
                .font(.subheadline)
            }
        }
    }
}
