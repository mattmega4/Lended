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
        if let personData = snapshot.value as? [String : Any] {
            profilePicture = personData["profilePicture"] as? String
            personName = personData["name"] as? String
            phoneNumber = personData["number"] as? Int
            emailAdy = personData["email"] as? String
            amount = personData["amount"] as? Double
            chatRoomID = personData["chatRoomID"] as? String
        }
        personID = snapshot.key
    }
    
    
}
