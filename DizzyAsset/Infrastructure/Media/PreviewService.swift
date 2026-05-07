import Foundation
import AVFoundation
import Combine

enum PreviewStatus: Equatable {
    case idle
    case loading
    case ready
    case playing
    case paused
    case failed(reason: String)
}

class PreviewService: ObservableObject {
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var status: PreviewStatus = .idle
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    
    func prepare(url: URL) {
        stop()
        status = .loading
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        player = AVPlayer(playerItem: playerItem)
        
        // Basic error handling via KVO or Notification
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.status = .paused
        }
        
        // Monitor status
        playerItem.publisher(for: \.status)
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                switch status {
                case .readyToPlay:
                    self?.status = .ready
                    self?.duration = playerItem.duration.seconds
                case .failed:
                    self?.status = .failed(reason: "AVPlayerItem failed")
                default:
                    break
                }
            }
            .store(in: &cancellables)
            
        setupTimeObserver()
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if status == .playing {
            player.pause()
            status = .paused
        } else {
            player.play()
            status = .playing
        }
    }
    
    func stop() {
        player?.pause()
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        player = nil
        status = .idle
        currentTime = 0
        duration = 0
        cancellables.removeAll()
    }
    
    private func setupTimeObserver() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }
}
