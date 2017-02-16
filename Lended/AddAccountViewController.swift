//
//  AddAccountViewController.swift
//  Lended
//
//  Created by Matthew Singleton on 2/15/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {
  
  @IBOutlet weak var leftNavBarButton: UIBarButtonItem!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var mainImageView: UIImageView!
  
  @IBOutlet weak var firstTextField: UITextField!
  @IBOutlet weak var secondTextField: UITextField!
  @IBOutlet weak var thirdTextField: UITextField!
  @IBOutlet weak var fourthTextField: UITextField!
  
  @IBOutlet weak var firstUnderlineView: UIView!
  @IBOutlet weak var secondUnderlineView: UIView!
  @IBOutlet weak var thirdUnderlineView: UIView!
  @IBOutlet weak var fourthUnerlineView: UIView!
  
  @IBOutlet weak var addAccountButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavBar()
    setTextFieldDelegates()
  }
  
  
  // MARK: Nav Bar & View Design
  
  func setNavBar() {
    title = "Add Account"
    navigationController?.navigationBar.barTintColor = UIColor(red: 229.0/255.0,
                                                               green: 112.0/255.0,
                                                               blue: 85.0/255.0,
                                                               alpha: 1.0)
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                               NSFontAttributeName: UIFont(name: "Futura",
                                                                                           size: 20)!]
  }
  
  
  // MARK: Setting Delegates
  
  func setTextFieldDelegates() {
    self.firstTextField.delegate = self
    self.secondTextField.delegate = self
    self.thirdTextField.delegate = self
    self.fourthTextField.delegate = self
  }
  
  
  
  
  
  //....
  
  
  
} // End of AddAccountView Controller Class


// TODO: UITextField Delegate Methods

extension AddAccountViewController: UITextFieldDelegate {
  
}
