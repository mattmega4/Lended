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
  var senderId: String?
  var message: String?
  var messageID: String? // confirm later
  
  
  init(snapshot: DataSnapshot) {
    if let messageDict = snapshot.value as? [String : Any] {
      senderProfilePicture = messageDict["profilePicture"] as? String
      sender = messageDict["sender"] as? String
      senderId = messageDict["senderId"] as? String
      message = messageDict["text"] as? String
      messageID = messageDict["textID"] as? String // confirm later
    }
  }
  
  
}


