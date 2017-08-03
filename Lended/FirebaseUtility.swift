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
  
  
  // TODO: - Chatroom
  
  func getChatsFor(person: Person?, completion: @escaping ( _ chats: [ChatRoom]?, _ errorMessage: String?) -> Void) {
    
    guard let userID = user?.uid else {
      let error = "Unknown error occured! User is not logged in."
      completion(nil, error)
      return
    }
    
  }
  
  
  // TODO: - Messages
  
  func addMessageFor(chatRoom: ChatRoom?, completion: @escaping (_ message: [Message]?, _ errorMessage: String?) -> Void) {
    
    guard let chatRoomID = chatRoom?.chatRoomID else {
      let error = "An unkown error occured, could not connect to chatroom"
      completion(nil, error)
      return
    }
    
    let chatRef = ref.child(FirebaseKeys.messages).child(chatRoomID).childByAutoId()
    
  
  }
  
  
  func getMessagesFor(chatRoom: ChatRoom?, completion: @escaping (_ messages: [Message]?, _ errorMessage: String?) -> Void) {
    
    guard let chatRoomID = chatRoom?.chatRoomID else {
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
  
  
  
}
