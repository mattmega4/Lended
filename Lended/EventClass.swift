//
//  EventClass.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/22/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import Foundation

class EventClass {
    
    var eventID: String
    var members: [PersonClass]?
    var total: Double?
    var currencies: [String]?
    var active: Bool?
    
    init(id: String, eventDict: [String: Any]) {
        
        eventID = id
        members = eventDict["members"] as? [PersonClass]
        total = eventDict["total"] as? Double
        currencies = eventDict["currencies"] as? [String]
        active = eventDict["active"] as? Bool
        
    }
    
}

