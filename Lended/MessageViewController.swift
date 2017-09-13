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
import MBProgressHUD

class MessageViewController: UIViewController {
  
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var sendMessageContainerView: UIView!
  @IBOutlet weak var sendMessageTextField: UITextField!
  @IBOutlet weak var sendMessageButton: UIButton!
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  let YOU_CELL_IDENTIFIER = "youMessageCell"
  let ME_CELL_IDENTIFIER = "meMessageCell"
  
  var messageArray = [Message]()
  var chatRoom: ChatRoom?
  var person: Person?
  
  var ref: DatabaseReference!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 500
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.sendMessageTextField.delegate = self
    
    setNavBar()
    updateTitleView()
    sendMessageTextField.createRoundedTextFieldCorners()
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    setupViewResizerOnKeyboardShown()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadMessagesFor(chatRoomId: chatRoom?.chatRoomID)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    if let chatRoomID = chatRoom?.chatRoomID {
      ref.child(FirebaseKeys.messages).child(chatRoomID).removeAllObservers()
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
            } else {
              imageView.image = InitialsImageFactory.imageWith(name: aPerson.personName)
            }
          }
        }
      }
    }
    containerView.addSubview(imageView)
    navigationItem.titleView = containerView
  }
  
  func loadMessagesFor(chatRoomId: String?) {
    
    FirebaseUtility.shared.getMessagesFor(chatRoomID: chatRoomId) { (messages, error) in
      
      MBProgressHUD.showAdded(to: self.view, animated: true)
      if let theMessages = messages {
        self.messageArray = theMessages
        DispatchQueue.main.async {
          self.tableView.reloadData()
          let lastIndexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
          self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }
      }
      MBProgressHUD.hide(for: self.view, animated: true)
    }
    
  }
  
  
  // MARK: - IBActions
  
  @IBAction func sendMessageTapped(_ sender: UIButton) {
    
    if let messageText = sendMessageTextField.text, let currentUserID = Auth.auth().currentUser?.uid {
      
      let userName = Auth.auth().currentUser?.displayName ?? ""
      
      if let chatRoomID = chatRoom?.chatRoomID {
        ref.child(FirebaseKeys.chatRooms).child(chatRoomID).child(FirebaseKeys.latestMessage).setValue(messageText)
        
        
        
        ref.child(FirebaseKeys.messages).child(chatRoomID).childByAutoId().setValue([FirebaseKeys.messageSender : userName, FirebaseKeys.messageSenderID : currentUserID, FirebaseKeys.messageText: messageText])
      }
      else if let personId = person?.personID {
        let UID = ref.child(FirebaseKeys.chatRooms).childByAutoId().key
        loadMessagesFor(chatRoomId: UID)
        ref.child(FirebaseKeys.chatRooms).child(UID).setValue([FirebaseKeys.latestMessage : messageText, FirebaseKeys.chatParticipants : [currentUserID : [FirebaseKeys.personName : userName, FirebaseKeys.profilePicture : "https://booki.flossmanuals.net/summary-of-firefox/_booki/summary-of-firefox/static/HTTPSE_06_1.png"], personId : [FirebaseKeys.personName : person?.personName ?? "", FirebaseKeys.profilePicture : "https://booki.flossmanuals.net/summary-of-firefox/_booki/summary-of-firefox/static/HTTPSE_06_1.png"]]], withCompletionBlock: { (error, reference) in
            reference.observeSingleEvent(of: .value, with: { (snapshot) in
              self.chatRoom = ChatRoom(snapshot: snapshot)
            })
        })
        ref.child(FirebaseKeys.messages).child(UID).childByAutoId().setValue([FirebaseKeys.messageSender : userName, FirebaseKeys.messageSenderID : currentUserID, FirebaseKeys.messageText: messageText])
        ref.child(FirebaseKeys.users).child(personId).child(FirebaseKeys.chatRooms).child(UID).setValue(currentUserID)
        ref.child(FirebaseKeys.users).child(currentUserID).child(FirebaseKeys.chatRooms).child(UID).setValue(personId)
      }
    }
    sendMessageTextField.text = nil
    
  }
  
  
  // MARK: - Keyboard Methods
  
  func setupViewResizerOnKeyboardShown() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowForResizing), name: Notification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForResizing), name: Notification.Name.UIKeyboardWillHide, object: nil)
  }
  
  @objc func keyboardWillShowForResizing(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      // We're not just minusing the kb height from the view height because
      // the view could already have been resized for the keyboard before
      bottomConstraint.constant = keyboardSize.height
    } else {
      debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
    }
  }
  
  @objc func keyboardWillHideForResizing(notification: Notification) {
    bottomConstraint.constant = 0
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
      } else {
        cell.profileImageViewHeightConstraint?.constant = 0
        cell.senderNameLabelHeightConstraint?.constant = 0
      }
    }
    
    return cell
  }
  
  
}
