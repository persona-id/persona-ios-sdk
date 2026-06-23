# AGENTS.md

Guidance for AI coding agents (and humans who like precise docs) working in
this repository. Keep this file up to date when the project structure or the
SDK integration changes.

## What this repo is

A single-target iOS example app demonstrating the
[Persona Inquiry SDK](https://docs.withpersona.com/docs/ios-sdk-v2-integration-guide)
integrated **two ways**: SwiftUI and UIKit. It is a reference/sample — there is
no production logic, no networking of our own, and no test suite.

## Project layout

- Xcode project: `PersonaExample/PersonaExample.xcodeproj`
- Scheme: `PersonaExample` (shared)
- Source root: `PersonaExample/PersonaExample/`
  - `App/PersonaExampleApp.swift` — `@main` SwiftUI `App` (no storyboard/AppDelegate)
  - `Configuration/PersonaConfiguration.swift` — the **only** place to set the template ID and environment
  - `Home/HomeView.swift` — entry screen linking to both examples
  - `SwiftUIExample/SwiftUIInquiryView.swift` — SwiftUI integration
  - `UIKitExample/UIKitInquiryViewController.swift` — UIKit integration (the real SDK code)
  - `UIKitExample/UIKitInquiryView.swift` — `UIViewControllerRepresentable` bridge into SwiftUI
  - `Shared/` — `InquiryOutcome` (shared result model), `InquiryResultView`, `ConfigurationHint`

## Build & verify

```sh
xcodebuild build \
  -project PersonaExample/PersonaExample.xcodeproj \
  -scheme PersonaExample \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

Simulator builds need no code signing. There are no unit tests. Optional lint:
`swiftlint` from the repo root (config: `.swiftlint.yml`).

## Dependency

- Persona SDK via **Swift Package Manager** only.
- Package: `https://github.com/persona-id/inquiry-ios-2`
- Product: `PersonaInquirySDK2`; import as `import Persona2`
- Pinned to **3.2.0** in
  `PersonaExample.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`
  (committed on purpose). To bump: change the requirement in `project.pbxproj`
  (`XCRemoteSwiftPackageReference`) and re-resolve.

## SDK API quick reference (verified against 3.2.0)

UIKit:

```swift
Inquiry.from(templateId: "itmpl_…", delegate: self)
    .environment(.sandbox)        // Environment: .sandbox | .production
    .build()
    .start(from: viewController)
```

`InquiryDelegate` (note `inquiryError` takes **`PersonaError`**, not `Error`, in 3.x):

```swift
func inquiryComplete(inquiryId: String, status: String, fields: [String: InquiryField])
func inquiryCanceled(inquiryId: String?, sessionToken: String?)
func inquiryError(_ error: PersonaError)
func inquiryEventOccurred(event: InquiryEvent)   // optional, has a default impl
```

SwiftUI view modifier (overloads also exist for `inquiryId:`, `inquiryTemplateVersion:`, `oneTimeCode:`):

```swift
.personaInquiry(
    isPresented: Binding<Bool>,
    inquiryTemplate: String,
    builder: ((InquiryTemplateBuilder) -> InquiryTemplateBuilder)? = nil,
    onEvent: ((InquiryEvent) -> Void)? = nil,
    onResult: ((PersonaResult) -> Void)? = nil
)
```

`PersonaResult` is `.complete(Complete)` / `.canceled(Canceled)` / `.errored(PersonaError)`.
`Complete` has `inquiryId`, `status`, `fields: [String: InquiryField]`.
`InquiryField` is an enum (`.string`, `.int`, `.date`, …) with a `toString() -> String?`
helper — see `InquiryFieldItem.items(from:)` in `Shared/InquiryOutcome.swift`.

## Conventions & gotchas

- **Adding files:** the target uses a *file-system–synchronized* group
  (`PBXFileSystemSynchronizedRootGroup`, requires Xcode 16+). Any file placed
  under `PersonaExample/PersonaExample/` is automatically compiled — you do
  **not** edit `project.pbxproj` to add sources.
- **`Info.plist` is special:** it lives in the synchronized folder but is
  excluded from Copy Bundle Resources via a
  `PBXFileSystemSynchronizedBuildFileExceptionSet` in `project.pbxproj`. Don't
  remove that exception or the build fails with "Multiple commands produce
  Info.plist". The plist is merged with generated keys (`GENERATE_INFOPLIST_FILE = YES`).
- **No client-side theming in 3.x:** there is no `InquiryTheme` API; theming is
  server-driven (or via `themeSetId`). Don't reintroduce `.theme(...)`.
- **Resilient enums:** `PersonaResult` and `InquiryField` come from a binary
  framework. Exhaustive `switch`es need `@unknown default` (already present).
- **Swift language mode:** the project builds in Swift 5 mode (`SWIFT_VERSION = 5.0`).
- Keep both examples behaviorally identical — if you change one path's UX,
  mirror it in the other and keep the shared `InquiryResultView`.
- Don't commit a real template ID; `PersonaConfiguration.templateID` stays a placeholder.
