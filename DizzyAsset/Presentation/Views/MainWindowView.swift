import SwiftUI

struct MainWindowView: View {
    @State private var selection: String? = "All Assets"
    @State private var selectedAssetId: Int64?
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
        } content: {
            AssetListView(selection: selection, selectedAssetId: $selectedAssetId)
                .frame(minWidth: 400)
                .background(Color(NSColor.controlBackgroundColor))
        } detail: {
            AssetDetailView(assetId: selectedAssetId)
        }
    }
}

#Preview {
    MainWindowView()
}
