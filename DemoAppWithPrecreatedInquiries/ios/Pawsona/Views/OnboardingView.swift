//
//  OnboardingView.swift
//  Pawsona
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                Text("Pawsona")
                    .font(Font.title2)

                Spacer()

                Text("Welcome, Alexander! 🐕")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("Before you can start walking dogs, we need to verify your identity. This helps ensure the safety of pet owners and walkers like you.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Information")
                        .font(.headline)
                        .foregroundColor(.primary)

                    InfoRow(label: "Name:", value: "Alexander Sample")
                    InfoRow(label: "Birthdate:", value: "August 31, 1977")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(UIColor.separator), lineWidth: 1)
                )

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(8)
                }

                Spacer()

                Button(action: {
                    Task {
                        await viewModel.startVerification()
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Start Verifying")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 50)
                .background(viewModel.isLoading ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(viewModel.isLoading)
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(
            PersonaFlowPresenter(
                isPresented: $viewModel.showPersonaFlow,
                inquiryId: viewModel.inquiryId ?? "",
                sessionToken: viewModel.sessionToken,
                onComplete: { inquiryId, status in
                    viewModel.handleCompletion(inquiryId: inquiryId, status: status)
                },
                onCancel: {
                    viewModel.handleCancellation()
                },
                onEvent: { event in
                    viewModel.handleEvent(event)
                },
                onError: { error in
                    viewModel.handleError(error)
                }
            )
        )
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}
