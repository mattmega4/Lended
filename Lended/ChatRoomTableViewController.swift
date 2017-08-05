//
//  ChatRoomTableViewController.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/28/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ChatRoomTableViewController: UITableViewController {
  
  let chatRoomCellIdentifier = "chatRoomCell"
  
  var ref: DatabaseReference!
  var chatRoomIDs = [String]()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ref = Database.database().reference()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 500
    self.clearsSelectionOnViewWillAppear = false
    setNavBar()
    title = "Messaging"
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    ref.child(FirebaseKeys.chatRooms).removeAllObservers()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadFirebaseData()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    if let currentUserId  = Auth.auth().currentUser?.uid {
      ref.child(FirebaseKeys.users).child(currentUserId).child(FirebaseKeys.chatRooms).removeAllObservers()
    }
    ref.child(FirebaseKeys.chatRooms).removeAllObservers()
  }
  
  
  // MARK: - Firebase Methods
  
  func loadFirebaseData() {
    FirebaseUtility.shared.getChatRoomIDs { (chatRoomIds, errMessage) in
      if let theChatRoomIds = chatRoomIds {
        self.chatRoomIDs = theChatRoomIds
        self.tableView.reloadData()
      }
      
    }
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chatRoomIDs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: chatRoomCellIdentifier, for: indexPath) as! ChatRoomTableViewCell
    let chatRoomId = chatRoomIDs[indexPath.row]
    
    FirebaseUtility.shared.getChatRoomWith(chatRoomId: chatRoomId) { (chatRoom, errMessage) in
      cell.chatRoom = chatRoom
        if chatRoom.participants.count == 2 {
          for aPerson in chatRoom.participants {
            if aPerson.personID != Auth.auth().currentUser?.uid {
              cell.senderName.text = aPerson.personName
              if let imageString = aPerson.profilePicture {
                let imageURL = URL(string: imageString)
                cell.profileThumbView.kf.setImage(with: imageURL)
              }
            }
          }
        } else if chatRoom.participants.count > 2 {
          cell.senderName.text = "Group"
        }
        cell.latestMessageLabel.text = chatRoom.latestMessage
    }
    
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // let chatRoomId = chatRoomIDs[indexPath.row]
    if let cell = tableView.cellForRow(at: indexPath) as? ChatRoomTableViewCell {
      if let chatRoom = cell.chatRoom {
        if let messageVC = storyboard?.instantiateViewController(withIdentifier: MESSAGE_VC_STORYBOARD_IDENTIFIER) as? MessageViewController {
          messageVC.chatRoom = chatRoom
          self.navigationController?.pushViewController(messageVC, animated: true)
        }
        
      }
    }
  }
}
