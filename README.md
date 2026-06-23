# Persona iOS SDK Example

A small, focused example app that shows how to integrate the
[Persona Inquiry SDK](https://docs.withpersona.com/docs/ios-sdk-v2-integration-guide)
into an iOS app **two ways** — once with **SwiftUI** and once with **UIKit** —
so you can copy whichever fits your codebase.

Both paths launch the same identity-verification flow and render results
through one shared screen, so the only meaningful difference is how each
framework starts an inquiry.

| | SwiftUI | UIKit |
|---|---|---|
| Entry point | [`SwiftUIInquiryView`](PersonaExample/PersonaExample/SwiftUIExample/SwiftUIInquiryView.swift) | [`UIKitInquiryViewController`](PersonaExample/PersonaExample/UIKitExample/UIKitInquiryViewController.swift) |
| How it launches | `.personaInquiry(isPresented:inquiryTemplate:…)` view modifier | `Inquiry.from(templateId:delegate:).build().start(from:)` |
| How results arrive | `onResult:` closure → `PersonaResult` | `InquiryDelegate` callbacks |

## Requirements

- **Xcode 16 or later** (the project uses file-system–synchronized groups)
- **iOS 16 or later** deployment target
- A **Persona account** — [sign up for free](https://withpersona.com/dashboard/signup); it includes Sandbox access

The SDK is added via **Swift Package Manager** and resolves automatically when
you open the project — there is nothing to install.

## Quick start

1. **Clone and open:**

   ```sh
   git clone https://github.com/persona-id/persona-ios-sdk.git
   cd persona-ios-sdk
   open PersonaExample/PersonaExample.xcodeproj
   ```

   Xcode will fetch the Persona SDK package on first open.

2. **Add your Inquiry Template ID.** Open
   [`PersonaConfiguration.swift`](PersonaExample/PersonaExample/Configuration/PersonaConfiguration.swift)
   and replace the placeholder:

   ```swift
   static let templateID = "itmpl_YourTemplateIdHere"
   ```

   Find your template ID in the Persona Dashboard under
   [Integration](https://app.withpersona.com/dashboard/integration) — it looks
   like `itmpl_XXXXXXXXXXXXXXXXX`. Until you set it, the "Start verification"
   buttons stay disabled and the app shows a hint.

3. **Run** on a simulator or device, and pick either the SwiftUI or the UIKit
   example from the home screen.

## How it's organized

```
PersonaExample/PersonaExample/
├── App/PersonaExampleApp.swift          # @main SwiftUI entry point
├── Configuration/PersonaConfiguration.swift  # ← set your template ID here
├── Home/HomeView.swift                  # Picker linking to both examples
├── SwiftUIExample/
│   └── SwiftUIInquiryView.swift         # SwiftUI integration (.personaInquiry)
├── UIKitExample/
│   ├── UIKitInquiryViewController.swift # UIKit integration (Inquiry builder)
│   └── UIKitInquiryView.swift           # Bridges the UIKit VC into SwiftUI
└── Shared/
    ├── InquiryOutcome.swift             # Result model used by both examples
    ├── InquiryResultView.swift          # Shared result screen
    └── ConfigurationHint.swift          # "Set your template ID" notice
```

## The two integrations

### SwiftUI

Attach the `.personaInquiry` modifier and toggle an `isPresented` binding:

```swift
.personaInquiry(
    isPresented: $isPresentingInquiry,
    inquiryTemplate: PersonaConfiguration.templateID,
    builder: { $0.environment(.sandbox) },
    onResult: { result in
        switch result {
        case let .complete(data): // data.inquiryId, data.status, data.fields
        case .canceled:           // dismissed before finishing
        case let .errored(error): // PersonaError
        @unknown default:         break
        }
    }
)
```

### UIKit

Build an inquiry and start it from a view controller that implements
`InquiryDelegate`:

```swift
Inquiry.from(templateId: PersonaConfiguration.templateID, delegate: self)
    .environment(.sandbox)
    .build()
    .start(from: self)

// MARK: InquiryDelegate
func inquiryComplete(inquiryId: String, status: String, fields: [String: InquiryField]) { … }
func inquiryCanceled(inquiryId: String?, sessionToken: String?) { … }
func inquiryError(_ error: PersonaError) { … }
```

## Permissions

The verification flow uses the camera, and may use the microphone, photo
library, location, and NFC depending on your template. The required
`Info.plist` usage-description strings are already set in
[`Info.plist`](PersonaExample/PersonaExample/Info.plist). Adjust the copy to
match your app before shipping.

To enable **NFC passport / eID reading**, add the *Near Field Communication Tag
Reading* capability to the target (Signing & Capabilities) and to your
provisioning profile.

## Privacy configuration

The SDK collects a user's
[IDFV](https://developer.apple.com/documentation/uikit/uidevice/1620059-identifierforvendor)
for fraud prevention. In
[App Store Connect](https://appstoreconnect.apple.com/) → your app → App
Privacy, add a **Device ID** and answer:

- **Usage:** App Functionality (covers fraud prevention)
- **Linked to the user's identity?** Yes
- **Used for tracking?** No

## Documentation & support

- [iOS Integration Guide](https://docs.withpersona.com/docs/ios-sdk-v2-integration-guide)
- [iOS Changelog](https://docs.withpersona.com/ios-sdk-v2-changelog)
- Questions? Email [support@withpersona.com](mailto:support@withpersona.com)

---

Working in this repo with an AI assistant? See [AGENTS.md](AGENTS.md).
