//
//  UIColor.swift
//  DemoApp
//
//  Created by Paulo Fierro on 9/29/20.
//

import UIKit

extension UIColor {

    /// Returns a color defined in the Assets catalog
    convenience init?(personaColor color: PersonaColor) {
        self.init(named: color.rawValue, in: nil, compatibleWith: nil)
    }
}

/// The colors found in the Assets catalog
enum PersonaColor: String {
    case background, alternateBackground, error, primaryLabel, secondaryLabel, darkLabel
}
