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
  
  @IBOutlet weak var topContainerView: UIView!
  @IBOutlet weak var mainLogoImageView: UIImageView!
  @IBOutlet weak var questionMarkButton: UIButton!
  
  @IBOutlet weak var leftContainerView: UIView!
  @IBOutlet weak var leftContainerButton: UIButton!
  @IBOutlet weak var leftContainerLabel: UILabel!
  
  @IBOutlet weak var rightContainerView: UIView!
  @IBOutlet weak var rightContainerButton: UIButton!
  @IBOutlet weak var rightContainerLabel: UILabel!
  
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
    
    leftButtonWasTappedAlsoIsDefault()
    checkIfBothSignInRequirementsAreMet()
  }
  
  
  // MARK: Add Keyboard Targets
  
  func keyboardMethods() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryPageViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  // MARK: Switch Logic For Sign In or Create Button in Bottom Container View
  
  func bottomContainerStateSwitcher() {
    if userStateIsOnSignIn == true {
      signUserIn()
    } else if userStateIsOnSignIn == false && createUserStepOneFinished == false {
      newUserEmail = bottomTextFieldOne.text ?? ""
      continueTappedAfterStageOneRegisterAccountActive()
    } else if userStateIsOnSignIn == false && createUserStepOneFinished == true {
      registerNewUser()
    }
  }
  
  
  // MARK: Hide and Show Left and Right Container View Contents
  
  func hideLeftContainerViewContents() {
    leftContainerButton.isHidden = true
    leftContainerButton.isEnabled = false
    leftContainerLabel.isHidden = true
  }
  
  
  func showLeftContainerViewContents() {
    leftContainerButton.isHidden = false
    leftContainerButton.isEnabled = true
    leftContainerLabel.isHidden = false
  }
  
  
  func hideRightContainerViewContents() {
    rightContainerButton.isHidden = true
    rightContainerButton.isEnabled = false
    rightContainerLabel.isHidden = true
  }
  
  
  func showRightContainerViewContents() {
    rightContainerButton.isHidden = false
    rightContainerButton.isEnabled = true
    rightContainerLabel.isHidden = false
  }
  
  
  // MARK: Reset Text Fields
  
  func resetTextFieldText() {
    bottomTextFieldOne.text = ""
    bottomTextFieldTwo.text = ""
  }
  
  
  // MARK: Reset Requirements
  
  func resetLoginRequirements() {
    createUserStepOneFinished = false
    userStateIsOnSignIn = true
    topFieldIsSatisfied = false
    bottomFieldIsSatisfied = false
    nextButtonRequirementsHaveBeenMet = false
  }
  
  
  func resetRegisterRequirementsForStageOne() {
    userStateIsOnSignIn = false
    topFieldIsSatisfied = false
    bottomFieldIsSatisfied = false
    nextButtonRequirementsHaveBeenMet = false
  }
  
  
  func resetRegisterRequirementsForStageTwo() {
    createUserStepOneFinished = true
    userStateIsOnSignIn = false
    topFieldIsSatisfied = false
    bottomFieldIsSatisfied = false
    nextButtonRequirementsHaveBeenMet = false
    bottomTextFieldTwo.isHidden = false
    bottomTextFieldTwo.isEnabled = true
  }
  
  
  // MARK: Login TextField Details
  
  func setupLoginTextFields() {
    bottomTextFieldTwo.isHidden = false
    bottomTextFieldTwo.isEnabled = true
    bottomTextFieldOne.placeholder = "Enter Email"
    bottomTextFieldTwo.placeholder = "Enter Password"
    bottomTextFieldOne.keyboardType = .emailAddress
    bottomTextFieldTwo.keyboardType = .default
    bottomTextFieldOne.isSecureTextEntry = false
    bottomTextFieldTwo.isSecureTextEntry = true
    bottomTextFieldOne.addTarget(self, action: #selector(checkIfTopTextFieldIsSatisfiedForLogin(textField:)), for: .editingChanged)
    bottomTextFieldTwo.addTarget(self, action: #selector(checkIfBottomTextFieldIsSatisfiedForLogin(textField:)), for: .editingChanged)
  }
  
  
  func setupRegisterTextFieldsForStageOne() {
    bottomTextFieldOne.text = ""
    bottomTextFieldTwo.text = ""
    bottomTextFieldTwo.isHidden = true
    bottomTextFieldTwo.isEnabled = false
    bottomTextFieldOne.placeholder = "Enter Email"
    bottomTextFieldOne.keyboardType = .emailAddress
    bottomTextFieldOne.isSecureTextEntry = false
    bottomTextFieldTwo.isSecureTextEntry = true
    bottomTextFieldOne.addTarget(self, action: #selector(checkIfTopTextFieldIsSatisfiedForCreatePartOne(textField:)), for: .editingChanged)
  }
  
  
  func setupRegisterTextFieldsForStageTwo() {
    bottomTextFieldOne.text = ""
    bottomTextFieldTwo.text = ""
    bottomTextFieldOne.placeholder = "Enter Password"
    bottomTextFieldTwo.placeholder = "Confirm Password"
    bottomTextFieldOne.keyboardType = .default
    bottomTextFieldTwo.keyboardType = .default
    bottomTextFieldOne.isSecureTextEntry = true
    bottomTextFieldTwo.isSecureTextEntry = true
    bottomTextFieldOne.addTarget(self, action: #selector(checkIfTopTextFieldIsSatisfiedForCreatePartTwo(textField:)), for: .editingChanged)
    bottomTextFieldTwo.addTarget(self, action: #selector(checkIfBottomTextFieldIsSatisfiedForCreatePartTwo(textField:)), for: .editingChanged)
    
  }
  
  
  // MARK: Logic For State Switching
  
  func leftButtonWasTappedAlsoIsDefault() {
    hideLeftContainerViewContents()
    showRightContainerViewContents()
    resetTextFieldText()
    resetLoginRequirements()
    checkIfBothSignInRequirementsAreMet() // ?
    setupLoginTextFields()
    signInOrUpButton.setTitle("SIGN IN", for: UIControlState())
  }
  
  
  func rightButtonWasTapped() {
    showLeftContainerViewContents()
    hideRightContainerViewContents()
    resetTextFieldText()
    resetRegisterRequirementsForStageOne()
    checkIfBothRegisterRequirementsAreMet() // ?
    setupRegisterTextFieldsForStageOne()
    signInOrUpButton.setTitle("CONTINUE", for: UIControlState())
  }
  
  
  func continueTappedAfterStageOneRegisterAccountActive() {
    resetRegisterRequirementsForStageTwo()
    checkIfBothRegisterRequirementsAreMet()
    setupRegisterTextFieldsForStageTwo()
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
  
  
  func checkIfBothRegisterRequirementsAreMet() {
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
  
  
  // MARK: Sign In
  
  func signUserIn() {
    let currentEmail = bottomTextFieldOne.text ?? ""
    let currentPassword = bottomTextFieldTwo.text ?? ""
    
    FIRAuth.auth()?.signIn(withEmail: currentEmail, password: currentPassword, completion: { (user, error) in
      
      var errMessage = ""
      if (error != nil) {
        if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
          switch errCode {
          case .errorCodeInvalidEmail:
            errMessage = "The entered email does not meet requirements."
          case .errorCodeEmailAlreadyInUse:
            errMessage = "The entered email has already been registered."
          case .errorCodeWeakPassword:
            errMessage = "The entered password does not meet minimum requirements."
          case .errorCodeWrongPassword:
            errMessage = "The entered password is not correct."
          default:
            errMessage = "Please try again."
          }
        }
        let alertController = UIAlertController(title: "Sorry, Something went wrong!", message: "\(errMessage)", preferredStyle: .alert)
        self.present(alertController, animated: true, completion:nil)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(OKAction)
      } else {
        self.performSegue(withIdentifier: "fromEntryToLandingPage", sender: self)
      }
    })
  }
  
  
  // MARK: Register User
  
  func registerNewUser() {
    
    if bottomTextFieldOne.text == bottomTextFieldTwo.text {
      newUserPassword = bottomTextFieldTwo.text ?? ""
      FIRAuth.auth()?.createUser(withEmail: newUserEmail!, password: newUserPassword!, completion: { (user, error) in
        var errMessage = ""
        if (error != nil) {
          if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
            switch errCode {
            case .errorCodeInvalidEmail:
              errMessage = "The entered email does not meet requirements."
            case .errorCodeEmailAlreadyInUse:
              errMessage = "The entered email has already been registered."
            case .errorCodeWeakPassword:
              errMessage = "The entered password does not meet minimum requirements."
            default:
              errMessage = "Please try again."
            }
          }
          let alertController = UIAlertController(title: "Sorry, Something went wrong!", message: "\(errMessage)", preferredStyle: .alert)
          self.present(alertController, animated: true, completion:nil)
          let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
          }
          alertController.addAction(OKAction)
        } else {
          FIRAuth.auth()!.signIn(withEmail: self.newUserEmail!,
                                 password: self.newUserPassword!)
          self.performSegue(withIdentifier: "fromEntryToLandingPage", sender: self)
        }
      })
    }
  }
  
  
  // MARK: IB Actions
  
  @IBAction func questionMarkButtonTapped(_ sender: UIButton) {
    
    // TODO: Lost Password
    
  }
  
  @IBAction func leftContainerButtonTapped(_ sender: UIButton) {
    leftButtonWasTappedAlsoIsDefault()
    
  }
  
  @IBAction func rightContainerButtonTapped(_ sender: UIButton) {
    rightButtonWasTapped()
  }
  
  
  // MARK: Keyboard Methods
  
  func keyboardWillShow(notification:NSNotification) {
    var userInfo = notification.userInfo!
    var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    keyboardFrame = self.view.convert(keyboardFrame, from: nil)
    var contentInset: UIEdgeInsets = self.scrollView.contentInset
    contentInset.bottom = keyboardFrame.size.height + 30
    self.scrollView.contentInset = contentInset
    
    hideLeftContainerViewContents()
    hideRightContainerViewContents()
  }
  
  
  func keyboardWillHide(notification:NSNotification) {
    let contentInset:UIEdgeInsets = UIEdgeInsets.zero
    self.scrollView.contentInset = contentInset
    showLeftContainerViewContents()
    showRightContainerViewContents()
    
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
  
  
  // MARK: Bottom Text Field Targets
  
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
    checkIfBothRegisterRequirementsAreMet()
  }
  
  
  func checkIfBottomTextFieldIsSatisfiedForCreatePartTwo(textField: UITextField) {
    if textField == bottomTextFieldTwo {
      if textField.text?.isEmpty == true {
        bottomFieldIsSatisfied = false
      } else {
        bottomFieldIsSatisfied = true
      }
    }
    checkIfBothRegisterRequirementsAreMet()
  }
  
  
}
