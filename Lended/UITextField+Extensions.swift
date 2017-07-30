//
//  UITextField+Extensions.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/21/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func createRoundedTextFieldCorners() {
        layer.cornerRadius = 7
        clipsToBounds = true
    }
    
    @IBInspectable var placeHolderTextColor: UIColor? {
        set {
            let placeholderText = self.placeholder != nil ? self.placeholder! : ""
            attributedPlaceholder = NSAttributedString(string:placeholderText, attributes:[NSForegroundColorAttributeName: newValue!])
        }
        get{
            return self.placeHolderTextColor
        }
    }
}
