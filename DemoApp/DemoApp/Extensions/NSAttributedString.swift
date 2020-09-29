//
//  PersonaUtils.swift
//  DemoApp
//
//  Created by Paulo Fierro on 9/29/20.
//

import UIKit

extension NSAttributedString {

    /// Returns an attributed string with a link to the Persona site.
    static var personaFooterText: NSAttributedString = {
        guard
            let url = URL(string: "https://withpersona.com/"),
            let color = UIColor(personaColor: .secondaryLabel),
            let font = UIFont(personaFont: .rubik, size: 14) else {
            return NSAttributedString()
        }

        // Center the text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        // Apply the color, font and alignment
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font,
            .paragraphStyle: paragraphStyle
        ]

        // Add the URL and underline the text to the attributes
        var linkAttributes = attributes
        linkAttributes[.link] = url
        linkAttributes[.underlineStyle] = 1

        // Create the strings
        let text = NSMutableAttributedString(
            string: "Paws is a ficticious app made by ",
            attributes: attributes
        )

        let clickableText = NSAttributedString(
            string: "the folks at Persona,",
            attributes: linkAttributes
        )

        let suffix = NSAttributedString(
            string: " to showcase the mobile SDK capabilities. Any similarities with real life are purely coincidental.",
            attributes: attributes
        )

        // Finally, put the string together
        text.append(clickableText)
        text.append(suffix)
        return text
    }()
}
