//
//  Library.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/21/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import Foundation

class Library: NSObject {
  
  var name: String?
  var legalDescription: String?
  
  init(object: [String : String]) {
    name = object["Title"]
    legalDescription = object["FooterText"]
  }
}
