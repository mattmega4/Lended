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
      senderProfilePicture = messageDict[FirebaseKeys.profilePicture] as? String
      sender = messageDict[FirebaseKeys.messageSender] as? String
      senderId = messageDict[FirebaseKeys.senderID] as? String
      message = messageDict[FirebaseKeys.messageText] as? String
      messageID = messageDict[FirebaseKeys.textID] as? String // confirm later
    }
  }
}


