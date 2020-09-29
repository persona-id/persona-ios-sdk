//
//  InquiryResultsViewModel.swift
//  DemoApp
//
//  Created by Paulo Fierro on 9/29/20.
//

import Persona
import UIKit

/// Contains the title and result text to display in InquiryViewController.
struct InquiryResultsViewModel {

    let title: String
    private(set) var resultText = NSAttributedString()

    /// The inquiry was completed
    init(success: Bool, inquiryId: String, attributes: Attributes, relationships: Relationships) {
        self.title = success ? "Inquiry succeeded!" : "Inquiry failed."
        self.resultText = convertResult(inquiryId: inquiryId, attributes: attributes, relationships: relationships)
    }

    /// The inquiry was cancelled
    init() {
        self.title = "Inquiry cancelled."
    }

    /// The inquiry was errorred
    init(error: Error) {
        self.title = "Inquiry error."
        self.resultText = NSAttributedString(string: error.localizedDescription)
    }
}

// MARK: - Private Methods

private extension InquiryResultsViewModel {

    /// The attributes to use when displaying a label
    var labelAttributes: [NSAttributedString.Key: Any] {
        guard let labelColor = UIColor(personaColor: .secondaryLabel),
            let labelFont = UIFont(personaFont: .rubik, size: 14) else {
                return [:]
        }

        return [
            .foregroundColor: labelColor,
            .font: labelFont
        ]
    }

    /// The attributes to use when displaying a value
    var valueAttributes: [NSAttributedString.Key: Any] {
        guard let valueColor = UIColor(personaColor: .primaryLabel),
            let valueFont = UIFont(personaFont: .rubik, size: 18) else {
                return [:]
        }

        return [
            .foregroundColor: valueColor,
            .font: valueFont
        ]
    }

    /// Converts an inquiry result into an attributed string to display in a text view
    func convertResult(inquiryId: String, attributes: Attributes, relationships: Relationships) -> NSAttributedString {
        let text = NSMutableAttributedString()
        text.append(addRow(label: "INQUIRY ID", value: inquiryId))
        text.append(addRow(label: "NAME", value: extractName(from: attributes.name)))
        text.append(addRow(label: "ADDRESS", value: extractAddress(from: attributes.address)))
        text.append(addRow(label: "DATE OF BIRTH", value: extractBirthdate(from: attributes.birthdate)))
        text.append(addRow(label: "VERIFICATION STATUS", value: extractStatuses(from: relationships)))
        return text
    }

    /// Returns a label/value pair, styled in an attributed string
    func addRow(label: String, value: String) -> NSAttributedString {
        let text = NSMutableAttributedString(string: "\(label):\n", attributes: labelAttributes)
        text.append(NSAttributedString(string: "\(value)\n\n", attributes: valueAttributes))
        return text
    }

    /// Extracts a name to display from a Name
    func extractName(from name: Name?) -> String {
        guard let name = name else {
            return "-"
        }
        if name.first == nil, name.middle == nil, name.last == nil {
            return "-"
        }

        var text = ""
        if let first = name.first {
            text += first + " "
        }
        if let middle = name.middle {
            text += middle + " "
        }
        if let last = name.last {
            text += last
        }
        return text
    }

    /// Extracts an address to display from an Address
    func extractAddress(from address: Address?) -> String {
        guard let address = address else {
            return "-"
        }
        var text = ""
        if let street1 = address.street1, !street1.isEmpty {
            text += street1 + "\n"
        }
        if let street2 = address.street2, !street2.isEmpty {
            text += street2 + "\n"
        }
        if let city = address.city, !city.isEmpty {
            text += city + ", "
        }
        if let subdivision = address.subdivision, !subdivision.isEmpty {
            text += subdivision + " "
        }
        if let postalCode = address.postalCode, !postalCode.isEmpty {
            text += postalCode
        }
        if let countryCode = address.countryCode, !countryCode.isEmpty {
            if !text.isEmpty {
                text += "\n"
            }
            text += countryCode
        }
        return text
    }

    /// Returns the verification ID and status for each verification that was performed
    func extractStatuses(from relationships: Relationships) -> String {
        guard !relationships.verifications.isEmpty else {
            return "-"
        }

        return relationships.verifications
            .map {
                "\($0.id) - \($0.status)\n"
            }
            .joined(separator: ",")
    }

    /// Returns a formatted birthdate
    func extractBirthdate(from date: Date?) -> String {
        guard let date = date else {
            return "-"
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
