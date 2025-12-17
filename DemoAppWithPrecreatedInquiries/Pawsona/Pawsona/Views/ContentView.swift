//
//  ContentView.swift
//  Pawsona
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        if viewModel.showSuccess {
            FinishedView(
                inquiryId: viewModel.completedInquiryId ?? "",
                status: viewModel.completedInquiryStatus ?? ""
            )
        } else {
            OnboardingView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
