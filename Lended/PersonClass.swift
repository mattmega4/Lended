//
//  PersonClass.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/22/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import Foundation

class PersonClass {
    
    var personID: String
    var personName: String?
    var phoneNumber: Int?
    var emailAdy: String?
    var amount: Double?
    
    init(id: String, personDict: [String: Any]) {
        
        personID = id
        personName = personDict["name"] as? String
        phoneNumber = personDict["number"] as? Int
        emailAdy = personDict["email"] as? String
        amount = personDict["amount"] as? Double
        
    }

}

