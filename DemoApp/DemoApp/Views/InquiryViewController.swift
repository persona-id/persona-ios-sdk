//
//  InquiryViewController.swift
//  DemoApp
//
//  Created by Paulo Fierro on 9/29/20.
//

import Persona2
import UIKit

/// Shows the Inquiry results
class InquiryViewController: UIViewController {

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var resultTextView: UITextView!
    @IBOutlet private weak var footerTextView: UITextView!

    /// The data from the Inquiry result
    var viewModel: InquiryResultsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show the inquiry data
        titleLabel.text = viewModel.title
        resultTextView.attributedText = viewModel.resultText

        styleTextViews()
    }

    /// Add some custom styling to the text views
    private func styleTextViews() {
        // Tweak the insets and corner radius for the results
        let padding: CGFloat = 20
        resultTextView.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        resultTextView.scrollIndicatorInsets = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        resultTextView.layer.cornerRadius = 16

        // Hide the result text if there's nothing to show
        if viewModel.resultText.string.isEmpty {
            resultTextView.alpha = 0
        }

        // Add the attributed footer text
        footerTextView.attributedText = NSAttributedString.personaFooterText
    }
}

// MARK: - Text View Delegate Methods

extension InquiryViewController: UITextViewDelegate {

    /// Handle taps on the URL
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }
}
