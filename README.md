# Persona Inquiry SDK iOS Demo App

If you haven't already, [sign up for a free Persona account](https://withpersona.com/dashboard/signup) which comes with Sandbox access.

## Requirements

The only requirements to get up and running are:
- [Xcode 11 or later](https://developer.apple.com/xcode)
- [Cocoapods](https://cocoapods.org) for installing the dependencies

## Locate your Template ID

1. Login to the Persona Dashboard and go to the [Development section](https://withpersona.com/dashboard/development).

2. Select the Template you want to use from the drop-down and copy the Template ID for later.

## Configure this project

1. Clone this repository.

```
git clone git@github.com:persona-id/persona-ios-sdk.git
# or
git clone https://github.com/persona-id/persona-ios-sdk.git
```

2. Using the Terminal, navigate to the folder where the repository was cloned, and then go into the `DemoApp` folder.

```
cd DemoApp
```

3. Install the dependencies.

```
pod install --repo-update
```

4. Open the newly created workspace

```
xed .
```

5. Enter your template ID in `WelcomeViewController.swift` on line 23 as the value for `personaInquiryTemplateId`

6. Run the project and test it out!

# Documentation

If you'd like the more information, please [check out the documentation](https://docs.withpersona.com/docs/native-mobile-sdks) or if you have questions, feel free to contact support@withpersona.com.
