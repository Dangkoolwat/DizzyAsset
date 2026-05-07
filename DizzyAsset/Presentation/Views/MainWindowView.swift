import SwiftUI

struct MainWindowView: View {
    @State private var selection: String? = "All Assets"
    @State private var selectedAssetIds: Set<Int64> = []
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
        } content: {
            AssetListView(selection: selection, selectedAssetIds: $selectedAssetIds)
                .frame(minWidth: 400)
                .background(Color(NSColor.controlBackgroundColor))
        } detail: {
            AssetDetailView(selectedIds: selectedAssetIds)
        }
    }
}

#Preview {
    MainWindowView()
}
