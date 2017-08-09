//
//  FirebaseUtility.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/21/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebasePerformance
import Fabric
import Crashlytics

class FirebaseUtility: NSObject {
  
  static let shared = FirebaseUtility()
  
  let ref = Database.database().reference()
  var user = Auth.auth().currentUser
  let storage = Storage.storage()
  
  
  // MARK: - Auth
  
  func resetPasswordWith(email: String, completion: (_ error: String) -> Void) {
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
      print(error.debugDescription)
    }
  }
  
  
  func signUserInWith(email: String?, password: String?, completion: @escaping (_ user: User?, _ errorMessage: String?) -> Void) {
    
    guard let theEmail = email else {
      let errMessage = "Please enter an email"
      completion(nil, errMessage)
      return
    }
    guard let thePassword = password else {
      let errMessage = "Please enter a password"
      completion(nil, errMessage)
      return
    }
    Auth.auth().signIn(withEmail: theEmail, password: thePassword, completion: { (user, error) in
      if let theError = error {
        var errMessage = "An unknown error occured."
        if let errCode = AuthErrorCode(rawValue: (theError._code)) {
          switch errCode {
          case .invalidEmail:
            errMessage = "The entered email does not meet requirements."
          case .weakPassword:
            errMessage = "The entered password does not meet minimum requirements."
          case .wrongPassword:
            errMessage = "The entered password is not correct."
          default:
            errMessage = "Please try again."
          }
        }
        completion(nil, errMessage)
      } else {
        Analytics.logEvent(AnalyticsKeys.lendedEmailLogin, parameters: [AnalyticsKeys.success : true])
        
        Answers.logLogin(withMethod: AnalyticsKeys.lendedEmailLogin,
                         success: true,
                         customAttributes: [:])
        
        self.user = user
        completion(user, nil)
      }
    })
  }
  
  
  func registerUserWith(email: String?, password: String?, confirmPassword: String?, completion: @escaping (_ user: User?, _ errorMessage: String?) -> Void) {
    
    guard let theEmail = email else {
      let errMessage = "Please enter an email"
      completion(nil, errMessage)
      return
    }
    
    guard let thePassword = password else {
      let errMessage = "Please enter a password"
      completion(nil, errMessage)
      return
    }
    
    guard password == confirmPassword else {
      let errMessage = "Passwords do not match"
      completion(nil, errMessage)
      return
    }
    
    Auth.auth().createUser(withEmail: theEmail, password: thePassword, completion: { (user, error) in
      if let theError = error {
        
        var errMessage = "An unknown error occured."
        if let errCode = AuthErrorCode(rawValue: (theError._code)) {
          switch errCode {
            
          case .invalidEmail:
            errMessage = "The entered email does not meet requirements."
          case .emailAlreadyInUse:
            errMessage = "The entered email has already been registered."
          case .weakPassword:
            errMessage = "The entered password does not meet minimum requirements."
          default:
            errMessage = "Please try again."
          }
        }
        completion(nil, errMessage)
      } else {
        Analytics.logEvent(AnalyticsKeys.lendedEmailRegistered, parameters: [AnalyticsKeys.success : true])
        
        Answers.logSignUp(withMethod: AnalyticsKeys.lendedEmailRegistered,
                          success: true,
                          customAttributes: [:])
        self.user = user
        completion(user, nil)
      }
    })
  }
  
  // MARK: - Events
  
  func getEvents(completion: @escaping (_ events: [Event]?, _ errorMessage: String?) -> Void) {
    
    guard let userID = user?.uid else {
      let error = "Unknown error occured! User is not logged in."
      completion(nil, error)
      return
    }
    
    let userEventRef = ref.child(FirebaseKeys.events).child(userID)
    userEventRef.observe(.value, with: { (snapshot) in
      let enumerator = snapshot.children
      var events = [Event]()
      
      while let eventSnapshot = enumerator.nextObject() as? DataSnapshot {
        let event = Event(snapshot: eventSnapshot)
        events.append(event)
      }
      
      completion(events, nil)
      
    })
  }
  
  
  // MARK: - Chatroom
  
  func getChatRoomIDs(completion: @escaping ( _ chatIDs: [String]?, _ errorMessage: String?) -> Void) {
    
    guard let userID = user?.uid else {
      let error = "Unknown error occured! User is not logged in."
      completion(nil, error)
      return
    }
    
    ref.child(FirebaseKeys.users).child(userID).child(FirebaseKeys.chatRooms).observe(.value, with: { (snapshot) in
      
      var chatRoomIDs = [String]()
      let enumerator = snapshot.children
      while let child = enumerator.nextObject() as? DataSnapshot {
        chatRoomIDs.append(child.key)
      }
      DispatchQueue.main.async {
        completion(chatRoomIDs, nil)
      }
    })
  }
  
  func getChatRoomWith(chatRoomId: String, completion: @escaping ( _ chatRoom: ChatRoom, _ errorMessage: String?) -> Void) {
    
    ref.child(FirebaseKeys.chatRooms).child(chatRoomId).observe(.value, with: { (snapshot) in
      let chatRoom = ChatRoom(snapshot: snapshot)
      
      DispatchQueue.main.async {

        completion(chatRoom, nil)
      }
    })
    
  }
  
  
  // TODO: - Messages
  
  func addMessageFor(chatRoom: ChatRoom?, completion: @escaping (_ message: [Message]?, _ errorMessage: String?) -> Void) {
    
    guard let chatRoomID = chatRoom?.chatRoomID else {
      let error = "An unkown error occured, could not connect to chatroom"
      completion(nil, error)
      return
    }
    
    
    
  
  }
  
  
  func getMessagesFor(chatRoomID: String?, completion: @escaping (_ messages: [Message]?, _ errorMessage: String?) -> Void) {
    
    guard let chatRoomID = chatRoomID else {
      let error = "An unkown error occured, could not connect to chatroom"
      completion(nil, error)
      return
    }
    
    let chatRef = ref.child(FirebaseKeys.messages).child(chatRoomID)
    
    chatRef.observe(.value, with: { (snapshot) in
      let enumerator = snapshot.children
      var chats = [Message]()
      
      while let chatSnapShot = enumerator.nextObject() as? DataSnapshot {
        let chat = Message(snapshot: chatSnapShot)
        chats.append(chat)
      }
      completion(chats, nil)
    })
    
    
  }
  
  
  // MARK: - User Information
  
  func pullUserData(completion: @escaping (_ userInfo: [String : String]?, _ errorMessage: String?) -> Void) {
    
    if let userID = user?.uid {
      let userRef = ref.child(FirebaseKeys.users).child(userID)
      
      userRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let info = snapshot.value as? [String: String] {
          completion(info, nil)
        } else {
          completion(nil, "We could not get userinfo from firebase")
        }
      })
    } else {
      completion(nil, "You are not authorized to get this information")
    }
  }
  
  func saveUserName(name: String) {
    if let userID = user?.uid {
      let userRef = ref.child(FirebaseKeys.users).child(userID)
      userRef.updateChildValues([FirebaseKeys.userName: name])
    }
    
    if let user = Auth.auth().currentUser {
      let changeRequest = user.createProfileChangeRequest()
      changeRequest.displayName = name
      changeRequest.commitChanges(completion: nil)
    }
  }
  
  func saveUserPicture(image: UIImage) {
    if let userId = user?.uid, let imageData = UIImageJPEGRepresentation(image, 1.0) {
      let storageRef = storage.reference().child(FirebaseKeys.profilePicture).child(userId)
      storageRef.putData(imageData, metadata: nil, completion: { (storageMetaData, error) in
        if let profilePictureLink = storageMetaData?.downloadURL()?.absoluteString {
          let userProfileRef = self.ref.child(FirebaseKeys.users).child(userId)
          userProfileRef.updateChildValues([FirebaseKeys.profilePicture : profilePictureLink])
        }
      })
    }
  }
  
  func deleteAccount(completion: (_ success: Bool, _ error: Error?) -> Void) {
    user?.delete(completion: { (error) in
      Analytics.logEvent(AnalyticsKeys.userDeleted, parameters: [AnalyticsKeys.success : true])
      Answers.logCustomEvent(withName: AnalyticsKeys.userDeleted,
                             customAttributes: nil)
    })
  }


  
  
}
