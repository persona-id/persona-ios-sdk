import SwiftUI

/// The app's entry screen.
///
/// It links to two functionally identical examples — one built with SwiftUI and
/// one with UIKit — so you can compare how each framework integrates the Persona
/// Inquiry SDK. Both share ``InquiryResultView`` for displaying results.
struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("This sample launches the same Persona identity "
                         + "verification flow two ways. Pick an implementation "
                         + "to see how it integrates the SDK.")
                    .foregroundStyle(.secondary)
                }

                Section("Examples") {
                    NavigationLink {
                        SwiftUIInquiryView()
                    } label: {
                        exampleRow(
                            title: "SwiftUI",
                            subtitle: "Uses the .personaInquiry view modifier",
                            systemImage: "swift"
                        )
                    }

                    NavigationLink {
                        UIKitInquiryView()
                    } label: {
                        exampleRow(
                            title: "UIKit",
                            subtitle: "Uses Inquiry.from(...).start(from:)",
                            systemImage: "rectangle.on.rectangle"
                        )
                    }
                }

                Section("Configuration") {
                    LabeledContent("Environment", value: "\(PersonaConfiguration.environment)")
                    LabeledContent("Template ID") {
                        Text(PersonaConfiguration.isConfigured
                             ? PersonaConfiguration.templateID
                             : "Not set")
                        .foregroundStyle(PersonaConfiguration.isConfigured ? Color.primary : Color.red)
                    }
                    if !PersonaConfiguration.isConfigured {
                        ConfigurationHint()
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                    }
                }
            }
            .navigationTitle("Persona SDK")
        }
    }

    private func exampleRow(title: String, subtitle: String, systemImage: String) -> some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: systemImage)
        }
    }
}

#Preview {
    HomeView()
}
