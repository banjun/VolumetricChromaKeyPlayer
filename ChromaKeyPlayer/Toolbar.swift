import SwiftUI

struct Toolbar: View {
    var isWindowHandleVisible: Visibility
    @Environment(PlayerController.self) var playerController

    var body: some View {
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
}
