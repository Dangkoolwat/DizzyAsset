import SwiftUI

struct ContentView: View {
    @State private var selection: String? = "All Assets"
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(selection: $selection) {
                Section("Library") {
                    Label("All Assets", systemImage: "square.grid.2x2")
                        .tag("All Assets")
                    Label("Recent", systemImage: "clock")
                        .tag("Recent")
                    Label("Favorites", systemImage: "star")
                        .tag("Favorites")
                }
                
                Section("Categories") {
                    Label("SFX", systemImage: "waveform")
                        .tag("SFX")
                    Label("BGM", systemImage: "music.note")
                        .tag("BGM")
                    Label("Memes", systemImage: "face.smiling")
                        .tag("Memes")
                }
            }
            .navigationTitle("DizzyAsset")
        } content: {
            // Main List
            VStack {
                Text("Asset List View")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
            .navigationTitle(selection ?? "Assets")
        } detail: {
            // Detail Panel
            VStack {
                Text("Select an asset to view details")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Details")
        }
    }
}

#Preview {
    ContentView()
}
