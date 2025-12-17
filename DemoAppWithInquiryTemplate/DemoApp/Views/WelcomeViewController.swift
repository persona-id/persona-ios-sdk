//
//  ViewController.swift
//  DemoApp
//
//  Created by Paulo Fierro on 9/24/20.
//

import Persona2
import PersonaNfc
import PersonaWebRtc
import UIKit

/// The start view
class WelcomeViewController: UIViewController {

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var humanButton: UIButton!
    @IBOutlet private weak var humanLabel: UILabel!
    @IBOutlet private weak var footerTextView: UITextView!

    // TODO: Set to your Inquiry Template ID string here!
    // Please see the README that explains how to get this Inquiry Template ID
    private let personaInquiryTemplateId: String = "" // = "itmpl_example"

    // The identifier to the Storyboard segue
    private let showInquirySegueIdentifier = "showInquiry"

    override func viewDidLoad() {
        super.viewDidLoad()

        humanButton.imageView?.contentMode = .scaleAspectFit

        // Add the attributed footer text
        footerTextView.attributedText = NSAttributedString.personaFooterText
    }
}

// MARK: - Button Handling

extension WelcomeViewController {

    /// Handles taps on the Human. Starts an Inquiry.
    @IBAction private func humanButtonTapped(_ sender: Any) {
        startInquiry()
    }
}

// MARK: - Persona SDK Delegate Methods

extension WelcomeViewController: InquiryDelegate {

    /// Starts the Inquiry
    private func startInquiry(theme: InquiryTheme? = InquiryTheme(themeSource: .server)) {
        // Start the Inquiry
        if personaInquiryTemplateId.starts(with: "itmplv_") {
            Inquiry.from(templateVersion: personaInquiryTemplateId, delegate: self)
                .environment(.sandbox)
                .theme(theme)
                .nfcAdapter(PersonaNfcAdapter())
                .webRtcAdapter(PersonaWebRtcAdapter())
                .build()
                .start(from: self)
        } else {
            Inquiry.from(templateId: personaInquiryTemplateId, delegate: self)
                .environment(.sandbox)
                .theme(theme)
                .nfcAdapter(PersonaNfcAdapter())
                .webRtcAdapter(PersonaWebRtcAdapter())
                .build()
                .start(from: self)
        }
    }

    /// Called when inquiry has finished.
    func inquiryComplete(inquiryId: String, status: String, fields: [String: InquiryField]) {
        showResults(with: InquiryResultsViewModel(
            inquiryId: inquiryId,
            status: status,
            fields: fields
        ))
    }

    /// Called when the individual cancels the inquiry.
    func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        showResults(with: InquiryResultsViewModel())
    }

    /// Called when there is a problem during the Inquiry flow.
    func inquiryError(_ error: Error) {
        showResults(with: InquiryResultsViewModel(error: error))
    }
}

// MARK: - Segue Methods

extension WelcomeViewController {

    /// Shows the inquiry results by passing along the data
    private func showResults(with viewModel: InquiryResultsViewModel) {
        // Call the storyboard segue to show the inquiry. This will
        // pass the configuration on via `prepare(for:sender)` below.
        performSegue(withIdentifier: showInquirySegueIdentifier, sender: viewModel)
    }

    /// Passes the inquiry configuration to the InquiryViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewModel = sender as? InquiryResultsViewModel,
            let destination = segue.destination as? InquiryViewController else {
                return
        }
        destination.viewModel = viewModel
    }

    /// Allows unwinding back to this screen
    @IBAction func unwindToStart(_ sender: UIStoryboardSegue) {
        // Intentionally left blank.
    }
}

// MARK: - Text View Delegate Methods

extension WelcomeViewController: UITextViewDelegate {

    /// Handle taps on the URL
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }
}
