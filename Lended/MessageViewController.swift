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
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.sendMessageTextField.delegate = self
        
        updateTitleView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMessages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let chatRoomID = chatRoom?.chatRoomID {
            ref.child("messages").child(chatRoomID).removeAllObservers()
        }
    }
    
    func updateTitleView() {
        let containerView = UIView()
        
        let imageView = UIImageView(frame: CGRect(x: (containerView.frame.width - 30) / 2, y: (containerView.frame.height - 30) / 2, width: 30, height: 30))
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.createRoundImageView()
        if let participants = chatRoom?.participants {
            if participants.count == 2 {
                for aPerson in participants {
                    if aPerson.personID != Auth.auth().currentUser?.uid {
                        if let imageString = aPerson.profilePicture {
                            let imageURL = URL(string: imageString)
                            imageView.kf.setImage(with: imageURL)
                        }
                        else {
                            imageView.image = InitialsImageFactory.imageWith(name: aPerson.personName)
                        }
                    }
                }
            }
        }
        containerView.addSubview(imageView)
        navigationItem.titleView = containerView
    }
    
    func loadMessages() {
        
        FirebaseUtility.shared.getMessagesFor(chatRoom: chatRoom) { (messages, error) in
            
            if let theMessages = messages {
                self.messageArray = theMessages
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    let lastIndexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
                    self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
                }
            }
        }
        
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
        
        if message.senderId == Auth.auth().currentUser?.uid {
            
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
