import SwiftUI

struct MainWindowView: View {
    @State private var selection: String? = "All Assets"
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
        } content: {
            AssetListView(selection: selection)
                .frame(minWidth: 400)
                .background(Color(NSColor.controlBackgroundColor))
        } detail: {
            AssetDetailView()
        }
    }
}

#Preview {
    MainWindowView()
}
