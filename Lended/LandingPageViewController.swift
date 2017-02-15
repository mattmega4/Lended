//
//  LandingPageViewController.swift
//  Lended
//
//  Created by Matthew Singleton on 2/13/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase

class LandingPageViewController: UIViewController {
  
  // IB Outlets
  
  let ref = FIRDatabase.database().reference()
  let user = FIRAuth.auth()?.currentUser
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavBar()
  }
  
  
  // MARK: Nav Bar & View Design
  
  func setNavBar() {
    title = "Accounts"
    navigationController?.navigationBar.barTintColor = UIColor(red: 229.0/255.0, green: 112.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                               NSFontAttributeName: UIFont(name: "Futura",
                                                                                           size: 20)!]
  }
  
  
  
  
  
} // End of LandingPageViewController Class
