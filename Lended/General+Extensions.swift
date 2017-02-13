//
//  General+Extensions.swift
//  Lended
//
//  Created by Matthew Singleton on 2/12/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  func createRoundView() {
    layer.cornerRadius = frame.size.width/2
    clipsToBounds = true
  }
}
