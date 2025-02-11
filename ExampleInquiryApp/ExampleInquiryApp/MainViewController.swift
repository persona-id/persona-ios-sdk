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
    }
    
    func inquiryCanceled(inquiryId: String?, sessionToken: String?) {
        navigationController?.popToViewController(self, animated: true)
    }
    
    func inquiryError(_ error: any Error) {
        navigationController?.popToViewController(self, animated: true)
    }
}

// MARK: - PersonaInlineDelegate

extension MainViewController: PersonaInlineDelegate {
    func navigationStateDidUpdate(navigationState: PersonaInlineNavigationState) {
        guard let personaInlineViewController = navigationController?.topViewController as? PersonaInlineViewController else {
            print("Could not find persona inline view controller")
            return
        }
        personaInlineViewController.navigationItem.leftBarButtonItem?.isEnabled = navigationState.backButtonEnabled
        // use `navigationState.cancelButtonEnabled` if you want users to be able to dismiss the inquiry
    }
}

// MARK: - Private

extension MainViewController {

    @objc
    private func startInquiryTapped() {
        let inquiry = Inquiry
            .from(templateId: inquiryTemplateToken, delegate: self)
            .environment(.sandbox) // Note: for testing purposes only, change to production for live flows
            .build()

        guard let personaInlineViewController = inquiry.startInline() else {
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
        guard let personaInlineViewController = navigationController?.topViewController as? PersonaInlineViewController else {
            print("Could not find persona inline view controller")
            return
        }
        personaInlineViewController.navigateBack()
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
