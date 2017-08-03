//
//  Event.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/28/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase

class Event: NSObject {
  
  var eventID: String?
  var chatRoomID: String?
  var eventName: String?
  var members = [Person]()
  var total: Double?
  var currencies: [String]?
  var active: Bool?
  
  init(snapshot: DataSnapshot) {
    eventID = snapshot.key
    if let eventDict = snapshot.value as? [String : Any] {
      eventID = eventDict[FirebaseKeys.eventID] as? String
      chatRoomID = eventDict[FirebaseKeys.eventChatRoomID] as? String
      eventName = eventDict[FirebaseKeys.eventName] as? String
      total = eventDict[FirebaseKeys.eventTotal] as? Double
      currencies = eventDict[FirebaseKeys.eventCurrencies] as? [String]
      active = eventDict[FirebaseKeys.eventActive] as? Bool
      if let memb = eventDict[FirebaseKeys.eventMembers] as? [DataSnapshot] {
        for aPerson in memb {
          let person = Person(snapshot: aPerson)
          members.append(person)
        }
      }
    }
  }
  
}
