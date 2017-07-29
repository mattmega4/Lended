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
        let enumerator = snapshot.childSnapshot(forPath: "participants").children
        while let participantSnapshot = enumerator.nextObject() as? DataSnapshot {
            let participant = Person(snapshot: participantSnapshot)
            participants.append(participant)
        }
        
        if let chatRoomDict = snapshot.value as? [String : Any] {
            latestMessage = chatRoomDict["message"] as? String
            if let senderSnapshot = chatRoomDict["latestSender"] as? DataSnapshot {
                latestSender = Person(snapshot: senderSnapshot)
            }
        }
    }

    
    
    
}
