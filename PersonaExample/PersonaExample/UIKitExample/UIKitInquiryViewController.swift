import Persona2
import UIKit

/// Launches a Persona inquiry from UIKit using the builder API:
/// `Inquiry.from(templateId:delegate:).environment(_:).build().start(from:)`.
///
/// Results arrive through `InquiryDelegate`. This controller maps each delegate
/// callback into the shared ``InquiryOutcome`` and forwards it via ``onOutcome``
/// so the SwiftUI layer can present the same result screen.
final class UIKitInquiryViewController: UIViewController {

    /// Called when the inquiry finishes (completed, canceled, or errored).
    var onOutcome: ((InquiryOutcome) -> Void)?

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Verify your identity with a Persona inquiry launched from UIKit."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var startButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = "Start verification"
        config.buttonSize = .large
        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.startInquiry()
        })
        button.isEnabled = PersonaConfiguration.isConfigured
        return button
    }()

    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Set your template ID in PersonaConfiguration.swift to enable verification."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let imageView = UIImageView(image: UIImage(systemName: "person.text.rectangle"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .tintColor
        imageView.preferredSymbolConfiguration = .init(pointSize: 56)

        hintLabel.isHidden = PersonaConfiguration.isConfigured

        let stack = UIStackView(arrangedSubviews: [imageView, descriptionLabel, startButton, hintLabel])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }

    /// Builds and presents the inquiry. This is the core UIKit integration.
    private func startInquiry() {
        Inquiry.from(templateId: PersonaConfiguration.templateID, delegate: self)
            .environment(PersonaConfiguration.environment)
            .build()
            .start(from: self)
    }
}

// MARK: - InquiryDelegate

extension UIKitInquiryViewController: InquiryDelegate {

    func inquiryComplete(inquiryId: String, status: String, fields: [String: InquiryField]) {
        onOutcome?(.completed(
            inquiryID: inquiryId,
            status: status,
            fields: InquiryFieldItem.items(from: fields)
        ))
    }

    func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        onOutcome?(.canceled)
    }

    func inquiryError(_ error: PersonaError) {
        onOutcome?(.error(message: error.localizedDescription))
    }
}
