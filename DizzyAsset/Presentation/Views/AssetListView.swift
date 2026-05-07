import SwiftUI

struct AssetListView: View {
    let selection: String?
    
    var body: some View {
        VStack {
            Text("Asset List View")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text("Selection: \(selection ?? "None")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 400)
        .navigationTitle(selection ?? "Assets")
    }
}
