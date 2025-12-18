//
//  UIFont.swift
//  DemoApp
//
//  Created by Paulo Fierro on 9/29/20.
//

import UIKit

extension UIFont {

    /// Returns a font embedded in the app
    convenience init?(personaFont font: PersonaFont, size: CGFloat) {
        self.init(name: font.rawValue, size: size)
    }
}

/// The fonts embedded in the app
enum PersonaFont: String {
    case rubik = "Rubik-Regular"
    case londrina = "LondrinaSolid-Regular"
}
