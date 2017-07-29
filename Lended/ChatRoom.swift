//
//  ChatRoom.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/28/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase

class ChatRoom: NSObject {
    
    var participants = [Person]()
    var latestMessage: String?
    var latestSender: Person?
    
    
    init(snapshot: DataSnapshot) {
        
        if let chatRoomDict = snapshot.value as? [String : Any] {
            
            if let people = chatRoomDict["participants"] as? [DataSnapshot] {
                for aPerson in people {
                    let participant = Person(snapshot: aPerson)
                    participants.append(participant)
                }
            }
            
            latestMessage = chatRoomDict["message"] as? String
            if let senderSnapshot = chatRoomDict["latestSender"] as? DataSnapshot {
                latestSender = Person(snapshot: senderSnapshot)
            }
        }
    }

    
    
    
}
