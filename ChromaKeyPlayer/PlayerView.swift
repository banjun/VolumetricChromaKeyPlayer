import SwiftUI
import UIKit

struct PlayerView: UIViewRepresentable {
    @Environment(PlayerController.self) var playerController

    func makeUIView(context: Context) -> UIView  {
        PlayerLayerView(player: playerController.player)
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
