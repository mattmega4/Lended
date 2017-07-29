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
    var members = [Person]()
    var total: Double?
    var currencies: [String]?
    var active: Bool?
    
    // check if correct
    
    init(id: String, snapshot: DataSnapshot) {
        eventID = id
        if let eventDict = snapshot.value as? [String : Any] {
            //            eventID = eventDict["eventID"] as? String
            chatRoomID = eventDict["chatRoomID"] as? String
            total = eventDict["total"] as? Double
            currencies = eventDict["currencies"] as? [String]
            active = eventDict["active"] as? Bool
            if let memb = eventDict["members"] as? [DataSnapshot] {
                for aPerson in memb {
                    let person = Person(snapshot: aPerson)
                    members.append(person)
                }
            }
        }
    }
    
}
