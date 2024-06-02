import SwiftUI
import AVKit
import Observation

@Observable class PlayerController {
    @ObservationIgnored let player = AVPlayer()
    @ObservationIgnored var filter = ChromaKeyFilter.filter(0.20, green: 0.45, blue: 0.96, threshold: 0.2)
    var isMuted: Bool = false

    init() {}

    func setVideo(url: URL) {
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: item)

        // TODO: investigate filter for streaming
        // currently work with local file

        AVVideoComposition.videoComposition(with: asset) { [weak filter] request in
            filter?.inputImage = request.sourceImage
            request.finish(with: filter?.outputImage ?? request.sourceImage, context: nil)
        } completionHandler: { [weak player] videoComposition, error in
            item.videoComposition = videoComposition
            player?.play()
        }
    }

    func back() {
        player.seek(to: .zero)
    }

    func playPause() {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
    }

    func toggleMute() {
        isMuted.toggle()
        player.isMuted = isMuted
    }
}
