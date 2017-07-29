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

    var eventID: String
    var chatRoomID: String?
    var members: [Person]?
    var total: Double?
    var currencies: [String]?
    var active: Bool?


    init(snapshot: DataSnapshot) {
        
        if let eventDict = snapshot.value as? [String : Any] {
            
            chatRoomID = eventDict["chatRoomID"] as? String
            members = eventDict["members"] as? [Person] // fix this
            total = eventDict["total"] as? Double
            currencies = eventDict["currencies"] as? [String]
            active = eventDict["active"] as? Bool
        }
        
        eventID = snapshot.key
    }
    
    
    
    
    
    
    
}
