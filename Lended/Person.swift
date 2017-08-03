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
      profilePicture = personDict[FirebaseKeys.profilePicture] as? String
      personName = personDict[FirebaseKeys.personName] as? String
      phoneNumber = personDict[FirebaseKeys.personPhone] as? Int
      emailAdy = personDict[FirebaseKeys.personEmail] as? String
      amount = personDict[FirebaseKeys.personAmount] as? Double
      chatRoomID = personDict[FirebaseKeys.chatRoomID] as? String // ?
    }
    personID = snapshot.key
  }
  
  
}
