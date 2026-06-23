import Persona2

/// The single place to configure how this example app talks to Persona.
///
/// Replace ``templateID`` with your own **Inquiry Template ID** before running.
/// You can find it in the Persona Dashboard under
/// *Integration → your template* — it looks like `itmpl_XXXXXXXXXXXXXXXXX`.
///
/// Both the SwiftUI and UIKit examples read from here, so there is exactly one
/// value to change to get the app working end to end.
enum PersonaConfiguration {

    /// Your Inquiry Template ID. Replace this placeholder before running.
    static let templateID = "itmpl_REPLACE_ME"

    /// The Persona environment to run inquiries against.
    ///
    /// Use `.sandbox` while integrating; switch to `.production` for live data.
    static let environment: Environment = .sandbox

    /// Whether a real template ID has been provided.
    ///
    /// The examples use this to disable their "Start verification" buttons and
    /// show a setup hint until you plug in your own template.
    static var isConfigured: Bool {
        templateID.hasPrefix("itmpl_") && templateID != "itmpl_REPLACE_ME"
    }
}
