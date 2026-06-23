import Persona2
import SwiftUI

/// Launches a Persona inquiry from SwiftUI using the `.personaInquiry` view
/// modifier.
///
/// The modifier is driven by an `isPresented` binding — flip it to `true` and
/// the SDK presents the flow. Results arrive in the `onResult:` closure as a
/// ``PersonaResult`` enum, which we map into the shared ``InquiryOutcome``.
struct SwiftUIInquiryView: View {

    /// Drives the `.personaInquiry` modifier. Set to `true` to launch the flow.
    @State private var isPresentingInquiry = false

    /// The result of the most recent inquiry, shown in a sheet when non-nil.
    @State private var outcome: InquiryOutcome?

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.text.rectangle")
                .font(.system(size: 56))
                .foregroundStyle(.tint)

            Text("Verify your identity with a Persona inquiry launched from SwiftUI.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button {
                isPresentingInquiry = true
            } label: {
                Text("Start verification")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!PersonaConfiguration.isConfigured)

            if !PersonaConfiguration.isConfigured {
                ConfigurationHint()
            }

            Spacer()
        }
        .padding(24)
        .navigationTitle("SwiftUI")
        .navigationBarTitleDisplayMode(.inline)
        // The Persona SDK presents the inquiry whenever `isPresentingInquiry`
        // becomes true, and resets it to false when the flow ends.
        .personaInquiry(
            isPresented: $isPresentingInquiry,
            inquiryTemplate: PersonaConfiguration.templateID,
            builder: { builder in
                builder.environment(PersonaConfiguration.environment)
            },
            onResult: { result in
                switch result {
                case let .complete(data):
                    outcome = .completed(
                        inquiryID: data.inquiryId,
                        status: data.status,
                        fields: InquiryFieldItem.items(from: data.fields)
                    )
                case .canceled:
                    outcome = .canceled
                case let .errored(error):
                    outcome = .error(message: error.localizedDescription)
                @unknown default:
                    outcome = .error(message: "Received an unknown result from the SDK.")
                }
            }
        )
        .sheet(item: $outcome) { outcome in
            InquiryResultView(outcome: outcome)
        }
    }
}

#Preview {
    NavigationStack {
        SwiftUIInquiryView()
    }
}
