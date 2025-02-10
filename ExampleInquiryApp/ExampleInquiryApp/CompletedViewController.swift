//
//  CompletedViewController.swift
//  ExampleInquiryApp
//
//  Created by Jacob Lange on 2/10/25.
//

import UIKit

final class CompletedViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = """
            Inquiry completed!
            Welcome back to the example app
        """
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
