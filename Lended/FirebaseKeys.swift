//
//  FirebaseKeys.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 8/8/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import Foundation

struct FirebaseKeys {
  
  static let users = "users"
  
  // MARK: - Event
  
  static let events = "events"
  static let eventID = "eventID"
  static let eventChatRoomID = "eventChatRoomID" // is this right or last one?
  static let eventName = "eventName"
  static let eventTotal = "eventTotal"
  static let eventCurrencies = "eventCurrencies"
  static let eventActive = "eventActive"
  static let eventMembers = "eventMembers"
  static let eventRates = "eventRates"
  
  // MARK: - Message
  
  static let messages = "messages"
  static let messageSender = "messageSender"
  static let messageSenderID = "messageSenderID"
  static let messageText = "messageText"
  static let textID = "textID"
  
  // MARK: - ChatRoom
  
  static let chatRooms = "chatRooms"
  static let chatParticipants = "chatParticipants"
  static let latestMessage = "latestMessage"
  static let latestSender = "latestSender"
  
  // MARK: - Person
  
  static let friends = "friends"
  static let profilePicture = "profilePicture"
  static let personName = "personName"
  static let personPhone = "personPhone"
  static let personEmail = "personEmail"
  static let personAmount = "personAmount"
  
}



