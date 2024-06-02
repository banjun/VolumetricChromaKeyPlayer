import SwiftUI

@main
struct ChromaKeyPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(width: 149)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 149, height: 300, depth: 300, in: .centimeters)

        WindowGroup {
            ContentView(width: 149)
        }
        .windowStyle(.automatic)
    }
}
