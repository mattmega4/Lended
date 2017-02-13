//
//  EntryPageViewController.swift
//  Lended
//
//  Created by Matthew Singleton on 2/12/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EntryPageViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var questionMarkButton: UIButton!
  
  @IBOutlet weak var topContainerView: UIView!
  @IBOutlet weak var leftContainerView: UIView!
  
  @IBOutlet weak var rightContainerView: UIView!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var addLabel: UILabel!
  
  @IBOutlet weak var bottomContainerView: UIView!
  @IBOutlet weak var bottomTextFieldOne: UITextField!
  @IBOutlet weak var bottomTextFieldTwo: UITextField!
  @IBOutlet weak var signInOrUpButtonContainerView: UIView!
  @IBOutlet weak var signInOrUpButton: UIButton!
  
  var topFieldIsSatisfied: Bool?
  var bottomFieldIsSatisfied: Bool?
  var nextButtonRequirementsHaveBeenMet: Bool?
  
  var userStateIsOnSignIn: Bool?
  var createUserStepOneFinished: Bool?
  
  var newUserEmail: String?
  var newUserPassword: String?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    questionMarkButton.createRoundView()
    
    bottomTextFieldDelegateAndAutoCorrectAndPlaceholderColorSetup()
    keyboardMethods()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setStatusToDefaultWhichIsSignIn()
    checkIfBothSignInRequirementsAreMet()
  }
  
  
  // MARK: Add Keyboard Targets
  
  func keyboardMethods() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryPageViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  // MARK: Switch Logic For Sign In or Create Button in Right Container View
  
  func rightContaienrStateSwitcher() {
    if userStateIsOnSignIn == true {
      setStatusToSignUpStageOne()
    } else if userStateIsOnSignIn == false {
      setStatusToDefaultWhichIsSignIn()
    }
  }
  
  
  // MARK: Switch Logic For Sign In or Create Button in Bottom Container View
  
  func bottomContainerStateSwitcher() {
    if userStateIsOnSignIn == true {
      signUserIn()
    } else if userStateIsOnSignIn == false && createUserStepOneFinished == false {
      newUserEmail = bottomTextFieldOne.text ?? ""
      setStatusToSignUpStateTwo()
    } else if userStateIsOnSignIn == false && createUserStepOneFinished == true {
      createNewUser()
    }
  }
  
  
  // MARK: Logic For State Switching
  
  func setStatusToDefaultWhichIsSignIn() {
    createUserStepOneFinished = false
    userStateIsOnSignIn = true
    topFieldIsSatisfied = false
    bottomFieldIsSatisfied = false
    nextButtonRequirementsHaveBeenMet = false
    addButton.setImage(UIImage.init(named: "Plus.png"), for: UIControlState())
    addLabel.text = "Create Account"
    bottomTextFieldTwo.isHidden = false
    bottomTextFieldTwo.isEnabled = true
    bottomTextFieldOne.text = ""
    bottomTextFieldTwo.text = ""
    bottomTextFieldOne.placeholder = "Email"
    bottomTextFieldTwo.placeholder = "Password"
    bottomTextFieldOne.keyboardType = .emailAddress
    bottomTextFieldTwo.keyboardType = .default
    bottomTextFieldOne.addTarget(self, action: #selector(checkIfTopTextFieldIsSatisfiedForLogin(textField:)), for: .editingChanged)
    bottomTextFieldTwo.addTarget(self, action: #selector(checkIfBottomTextFieldIsSatisfiedForLogin(textField:)), for: .editingChanged)
    signInOrUpButton.setTitle("SIGN IN", for: UIControlState())
  }
  
  
  func setStatusToSignUpStageOne() {
    checkIfBothCreateRequirementsAreMet()
    userStateIsOnSignIn = false
    topFieldIsSatisfied = false
    bottomFieldIsSatisfied = false
    nextButtonRequirementsHaveBeenMet = false
    addButton.setImage(UIImage.init(named: "Lock.png"), for: UIControlState())
    addLabel.text = "I Have An Account"
    bottomTextFieldOne.text = ""
    bottomTextFieldTwo.text = ""
    bottomTextFieldTwo.isHidden = true
    bottomTextFieldTwo.isEnabled = false
    bottomTextFieldOne.placeholder = "Email"
    bottomTextFieldOne.keyboardType = .emailAddress
    bottomTextFieldOne.addTarget(self, action: #selector(checkIfTopTextFieldIsSatisfiedForCreatePartOne(textField:)), for: .editingChanged)
    signInOrUpButton.setTitle("CONTINUE", for: UIControlState())
    
  }
  
  
  func setStatusToSignUpStateTwo() {
    checkIfBothCreateRequirementsAreMet()
    createUserStepOneFinished = true
    userStateIsOnSignIn = false
    topFieldIsSatisfied = false
    bottomFieldIsSatisfied = false
    nextButtonRequirementsHaveBeenMet = false
    bottomTextFieldTwo.isHidden = false
    bottomTextFieldTwo.isEnabled = true
    bottomTextFieldOne.text = ""
    bottomTextFieldTwo.text = ""
    bottomTextFieldOne.placeholder = "Password"
    bottomTextFieldTwo.placeholder = "Confirm Password"
    bottomTextFieldOne.keyboardType = .default
    bottomTextFieldTwo.keyboardType = .default
    bottomTextFieldOne.addTarget(self, action: #selector(checkIfTopTextFieldIsSatisfiedForCreatePartTwo(textField:)), for: .editingChanged)
    bottomTextFieldTwo.addTarget(self, action: #selector(checkIfBottomTextFieldIsSatisfiedForCreatePartTwo(textField:)), for: .editingChanged)
    signInOrUpButton.setTitle("CREATE ACCOUNT", for: UIControlState())
    
  }
  
  
  // MARK: Continue Condition Checking Logic
  
  func checkIfBothSignInRequirementsAreMet() {
    if topFieldIsSatisfied == true && bottomFieldIsSatisfied == true {
      signInOrUpButton.isEnabled = true
      signInOrUpButton.isHidden = false
      signInOrUpButtonContainerView.isHidden = false
    } else {
      signInOrUpButton.isEnabled = false
      signInOrUpButton.isHidden = true
      signInOrUpButtonContainerView.isHidden = true
    }
  }
  
  
  func checkIfTopContinueRequirementIsMet() {
    if topFieldIsSatisfied == true {
      signInOrUpButton.isEnabled = true
      signInOrUpButton.isHidden = false
      signInOrUpButtonContainerView.isHidden = false
    } else {
      signInOrUpButton.isEnabled = false
      signInOrUpButton.isHidden = true
      signInOrUpButtonContainerView.isHidden = true
    }
  }
  
  
  func checkIfBothCreateRequirementsAreMet() {
    if topFieldIsSatisfied == true && bottomFieldIsSatisfied == true && bottomTextFieldOne.text == bottomTextFieldTwo.text {
      signInOrUpButton.isEnabled = true
      signInOrUpButton.isHidden = false
      signInOrUpButtonContainerView.isHidden = false
    } else {
      signInOrUpButton.isEnabled = false
      signInOrUpButton.isHidden = true
      signInOrUpButtonContainerView.isHidden = true
    }
  }
  
  
  // TODO: SIgn In
  
  func signUserIn() {
    
  }
  
  
  // TODO: Create User
  
  func createNewUser() {
    
  }
  
  
  // TODO: IB Actions
  
  @IBAction func questionMarkButtonTapped(_ sender: UIButton) {
    // Lost Password
  }
  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    rightContaienrStateSwitcher()
  }
  
  @IBAction func signInOrUpTapped(_ sender: UIButton) {
    bottomContainerStateSwitcher()
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
    return false
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    textField.resignFirstResponder()
    return false
  }
  
  
  
} // End of EntryPageViewController

extension EntryPageViewController: UITextFieldDelegate {
  
  // MARK: Add Delegate, Remove AutoCorrect, and Placeholder Color to Bottom TextFields
  
  func bottomTextFieldDelegateAndAutoCorrectAndPlaceholderColorSetup() {
    var bottomTextFields: [UITextField] = []
    bottomTextFields+=[bottomTextFieldOne, bottomTextFieldTwo]
    let placeHolderLightColor = UIColor.lightText
    for fields in bottomTextFields {
      fields.autocorrectionType = .no
      fields.delegate = self
      fields.attributedPlaceholder = NSAttributedString(string: fields.placeholder!, attributes: [NSForegroundColorAttributeName : placeHolderLightColor])
    }
  }
  
  
  // TODO: Bottom Text Field Targets
  
  func checkIfTopTextFieldIsSatisfiedForLogin(textField: UITextField) {
    if textField == bottomTextFieldOne {
      if textField.text?.validateEmail() == true {
        topFieldIsSatisfied = true
      } else {
        topFieldIsSatisfied = false
      }
    }
    checkIfBothSignInRequirementsAreMet()
  }
  
  
  func checkIfBottomTextFieldIsSatisfiedForLogin(textField: UITextField) {
    if textField == bottomTextFieldTwo {
      if textField.text?.isEmpty == true {
        bottomFieldIsSatisfied = false
      } else {
        bottomFieldIsSatisfied = true
      }
    }
    checkIfBothSignInRequirementsAreMet()
  }
  
  
  func checkIfTopTextFieldIsSatisfiedForCreatePartOne(textField: UITextField) {
    if textField == bottomTextFieldOne {
      if textField.text?.validateEmail() == true {
        topFieldIsSatisfied = true
      } else {
        topFieldIsSatisfied = false
      }
    }
    checkIfTopContinueRequirementIsMet()
  }
  
  
  func checkIfTopTextFieldIsSatisfiedForCreatePartTwo(textField: UITextField) {
    if textField == bottomTextFieldOne {
      if textField.text?.isEmpty == true {
        topFieldIsSatisfied = false
      } else {
        topFieldIsSatisfied = true
      }
    }
    checkIfBothCreateRequirementsAreMet()
  }
  
  
  func checkIfBottomTextFieldIsSatisfiedForCreatePartTwo(textField: UITextField) {
    if textField == bottomTextFieldTwo {
      if textField.text?.isEmpty == true {
        bottomFieldIsSatisfied = false
      } else {
        bottomFieldIsSatisfied = true
      }
    }
    checkIfBothCreateRequirementsAreMet()
  }
  
  
}
