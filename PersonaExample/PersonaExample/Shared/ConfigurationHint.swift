import SwiftUI

/// A small inline notice shown when no Inquiry Template ID has been configured
/// yet, pointing the developer at the one file they need to edit.
struct ConfigurationHint: View {
    var body: some View {
        Label {
            Text("Set your template ID in **PersonaConfiguration.swift** to enable verification.")
        } icon: {
            Image(systemName: "exclamationmark.triangle.fill")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.yellow.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ConfigurationHint().padding()
}
