//
//  ContactsViewController.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 8/5/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ContactsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let cellName = "contactCell"
  
  var ref: DatabaseReference!
  var friends = [Person]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    loadData()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    if let userID = Auth.auth().currentUser?.uid {
      ref.child("friends").child(userID).removeAllObservers()
    }
  }
  
  // MARK: - Firebase Method
  
  func loadData() {
    
    if let userID = Auth.auth().currentUser?.uid {
      ref.child("friends").child(userID).observe(.value, with: { (snapshot) in
        
        let enumerator = snapshot.children
        self.friends.removeAll()
        while let child = enumerator.nextObject() as? DataSnapshot {
          
          let aPerson = Person(snapshot: child)
          self.friends.append(aPerson)
          
          
        }
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        
      })
    }
    
  }
  
  
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! ContactsTableViewCell
    
    let aPerson = friends[indexPath.row]

    if let profilePictureURLString = aPerson.profilePicture {
      if let profilePictureURL = URL(string: profilePictureURLString) {
        cell.contactImageView.kf.setImage(with: profilePictureURL)
      }
    }
    
    cell.contactNameLabel.text = aPerson.personName
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let aPerson = friends[indexPath.row]
    
    if let profileVC = storyboard?.instantiateViewController(withIdentifier: PROFILE_VC_STORYBOARD_IDENTIFIER) as? ProfileViewController {
      profileVC.person = aPerson
      navigationController?.pushViewController(profileVC, animated: true)
    }
    
  }
}








