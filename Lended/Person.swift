//
//  Person.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/28/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase

class Person: NSObject {
  
  var personID: String
  var profilePicture: String?
  var personName: String?
  var phoneNumber: Int?
  var emailAdy: String?
  var amount: Double?
  var chatRoomID: String?
  
  
  init(snapshot: DataSnapshot) {
    if let personDict = snapshot.value as? [String : Any] {
      profilePicture = personDict["profilePicture"] as? String
      personName = personDict["name"] as? String
      phoneNumber = personDict["number"] as? Int
      emailAdy = personDict["email"] as? String
      amount = personDict["amount"] as? Double
      chatRoomID = personDict["chatRoomID"] as? String
    }
    personID = snapshot.key
  }
  
  
}
