//
//  AddAccountViewController.swift
//  Lended
//
//  Created by Matthew Singleton on 2/15/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase

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
  
  @IBOutlet weak var firstIndicatorImageView: UIImageView!
  @IBOutlet weak var secondIndicatorImageView: NSLayoutConstraint!
  @IBOutlet weak var thirdIndicatorImageView: NSLayoutConstraint!
  @IBOutlet weak var fourthIndicatorImageView: UIImageView!
  
  @IBOutlet weak var addAccountButton: UIButton!
  
  let ref = FIRDatabase.database().reference()
  let user = FIRAuth.auth()?.currentUser
  
  var accountName: String?
  var accountRelationship: String?
  var accountEmail: String?
  var accountPhone: String?
  
  var nameSatisfied: Bool?
  var relationshipSatisfied: Bool?
  var emailSatisfied: Bool?
  var phoneSatisfied: Bool?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavBar()
    setTextFieldDelegates()
    resetRequirements()
    checkAllRequirements()
    keyboardMethods()
    
    
    thirdTextField.addTarget(self, action: #selector(checkIfAccountEmailTextFieldIsSatisfied(textField:)), for: .editingChanged)
    
  }
  
  
  // MARK: Nav Bar & View Design
  
  func setNavBar() {
    title = "Add Account"
    navigationController?.navigationBar.barTintColor = UIColor(red: 214.0/255.0,
                                                               green: 118.0/255.0,
                                                               blue: 92.0/255.0,
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
  
  
  // MARK: Add Keyboard Targets
  
  func keyboardMethods() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryPageViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  // TODO: Reset & Check Requirements & Act On it
  
  func resetRequirements() {
    nameSatisfied = false
    relationshipSatisfied = false
    emailSatisfied = false
    phoneSatisfied = false
  }
  
  func checkAllRequirements() {
    if nameSatisfied == true &&
      relationshipSatisfied == true &&
      emailSatisfied == true &&
      phoneSatisfied == true {
      // good
    } else {
      // bad
    }
    actOnRequirements()
  }
  
  
  func actOnRequirements() {
    
  }

  
  
  
  // TODO: Add to Firebase
  
  func addDataToFirebase() {
    
    let name = firstTextField.text ?? ""
    let relationship = secondTextField.text ?? ""
    let email = thirdTextField.text ?? ""
    let phone = fourthTextField.text ?? ""
    
    accountName = (name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).capitalized
    accountRelationship = (relationship.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).capitalized
    accountEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    accountPhone = phone.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    let account = ref.child("accounts").childByAutoId()
    if let tAccountName = accountName,
      let tAccountRelationship = accountRelationship,
      let tAccountEmail = accountEmail,
      let tAccountPhone = accountPhone {
      account.setValue(["accountName": tAccountName,
                        "accountRelationship": tAccountRelationship,
                        "accountEmail": tAccountEmail,
                        "accountPhone": tAccountPhone])
    }
    ref.child("users").child((user?.uid)!).child("accounts").child(account.key).setValue(true)
    performSegue(withIdentifier: "fromAddAccountToLandingPage", sender: self)
  }
  
  
  // MARK: IB Actions
  
  @IBAction func leftNavBarButtonTapped(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "fromAddAccountToLandingPage", sender: self)
  }
  
  
  @IBAction func addAccountTapped(_ sender: UIButton) {
    addDataToFirebase()
  }
  
  
  // MARK: Keyboard Methods
  
  func keyboardWillShow(notification:NSNotification) {
    var userInfo = notification.userInfo!
    var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    keyboardFrame = self.view.convert(keyboardFrame, from: nil)
    var contentInset: UIEdgeInsets = self.scrollView.contentInset
    contentInset.bottom = keyboardFrame.size.height + 30
    self.scrollView.contentInset = contentInset
  }
  
  
  func keyboardWillHide(notification:NSNotification) {
    let contentInset:UIEdgeInsets = UIEdgeInsets.zero
    self.scrollView.contentInset = contentInset
  }
  
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
  
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    textField.resignFirstResponder()
    return false
  }
  
  
} // End of AddAccountView Controller Class


// TODO: UITextField Delegate Methods

extension AddAccountViewController: UITextFieldDelegate {
  
  func checkIfAccountnameTextFieldIsSatisfied(textField: UITextField) {
    if textField == firstTextField {
      if (textField.text?.isEmpty)! {
        nameSatisfied = false
      } else {
        nameSatisfied = true
      }
    }
    checkAllRequirements()
  }
  
  
  func checkIfAccountRelationshipTextFieldIsSatisfied(textField: UITextField) {
    if textField == secondTextField {
      if (textField.text?.isEmpty)! {
        relationshipSatisfied = false
      } else {
       relationshipSatisfied = true
      }
    }
    checkAllRequirements()
  }
  
  
  func checkIfAccountEmailTextFieldIsSatisfied(textField: UITextField) {
    if textField == thirdTextField {
      
      if (textField.text?.isEmpty)! {
        emailSatisfied = true
      } else if !(textField.text?.isEmpty)! && textField.text?.validateEmail() == false {
        emailSatisfied = false
      } else if !(textField.text?.isEmpty)! && textField.text?.validateEmail() == true {
        emailSatisfied = true
      }
    }
    checkAllRequirements()
  }
  
  
  func checkIfAccountPhoneTextFieldIsSatisfied(textField: UITextField) {
    if textField == fourthTextField {
      
    }
    checkAllRequirements()
  }
  
  
  
  
}
