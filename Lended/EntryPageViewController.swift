//
//  EntryPageViewController.swift
//  Lended
//
//  Created by Matthew Singleton on 2/12/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class EntryPageViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var topContainerView: UIView!
  @IBOutlet weak var leftContainerView: UIView!
  @IBOutlet weak var rightContainerView: UIView!
  
  @IBOutlet weak var bottomContainerView: UIView!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signInOrUpButtonContainerView: UIView!
  @IBOutlet weak var signInOrUpButton: UIButton!
  
  var bottomTextFields: [UITextField] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bottomTextFieldArrayDelegateAndPlaceholderSetup()
    
  }
  

  
  
  
  
  
  
  
  
} // End of EntryPageViewController

extension EntryPageViewController: UITextFieldDelegate {
  
  func bottomTextFieldArrayDelegateAndPlaceholderSetup() {
    bottomTextFields+=[emailTextField, passwordTextField]
    let placeHolderLightColor = UIColor.lightText
    for fields in bottomTextFields {
      fields.delegate = self
      fields.attributedPlaceholder = NSAttributedString(string: fields.placeholder!, attributes: [NSForegroundColorAttributeName : placeHolderLightColor])
    }
  }
  
  
}
