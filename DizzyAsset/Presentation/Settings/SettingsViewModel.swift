import SwiftUI
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var workspacePath: String = ""
    @Published var autoAnalysisEnabled: Bool = true
    
    private let settingsRepository = SettingsRepository()
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        do {
            workspacePath = try settingsRepository.getSetting(key: "workspace_root") ?? Workspace.default.rootURL.path
            let autoAnalysis = try settingsRepository.getSetting(key: "auto_analysis") ?? "true"
            autoAnalysisEnabled = autoAnalysis == "true"
        } catch {
            print("Failed to load settings: \(error)")
        }
    }
    
    func saveAutoAnalysis(_ enabled: Bool) {
        do {
            try settingsRepository.setSetting(key: "auto_analysis", value: enabled ? "true" : "false")
        } catch {
            print("Failed to save auto analysis setting: \(error)")
        }
    }
}
