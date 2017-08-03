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
  var chatRooms = [ChatRoom]()
  
  
  
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
  
  
  // duno
  
  func loadFirebaseData() {
    
    ref.child(FirebaseKeys.chatRooms).observe(.value, with: { (snapshot) in
      if snapshot.hasChildren() {
        self.chatRooms.removeAll()
        if let children = snapshot.children.allObjects as? [DataSnapshot] {
          for childSnapshot in children {
            let chatRoom = ChatRoom(snapshot: childSnapshot)
            self.chatRooms.append(chatRoom)
          }
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        }
        
      }
    })
  }
  
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chatRooms.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: chatRoomCellIdentifier, for: indexPath) as! ChatRoomTableViewCell
    let chatRoom = chatRooms[indexPath.row]
    
    // Configure the cell...
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
    
    
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let chatRoom = chatRooms[indexPath.row]
    
    if let messageVC = storyboard?.instantiateViewController(withIdentifier: MESSAGE_VC_STORYBOARD_IDENTIFIER) as? MessageViewController {
      messageVC.chatRoom = chatRoom
      self.navigationController?.pushViewController(messageVC, animated: true)
    }
  }
}
