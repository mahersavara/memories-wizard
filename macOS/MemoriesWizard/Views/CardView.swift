import SwiftUI
import AVKit

struct CardView: View {
    let url: URL
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            if isVideo {
                VideoPlayer(player: player)
                    .onAppear {
                        player = AVPlayer(url: url)
                        player?.isMuted = true
                        player?.play()
                        
                        // Loop video
                        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { _ in
                            player?.seek(to: .zero)
                            player?.play()
                        }
                    }
                    .onDisappear {
                        player?.pause()
                        player = nil
                    }
            } else {
                if let nsImage = NSImage(contentsOf: url) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
        .background(Color.black)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    private var isVideo: Bool {
        let videoExtensions = ["mp4", "mov", "avi"]
        return videoExtensions.contains(url.pathExtension.lowercased())
    }
}
