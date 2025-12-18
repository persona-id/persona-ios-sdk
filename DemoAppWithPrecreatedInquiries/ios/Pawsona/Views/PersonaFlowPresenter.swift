//
//  PersonaFlowPresenter.swift
//  Pawsona
//
//  UIKit bridge for the Persona iOS SDK

import SwiftUI
import Persona2

struct PersonaFlowPresenter: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let inquiryId: String
    let sessionToken: String?
    let onComplete: (String, String) -> Void
    let onCancel: () -> Void
    let onEvent: (InquiryEvent) -> Void
    let onError: (Error) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(
            onComplete: onComplete,
            onCancel: onCancel,
            onEvent: onEvent,
            onError: onError
        )
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Only present once - prevent re-presenting if SwiftUI re-renders
        guard isPresented && uiViewController.presentedViewController == nil else { return }

        let config = InquiryConfiguration(
            inquiryId: inquiryId,
            sessionToken: sessionToken
        )

        let inquiry = Inquiry(config: config, delegate: context.coordinator)
        DispatchQueue.main.async {
            inquiry.start(from: uiViewController)
        }
    }

    // MARK: - Coordinator (InquiryDelegate)

    @MainActor
    class Coordinator: NSObject, InquiryDelegate {
        let onComplete: (String, String) -> Void
        let onCancel: () -> Void
        let onEvent: (InquiryEvent) -> Void
        let onError: (Error) -> Void

        init(onComplete: @escaping (String, String) -> Void,
             onCancel: @escaping () -> Void,
             onEvent: @escaping (InquiryEvent) -> Void,
             onError: @escaping (Error) -> Void) {
            self.onComplete = onComplete
            self.onCancel = onCancel
            self.onEvent = onEvent
            self.onError = onError
        }

        func inquiryComplete(inquiryId: String, status: String, fields: [String : InquiryField]) {
            onComplete(inquiryId, status)
        }

        func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
            onCancel()
        }

        func inquiryEventOccurred(event: InquiryEvent) {
            onEvent(event)
        }

        func inquiryError(_ error: Error) {
            onError(error)
        }
    }
}
