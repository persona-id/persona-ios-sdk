//
//  ViewController.swift
//  ExampleInquiryApp
//
//  Created by Jacob Lange on 2/10/25.
//

import UIKit
import Persona2

private let inquiryTemplateToken: String = "itmpl_Ygs16MKTkA6obnF8C3Rb17dm"

final class MainViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello from the example app"
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start inquiry", for: .normal)
        button.addTarget(self, action: #selector(startInquiryTapped), for: .touchUpInside)
        return button
    }()

    private var currentInquiry: Inquiry?
    private var shouldCancelInquiryOnBack = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12)
        ])
    }
}

// MARK: - InquiryDelegate

extension MainViewController: InquiryDelegate {
    func inquiryComplete(inquiryId: String, status: String, fields: [String : Persona2.InquiryField]) {
        navigationController?.setViewControllers([self, CompletedViewController()], animated: true)
        currentInquiry = nil
    }
    
    func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        navigationController?.popToViewController(self, animated: true)
        currentInquiry = nil
    }
    
    func inquiryError(_ error: any Error) {
        navigationController?.popToViewController(self, animated: true)
        currentInquiry = nil
    }
}

// MARK: - PersonaInlineDelegate

extension MainViewController: PersonaInlineDelegate {
    func navigationStateDidUpdate(navigationState: PersonaInlineNavigationState) {
        guard let personaInlineViewController = navigationController?.topViewController as? PersonaInlineViewController else {
            print("Could not find persona inline view controller")
            return
        }

        shouldCancelInquiryOnBack = navigationState.backButtonEnabled == false && navigationState.cancelButtonEnabled
        personaInlineViewController.navigationItem.leftBarButtonItem?.isEnabled = navigationState.backButtonEnabled || shouldCancelInquiryOnBack
    }
}

// MARK: - Private

extension MainViewController {

    @objc
    private func startInquiryTapped() {
        currentInquiry = Inquiry
            .from(templateId: inquiryTemplateToken, delegate: self)
            .environment(.sandbox) // Note: for testing purposes only, change to production for live flows
            .build()

        guard let personaInlineViewController = currentInquiry?.startInline() else {
            print("Error, this can happen when startInline is called more than once on a given inquiry instance")
            return
        }

        personaInlineViewController.navigationItem.title = "Identity Verification"
        personaInlineViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        personaInlineViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "questionmark.circle"),
            style: .plain,
            target: self,
            action: #selector(helpButtonTapped)
        )
        personaInlineViewController.delegate = self
        navigationController?.pushViewController(personaInlineViewController, animated: true)
    }

    @objc
    private func backButtonTapped() {
        guard let personaInlineViewController = navigationController?.topViewController as? PersonaInlineViewController,
            let currentInquiry
        else {
            print("Could not find persona inline view controller or current inquiry")
            return
        }

        guard shouldCancelInquiryOnBack else {
            personaInlineViewController.navigateBack()
            return
        }

        currentInquiry.cancel()
    }

    @objc
    private func helpButtonTapped() {
        let alert = UIAlertController(
            title: "Example",
            message: "This alert is controlled by the app not the persona sdk!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cool", style: .default))
        navigationController?.present(alert, animated: true)
    }
}
