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
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ref.child("chatRooms").removeAllObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFirebaseData()
    }


    
    func loadFirebaseData() {
        
        ref.child("chatRooms").observe(.value, with: { (snapshot) in
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
        }
        else if chatRoom.participants.count > 2 {
            cell.senderName.text = "Group"
        }
        cell.latestMessageLabel.text = chatRoom.latestMessage
        

        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
