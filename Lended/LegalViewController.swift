//
//  LegalViewController.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 8/9/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController {
  
  @IBOutlet weak var leftNavBarButton: UIBarButtonItem!
  @IBOutlet weak var legalLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavBar()
    title = "Legal"
  }
  
  
  @IBAction func leftNavBarButtonTapped(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  
}
