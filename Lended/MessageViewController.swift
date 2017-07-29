//
//  MessageViewController.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/29/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageContainerView: UIView!
    @IBOutlet weak var sendMessageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    let YOU_CELL_IDENTIFIER = "youMessageCell"
    let ME_CELL_IDENTIFIER = "meMessageCell"
    
    var messageArray = [Message]()
    var chatRoom: ChatRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.sendMessageTextField.delegate = self
    }
    

}


extension MessageViewController: UITextFieldDelegate {
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let message = messageArray[row]
        
        if message.sender == Auth.auth().currentUser?.displayName {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ME_CELL_IDENTIFIER, for: indexPath) as! MessageTableViewCell
            
            cell.chatTextLabel.text = message.message
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: YOU_CELL_IDENTIFIER, for: indexPath) as! MessageTableViewCell
        
        
        
        cell.chatTextLabel.text = message.message
        
        if let participantCount = chatRoom?.participants.count {
            if participantCount > 2 {
                cell.profileImageViewHeightConstraint?.constant = 30
                cell.senderNameLabelHeightConstraint?.constant = 20
                cell.senderNameLabel?.text = message.sender
                
                if let profileURLString = message.senderProfilePicture {
                    let profileURL = URL(string: profileURLString)
                    let placeholder = InitialsImageFactory.imageWith(name: message.sender)
                    cell.senderProfileImageView?.kf.setImage(with: profileURL, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
            else {
                cell.profileImageViewHeightConstraint?.constant = 0
                cell.senderNameLabelHeightConstraint?.constant = 0
            }
        }
        
      
        
        
        return cell
    }
    
    
}
