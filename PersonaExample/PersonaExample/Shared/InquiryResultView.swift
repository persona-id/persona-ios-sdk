import SwiftUI

/// A shared result screen presented after an inquiry finishes.
///
/// Both examples present this in a sheet so the completed / canceled / error
/// states look identical regardless of which UI framework launched the inquiry.
struct InquiryResultView: View {
    let outcome: InquiryOutcome

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label {
                        Text(outcome.title).font(.headline)
                    } icon: {
                        Image(systemName: iconName).foregroundStyle(iconColor)
                    }
                }

                switch outcome {
                case let .completed(inquiryID, status, fields):
                    Section("Inquiry") {
                        labeledRow("ID", inquiryID)
                        labeledRow("Status", status)
                    }
                    if fields.isEmpty {
                        Section("Fields") {
                            Text("No field values were returned.")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Section("Fields") {
                            ForEach(fields) { field in
                                labeledRow(field.name, field.value)
                            }
                        }
                    }

                case .canceled:
                    Section {
                        Text("The inquiry was canceled before it finished.")
                            .foregroundStyle(.secondary)
                    }

                case let .error(message):
                    Section("Details") {
                        Text(message).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func labeledRow(_ name: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
                .textSelection(.enabled)
        }
    }

    private var iconName: String {
        switch outcome {
        case .completed: "checkmark.circle.fill"
        case .canceled: "xmark.circle.fill"
        case .error: "exclamationmark.triangle.fill"
        }
    }

    private var iconColor: Color {
        switch outcome {
        case .completed: .green
        case .canceled: .secondary
        case .error: .orange
        }
    }
}

#Preview("Completed") {
    InquiryResultView(outcome: .completed(
        inquiryID: "inq_ABC123",
        status: "completed",
        fields: [
            InquiryFieldItem(name: "name-first", value: "Ada"),
            InquiryFieldItem(name: "name-last", value: "Lovelace"),
        ]
    ))
}

#Preview("Error") {
    InquiryResultView(outcome: .error(message: "The network connection was lost."))
}
