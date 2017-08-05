//
//  ProfileViewController.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 8/5/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

  var ref: DatabaseReference!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }

  @IBAction func tmp(_ sender: UIButton) {
    
    
    
  }


}
