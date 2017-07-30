//
//  UIImageView+Extensions.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/21/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  func createRoundImageView() {
    layer.cornerRadius = frame.size.width/2
    clipsToBounds = true
  }
}
