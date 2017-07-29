//
//  Message.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/28/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var senderProfilePicture: String?
    var sender: String?
    var message: String?
    
    init(snapshot: DataSnapshot) {
        if let messageData = snapshot.value as? [String : Any] {
            senderProfilePicture = messageData["profilePicture"] as? String
            sender = messageData["sender"] as? String
            message = messageData["text"] as? String
        }
    }
    
    
}


