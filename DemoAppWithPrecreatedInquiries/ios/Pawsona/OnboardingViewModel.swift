//
//  OnboardingViewModel.swift
//  Pawsona
//

import Foundation
import Combine
import Persona2

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showPersonaFlow = false
    @Published var showSuccess = false
    @Published var inquiryId: String?
    @Published var sessionToken: String?
    @Published var completedInquiryId: String?
    @Published var completedInquiryStatus: String?

    // Replace with your backend URL
    // For iOS Simulator: use http://localhost:8000
    // For physical device: use your computer's IP address (e.g., http://192.168.1.100:8000)
    private let backendURL = "http://localhost:8000/api/inquiries/get-or-create"

    func startVerification() async {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: backendURL) else {
            errorMessage = "Invalid server URL"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(InquiryResponse.self, from: data)

            inquiryId = response.inquiryId
            sessionToken = response.sessionToken
            showPersonaFlow = true
        } catch {
            errorMessage = "Failed to verify: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func handleCompletion(inquiryId: String, status: String) {
        print("Verification completed. Inquiry ID: \(inquiryId), Status: \(status)")
        completedInquiryId = inquiryId
        completedInquiryStatus = status
        showPersonaFlow = false
        showSuccess = true
    }

    func handleCancellation() {
        print("User cancelled verification")
        showPersonaFlow = false
    }

    func handleEvent(_ event: InquiryEvent) {
        switch event {
        case .start(let startEvent):
            print("Inquiry started: \(startEvent.inquiryId) with session token: \(startEvent.sessionToken)")
        case .pageChange(let pageChangeEvent):
            print("Page changed to: \(pageChangeEvent.name)")
        default:
            print("Inquiry event: \(event)")
        }
    }

    func handleError(_ error: Error) {
        print("Verification error: \(error.localizedDescription)")
        showPersonaFlow = false
        errorMessage = "Verification failed. Please try again."
    }
}

struct InquiryResponse: Codable {
    let inquiryId: String
    let sessionToken: String?

    enum CodingKeys: String, CodingKey {
        case inquiryId = "inquiry_id"
        case sessionToken = "session_token"
    }
}
