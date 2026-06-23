import Persona2
import Foundation

/// A UI-friendly representation of how an inquiry finished.
///
/// The SwiftUI example (via `onResult:`) and the UIKit example (via
/// `InquiryDelegate`) both map the SDK's raw callbacks into this single type so
/// they can share one result screen — ``InquiryResultView``.
enum InquiryOutcome: Identifiable {

    /// The individual completed the inquiry. `status` reflects the inquiry
    /// status (for example `"completed"`), and `fields` are the collected
    /// values, flattened for display.
    case completed(inquiryID: String, status: String, fields: [InquiryFieldItem])

    /// The individual canceled before finishing.
    case canceled

    /// Something went wrong. `message` is a human-readable description.
    case error(message: String)

    var id: String {
        switch self {
        case let .completed(inquiryID, _, _): "completed-\(inquiryID)"
        case .canceled: "canceled"
        case let .error(message): "error-\(message)"
        }
    }

    /// A short title suitable for a navigation bar or header.
    var title: String {
        switch self {
        case .completed: "Inquiry complete"
        case .canceled: "Inquiry canceled"
        case .error: "Inquiry error"
        }
    }
}

/// A single field returned by an inquiry, flattened to strings for display.
struct InquiryFieldItem: Identifiable {
    let id = UUID()
    let name: String
    let value: String
}

extension InquiryFieldItem {

    /// Converts the SDK's `[String: InquiryField]` dictionary into a sorted list
    /// of displayable items, dropping any fields without a value.
    ///
    /// `InquiryField` is an enum of typed cases (`.string`, `.int`, `.date`, …);
    /// its `toString()` helper renders any case to an optional `String`.
    static func items(from fields: [String: InquiryField]) -> [InquiryFieldItem] {
        fields
            .compactMap { name, field in
                guard let value = field.toString(), !value.isEmpty else { return nil }
                return InquiryFieldItem(name: name, value: value)
            }
            .sorted { $0.name < $1.name }
    }
}
