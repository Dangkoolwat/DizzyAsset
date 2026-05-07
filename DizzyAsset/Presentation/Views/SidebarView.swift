import SwiftUI

struct SidebarView: View {
    @Binding var selection: String?
    
    var body: some View {
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
    }
}
