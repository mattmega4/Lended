//
//  LandingPageViewController.swift
//  Lended
//
//  Created by Matthew Singleton on 2/13/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
    }

  // MARK: Nav Bar & View Design
  // TODO: Adjust this to futura and colors etc
  
  func setNavBar() {
    title = "Peeps"
    navigationController?.navigationBar.barTintColor = UIColor(red: 108.0/255.0, green: 158.0/255.0, blue: 236.0/255.0, alpha: 1.0) // Blue
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "GillSans-Bold", size: 20)!]
  }

  
  
  
  
} // End of LandingPageViewController Class
