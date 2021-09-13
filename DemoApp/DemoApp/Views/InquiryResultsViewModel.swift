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
    init(inquiryId: String, status: String, fields: [String: InquiryField]) {
        self.title = "Inquiry completed!"
        self.resultText = convertResult(inquiryId: inquiryId, status: status, fields: fields)
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
    func convertResult(inquiryId: String, status: String, fields: [String: InquiryField]) -> NSAttributedString {
        let text = NSMutableAttributedString()
        text.append(addRow(label: "INQUIRY ID", value: inquiryId))
        text.append(addRow(label: "STATUS", value: status))
        text.append(NSAttributedString(string: "FIELDS:\n", attributes: labelAttributes))

        for (key, field) in fields {
            if let row = fieldToString(label: key, field: field) {
                text.append(row)
            }
        }
        return text
    }

    /// Returns a label/value pair, styled in an attributed string
    func addRow(label: String, value: String) -> NSAttributedString {
        let text = NSMutableAttributedString(string: "\(label):\n", attributes: labelAttributes)
        text.append(NSAttributedString(string: "\(value)\n\n", attributes: valueAttributes))
        return text
    }

    /// Extracts field value if exists and returns styled in an attributed string
    func fieldToString(label: String, field: InquiryField) -> NSAttributedString? {
        // if field has a value, format to an attributed string
        let fieldString: String? = {
            switch field {
            case .string(let value):
                if let value = value {
                    return value
                }
            case .int(let value):
                if let value = value {
                    return "\(value)"
                }
            case .float(let value):
                if let value = value {
                    return "\(value)"
                }
            case .bool(let value):
                if let value = value {
                    return "\(value)"
                }
            case .date(let value), .datetime(let value):
                if let value = value {
                    return "\(value)"
                }
            case .unknown:
                return nil
            @unknown default:
                return nil
            }
            return nil
        }()
        // no field value found, return nil
        guard let fieldString = fieldString else { return nil }

        let text = NSMutableAttributedString(string: "  \(label):\n", attributes: labelAttributes)
        text.append(NSMutableAttributedString(string: "  \(fieldString)\n\n", attributes: valueAttributes))
        return text
    }
}
