//
//  ContactProfileViewController.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 8/9/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase

class ContactProfileViewController: UIViewController {
  
  var ref: DatabaseReference!
  var person: Person?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
  }
  
  @IBAction func tmp(_ sender: UIButton) {
    
    guard let currentUserId = Auth.auth().currentUser?.uid, let userId = person?.personID  else {
      return
    }
    
    ref.child(FirebaseKeys.users).child(currentUserId).child(FirebaseKeys.chatRooms).observeSingleEvent(of: .value, with: { (snapshot) in
      let enumerator = snapshot.children
      var isNewChat = true
      while let chatRoomSnapshot = enumerator.nextObject() as? DataSnapshot {
        if chatRoomSnapshot.value as? String == userId {
          self.ref.child(FirebaseKeys.chatRooms).child(chatRoomSnapshot.key).observeSingleEvent(of: .value, with: { (crsn) in
            let chatRoom = ChatRoom(snapshot: crsn)
            if let messageVC = self.storyboard?.instantiateViewController(withIdentifier: MESSAGE_VC_STORYBOARD_IDENTIFIER) as? MessageViewController {
              messageVC.chatRoom = chatRoom
              self.navigationController?.pushViewController(messageVC, animated: true)
            }
          })
          isNewChat = false
          break;
        }
      }
      if isNewChat {
        if let messageVC = self.storyboard?.instantiateViewController(withIdentifier: MESSAGE_VC_STORYBOARD_IDENTIFIER) as? MessageViewController {
          messageVC.person = self.person
          self.navigationController?.pushViewController(messageVC, animated: true)
        }
      }
    })
    
    
    
  }
  
  
}
