//
//  FinishedView.swift
//  Pawsona
//

import SwiftUI

struct FinishedView: View {
    let inquiryId: String
    let status: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Pawsona")
                .font(Font.title2)

            Spacer()

            Text("✔️")
                .font(.system(size: 60))

            Text("Verification Submitted")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Text("Your verification is being processed.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            // Debug info
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Status:")
                        .fontWeight(.semibold)
                    Text(status)
                        .foregroundColor(.secondary)
                }

                HStack(alignment: .top) {
                    Text("Inquiry ID:")
                        .fontWeight(.semibold)
                    Text(inquiryId)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)

            Button(action: {
                // In production: navigate to home
                print("Navigate to home")
            }) {
                Text("Return to Home")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FinishedView(inquiryId: "inq_12345", status: "completed")
}
