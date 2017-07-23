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

    
    
    
    
    
    // MARK: - Login/Signup
    
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
                Analytics.logEvent("Email_Login", parameters: ["success" : true])
                Answers.logLogin(withMethod: "Email Login",
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
                Analytics.logEvent("Email_Register", parameters: ["success" : true])
                
                Answers.logSignUp(withMethod: "Email Register",
                                  success: true,
                                  customAttributes: [:])
                self.user = user
                completion(user, nil)
            }
        })
    }

    
    
}
