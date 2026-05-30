import SwiftUI
import AVKit
import Combine

class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isSeeking: Bool = false
    @Published var currentSpeed: Double = 1.0
    @Published var currentTime: CMTime = .zero
    @Published var duration: CMTime = .zero
    @Published var errorMessage: String?

    private var looper: AVPlayerLooper?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?

    func loadVideo(url: URL) {
        stop()
        let item = AVPlayerItem(url: url)
        let newPlayer = AVQueuePlayer(playerItem: item)
        looper = AVPlayerLooper(player: newPlayer, templateItem: item)
        player = newPlayer
        currentSpeed = AppStorageHelper.playbackSpeed
        applyCurrentSpeed()

        // Observe status
        item.publisher(for: \.status)
            .sink { [weak self] status in
                switch status {
                case .failed:
                    self?.errorMessage = item.error?.localizedDescription
                case .readyToPlay:
                    self?.duration = item.asset.duration
                default:
                    break
                }
            }
            .store(in: &cancellables)

        // Timer for time updates
        timerCancellable = Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let player = self.player, !self.isSeeking else { return }
                self.currentTime = player.currentTime()
                if let item = player.currentItem {
                    self.duration = item.asset.duration
                }
            }
    }

    func stop() {
        player?.pause()
        looper = nil
        player?.replaceCurrentItem(with: nil)
        player = nil
        timerCancellable?.cancel()
        cancellables.removeAll()
        errorMessage = nil
    }

    func applyCurrentSpeed() {
        player?.rate = Float(currentSpeed)
        AppStorageHelper.playbackSpeed = currentSpeed
    }

    func seek(to time: CMTime) {
        player?.seek(to: time)
    }
}

struct AppStorageHelper {
    @AppStorage("playbackSpeed") static var playbackSpeed: Double = 1.0
}
