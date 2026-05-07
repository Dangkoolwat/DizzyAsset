import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        TabView {
            generalSection
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            
            workspaceSection
                .tabItem {
                    Label("Workspace", systemImage: "folder")
                }
        }
        .frame(width: 450, height: 250)
        .padding()
    }
    
    private var generalSection: some View {
        Form {
            Section(header: Text("Analysis")) {
                Toggle("Auto-Analysis on Import", isOn: $viewModel.autoAnalysisEnabled)
                    .onChange(of: viewModel.autoAnalysisEnabled) { newValue in
                        viewModel.saveAutoAnalysis(newValue)
                    }
                
                Text("When enabled, DizzyAsset will automatically perform silence detection and metadata extraction upon importing new assets.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var workspaceSection: some View {
        Form {
            Section(header: Text("Storage Location")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Workspace Path:")
                        .font(.subheadline)
                        .bold()
                    
                    Text(viewModel.workspacePath)
                        .font(.caption)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(4)
                    
                    Text("The workspace contains your database, derived assets, and metadata analysis. Moving the workspace folder manually may cause data loss.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Change Location...") {
                        // Hook for DA-022: Workspace Migration
                    }
                    .disabled(true) // Disabled for DA-019 foundation as per safety rules
                }
            }
        }
    }
}
