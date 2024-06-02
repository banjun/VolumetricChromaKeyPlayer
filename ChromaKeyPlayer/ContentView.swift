import SwiftUI
import RealityKit
import AVKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    let minVolumetricLength: CGFloat = 300 // lower limit seems to be around 300pt
    let width: CGFloat
    let idolHeight: CGFloat = 141
    let heightMargin: CGFloat = 8
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

            PlayerView()
                .frame(width: physicalMetrics.convert(width, from: .centimeters),
                       height: physicalMetrics.convert(idolHeight + heightMargin, from: .centimeters))
            Toolbar(isWindowHandleVisible: isWindowHandleVisible)
        }
        .environment(playerController)
        .onAppear {
            playerController.setVideo(url: videoURL)
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
