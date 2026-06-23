import SwiftUI

/// The app entry point.
///
/// A pure SwiftUI lifecycle (`App` + `WindowGroup`) — no storyboards or
/// `AppDelegate`. ``HomeView`` hosts the SwiftUI and UIKit examples.
@main
struct PersonaExampleApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
