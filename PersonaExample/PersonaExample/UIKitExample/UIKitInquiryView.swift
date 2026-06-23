import SwiftUI

/// Hosts the UIKit example inside the SwiftUI navigation stack.
///
/// This keeps both examples reachable from the same `NavigationStack` and lets
/// the UIKit flow reuse the shared ``InquiryResultView``. The actual SDK
/// integration lives in ``UIKitInquiryViewController``; this view only bridges
/// it into SwiftUI with `UIViewControllerRepresentable`.
struct UIKitInquiryView: View {

    /// The result of the most recent inquiry, shown in a sheet when non-nil.
    @State private var outcome: InquiryOutcome?

    var body: some View {
        InquiryControllerBridge { outcome in
            self.outcome = outcome
        }
        .ignoresSafeArea()
        .navigationTitle("UIKit")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $outcome) { outcome in
            InquiryResultView(outcome: outcome)
        }
    }
}

/// Wraps ``UIKitInquiryViewController`` so it can live in a SwiftUI hierarchy.
private struct InquiryControllerBridge: UIViewControllerRepresentable {
    let onOutcome: (InquiryOutcome) -> Void

    func makeUIViewController(context: Context) -> UIKitInquiryViewController {
        let controller = UIKitInquiryViewController()
        controller.onOutcome = onOutcome
        return controller
    }

    func updateUIViewController(_ controller: UIKitInquiryViewController, context: Context) {
        controller.onOutcome = onOutcome
    }
}

#Preview {
    NavigationStack {
        UIKitInquiryView()
    }
}
