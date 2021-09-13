//
//  ViewController.swift
//  DemoApp
//
//  Created by Paulo Fierro on 9/24/20.
//

import Persona
import UIKit

/// The start view
class WelcomeViewController: UIViewController {

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var humanButton: UIButton!
    @IBOutlet private weak var humanLabel: UILabel!
    @IBOutlet private weak var pawsonaButton: UIButton!
    @IBOutlet private weak var pawsonaLabel: UILabel!
    @IBOutlet private weak var footerTextView: UITextView!

    // TODO: Set to your Inquiry Template ID string here!
    // Please see the README that explains how to get this Inquiry Template ID
    private let personaInquiryTemplateId: String // = "tmpl_example"

    // The identifier to the Storyboard segue
    private let showInquirySegueIdentifier = "showInquiry"

    override func viewDidLoad() {
        super.viewDidLoad()

        humanButton.imageView?.contentMode = .scaleAspectFit
        pawsonaButton.imageView?.contentMode = .scaleAspectFit

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

    /// Handles taps on the Pawsona. Starts an Inquiry with a custom theme.
    @IBAction private func pawsonaButtonTapped(_ sender: Any) {
        startInquiry(theme: createPawsonaTheme())
    }
}

// MARK: - Persona SDK Delegate Methods

extension WelcomeViewController: InquiryDelegate {

    /// Starts the Inquiry
    private func startInquiry(theme: InquiryTheme? = nil) {
        // Start the Inquiry
        Inquiry(
            config: InquiryConfiguration(
                templateId: personaInquiryTemplateId,
                environment: .sandbox,
                theme: theme
            ),
            delegate: self
        ).start(from: self)
    }

    /// Called on a successful inquiry.
    func inquirySuccess(inquiryId: String, attributes: Attributes, relationships: Relationships) {
        showResults(with:
            InquiryResultsViewModel(
                success: true,
                inquiryId: inquiryId,
                attributes: attributes,
                relationships: relationships
            )
        )
    }

    /// Called when the invidual fails the inquiry.
    func inquiryFailed(inquiryId: String, attributes: Attributes, relationships: Relationships) {
        showResults(with:
            InquiryResultsViewModel(
                success: false,
                inquiryId: inquiryId,
                attributes: attributes,
                relationships: relationships
            )
        )
    }

    /// Called when the individual cancels the inquiry.
    func inquiryCancelled() {
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

// MARK: - Helper Methods

extension WelcomeViewController {

    /// Creates a theme for the Pawsona use case
    private func createPawsonaTheme() -> InquiryTheme {
        guard let backgroundColor = UIColor(personaColor: .background),
            let alternateBackgroundColor = UIColor(personaColor: .alternateBackground),
            let errorColor = UIColor(personaColor: .error),
            let darkLabelColor = UIColor(personaColor: .darkLabel),
            let primaryLabelColor = UIColor(personaColor: .primaryLabel),
            let secondaryLabelColor = UIColor(personaColor: .secondaryLabel),
            let rubikFont = UIFont(personaFont: .rubik, size: 17),
            let londrinaFont = UIFont(personaFont: .londrina, size: 17) else {
                fatalError("Could not create custom colors.")
        }

        var theme = InquiryTheme()
        theme.backgroundColor = backgroundColor
        theme.textFieldBorderColor = darkLabelColor
        theme.buttonBackgroundColor = primaryLabelColor
        theme.buttonTouchedBackgroundColor = errorColor
        theme.buttonDisabledBackgroundColor = primaryLabelColor.withAlphaComponent(0.25)
        theme.closeButtonTintColor = darkLabelColor
        theme.cancelButtonBackgroundColor = primaryLabelColor
        theme.selectedCellBackgroundColor = alternateBackgroundColor.withAlphaComponent(0.25)
        theme.accentColor = alternateBackgroundColor
        theme.darkPrimaryColor = darkLabelColor
        theme.primaryColor = alternateBackgroundColor
        theme.titleTextColor = darkLabelColor
        theme.bodyTextColor = primaryLabelColor
        theme.formLabelTextColor = secondaryLabelColor
        theme.buttonTextColor = .white
        theme.pickerTextColor = primaryLabelColor
        theme.textFieldTextColor = primaryLabelColor
        theme.footnoteTextColor = primaryLabelColor

        theme.textFieldCornerRadius = 16
        theme.buttonCornerRadius = 16

        theme.titleTextFont = londrinaFont.withSize(36)
        theme.cardTitleTextFont = londrinaFont.withSize(20)
        theme.bodyTextFont = londrinaFont.withSize(24)
        theme.footnoteTextFont = rubikFont.withSize(14)
        theme.formLabelTextFont = rubikFont.withSize(16)
        theme.textFieldFont = rubikFont.withSize(16)
        theme.textFieldPlaceholderFont = rubikFont.withSize(16)
        theme.pickerTextFont = rubikFont.withSize(18)
        theme.buttonFont = rubikFont.withSize(18)
        return theme
    }
}
