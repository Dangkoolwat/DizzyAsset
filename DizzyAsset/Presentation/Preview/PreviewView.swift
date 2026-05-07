import SwiftUI

struct PreviewView: View {
    @ObservedObject var viewModel: PreviewViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.05)
            
            switch viewModel.previewService.status {
            case .idle:
                Text("Select an asset to preview")
                    .foregroundColor(.secondary)
            case .loading:
                ProgressView()
            case .ready, .playing, .paused:
                VStack {
                    // Placeholder for actual VideoPlayerView or QuickLook
                    // For now, using a simple visual area
                    Rectangle()
                        .fill(Color.black)
                        .aspectRatio(16/9, contentMode: .fit)
                        .overlay(
                            Image(systemName: viewModel.previewService.status == .playing ? "pause.fill" : "play.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .opacity(0.8)
                        )
                    
                    VStack(spacing: 8) {
                        Slider(value: .constant(viewModel.previewService.currentTime), in: 0...max(1, viewModel.previewService.duration))
                            .accentColor(.accentColor)
                        
                        HStack {
                            Text(formatTime(viewModel.previewService.currentTime))
                            Spacer()
                            Text(formatTime(viewModel.previewService.duration))
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                }
            case .failed(let reason):
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 32))
                        .foregroundColor(.orange)
                    Text("Preview Failed")
                        .font(.headline)
                    Text(reason)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // Setup keyboard listeners or other logic
        }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds) ?? "0:00"
    }
}
