import SwiftUI
import RealityKit
import AVKit
import CoreImage
import CoreImage.CIFilterBuiltins

final class PlayerLayerView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    init(player: AVPlayer) {
        super.init(frame: .zero)
        playerLayer.player = player
        playerLayer.pixelBufferAttributes = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@Observable class PlayerController {
    @ObservationIgnored let player = AVPlayer()
    @ObservationIgnored var filter = ChromaKeyFilter.filter(0.20, green: 0.45, blue: 0.96, threshold: 0.2)
    var isMuted: Bool = false

    init() {}

    func setVideo(url: URL) {
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: item)

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

struct PlayerView: UIViewRepresentable {
    @Environment(PlayerController.self) var playerController

    func makeUIView(context: Context) -> UIView  {
        PlayerLayerView(player: playerController.player)
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct ContentView: View {
    let minVolumetricLength: CGFloat = 300 // lower limit seems to be around 300pt
    let width: CGFloat
    let idolHeight: CGFloat = 141
    let heightMargin: CGFloat = 10
    let depth:  Float = 0
    @Environment(\.physicalMetrics) private var physicalMetrics
    @State private var isWindowHandleVisible: Visibility = .visible
    @State private var playerController = PlayerController()
    let videoURL: URL = Bundle.main.url(forResource: "RPReplay_Final1717252226", withExtension: "mp4")!

    var body: some View {
        ZStack(alignment: .bottom) {
            // make the image front aligned within lower depth limit
            RealityView {
                $0.add(ModelEntity(mesh: .generateBox(size: physicalMetrics.convert(.init(minVolumetricLength), to: .meters) - depth), materials: [UnlitMaterial(color: .clear)]))
            }

            PlayerView().environment(playerController)
                .onAppear {
                    playerController.setVideo(url: videoURL)
                }
            .frame(width: physicalMetrics.convert(width, from: .centimeters),
                   height: physicalMetrics.convert(idolHeight + heightMargin, from: .centimeters))

            VStack {
                HStack(spacing: 40) {
                    Button {
                        playerController.back()
                    } label: { Image(systemName: "backward.fill") }
                    //                    .buttonStyle(PlainButtonStyle())
                    Button {
                        playerController.playPause()
                    } label: { Image(systemName: "playpause.fill") }
                    //                    .buttonStyle(PlainButtonStyle())
                    Button {
                        playerController.toggleMute()
                    } label: { Image(systemName: playerController.isMuted ? "speaker.slash.fill" : "speaker.fill") }
                    //                    .buttonStyle(PlainButtonStyle())
                }
                Text("Long Press to Show/Hide Control")
                    .font(.footnote)
                    .opacity(0.5)
            }
            .frame(height: 40)
            .padding()
            .glassBackgroundEffect()
            .opacity(isWindowHandleVisible == .hidden ? 0 : 1)
        }
        .persistentSystemOverlays(isWindowHandleVisible)
        .simultaneousGesture(LongPressGesture().onEnded {_ in
            // print("LongPressGesture")
            isWindowHandleVisible = isWindowHandleVisible == .hidden ? .automatic : .hidden
        })
        .simultaneousGesture(TapGesture().onEnded {
            // print("TapGesture")
        })
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(width: 100)
}
