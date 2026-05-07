import SwiftUI

struct AssetDetailView: View {
    var body: some View {
        VStack {
            Text("Asset Information Hub")
                .font(.title3)
                .bold()
            
            Divider()
                .padding(.vertical)
            
            Text("Select an asset to view details")
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 250)
        .navigationTitle("Details")
    }
}
