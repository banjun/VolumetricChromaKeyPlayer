import SwiftUI

@main
struct ChromaKeyPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(width: 100)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 100, height: 300, depth: 300, in: .centimeters)

        WindowGroup {
            ContentView(width: 100)
        }
        .windowStyle(.automatic)
    }
}
