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
  
  @IBOutlet weak var accountImageOuterView: UIView!
  @IBOutlet weak var accountImageInnerView: UIView!
  @IBOutlet weak var accountImageView: UIImageView!
  @IBOutlet weak var imageTopButton: UIButton!
  @IBOutlet weak var imageLeftButton: UIButton!
  @IBOutlet weak var imageRightButton: UIButton!

  @IBOutlet weak var firstTextField: UITextField!
  @IBOutlet weak var secondTextField: UITextField!
  
  @IBOutlet weak var firstUnderlineView: UIView!
  @IBOutlet weak var secondUnderlineView: UIView!
  
  @IBOutlet weak var firstIndicatorImageView: UIImageView!
  @IBOutlet weak var secondIndicatorImageView: UIImageView!
  
  @IBOutlet weak var addAccountButton: UIButton!
  
  
  let storage = FIRStorage.storage()
  let ref = FIRDatabase.database().reference()
  let user = FIRAuth.auth()?.currentUser
  
  var selectedImageFromPicker: UIImage?
  var accountMetadata: URL?
  var imageData: Data?
  
  var accountName: String?
  var accountEmail: String?
  
  var nameSatisfied: Bool?
  var emailSatisfied: Bool?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavBar()
    setDelegates()
    keyboardMethods()
    addTextFieldTargets()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    resetRequirements()
    checkAllRequirements()
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
  
  func setDelegates() {
    self.firstTextField.delegate = self
    self.secondTextField.delegate = self
  }
  
  
  // MARK: Add Keyboard Targets
  
  func keyboardMethods() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EntryPageViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  // MARK: Add TextField Targets
  
  func addTextFieldTargets() {
    firstTextField.addTarget(self, action: #selector(checkIfAccountnameTextFieldIsSatisfied(textField:)), for: .editingChanged)
    secondTextField.addTarget(self, action: #selector(checkIfAccountEmailTextFieldIsSatisfied(textField:)), for: .editingChanged)
  }
  
  
  // MARK: Reset & Check Requirements
  
  func resetRequirements() {
    firstTextField.text = ""
    secondTextField.text = ""
    nameSatisfied = false
    emailSatisfied = true
  }
  
  
  func checkAllRequirements() {
    if nameSatisfied == true &&
      emailSatisfied == true {
      addAccountButton.isEnabled = true
      addAccountButton.isHidden = false
    } else {
      addAccountButton.isEnabled = false
      addAccountButton.isHidden = true
    }
  }
  
  
  // MARK: Call UIImagePickerController
  
  func pickAccountImage() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    present(picker, animated: true, completion: nil)
  }
  
 
  // Mark: Use Camera
  
  func useCamera() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.allowsEditing = true
      picker.sourceType = .camera
      present(picker, animated: true, completion: nil)
    }
}

  
  // MARK: Add to Firebase
  
  func addDataToFirebase() {
    let name = firstTextField.text ?? ""
    let email = secondTextField.text ?? ""
    accountName = (name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).capitalized
    accountEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let account = ref.child("accounts").childByAutoId()
    let imageName = NSUUID().uuidString
    let storageRef = storage.reference().child("users").child((user?.uid)!).child("accounts").child(account.key).child("\(imageName).png")
    if selectedImageFromPicker != nil {
      
      if let tempData = UIImagePNGRepresentation(selectedImageFromPicker!) {
        storageRef.put(tempData, metadata: nil) { (metadata, error) in
          if error != nil {
            print(error!)
            return
          }
          
          self.accountMetadata = metadata?.downloadURL()
          
          if let tAccountName = self.accountName,
            let tAccountEmail = self.accountEmail,
            let tProfileImageUrl = metadata?.downloadURL()?.absoluteString {
            
            account.setValue(["accountName": tAccountName,
                              "accountEmail": tAccountEmail,
                              "accountImage": tProfileImageUrl,
                              "accountHasImage": true])
          }
          print(metadata!)
        }
      }
    } else {
      
      if let tAccountName = accountName,
        let tAccountEmail = accountEmail {
        account.setValue(["accountName": tAccountName,
                          "accountEmail": tAccountEmail,
                          "accountImage": "",
                          "accountHasImage": false])
      }
    }
    ref.child("users").child((user?.uid)!).child("accounts").child(account.key).setValue(true)
    performSegue(withIdentifier: "fromAddAccountToLandingPage", sender: self)
  }
  
  
  // Disable Buttons for Keyboard
  
  func hideAndDisableButtonsForKeyboard() {
    imageTopButton.isHidden = true
    imageTopButton.isEnabled = false
    imageLeftButton.isHidden = true
    imageLeftButton.isEnabled = false
    imageRightButton.isHidden = true
    imageRightButton.isEnabled = false
  }
  
  
  // Enable Buttons for Keyboard
  
  func unhideAndEnableButtonsForKeyboard() {
    imageTopButton.isHidden = false
    imageTopButton.isEnabled = true
    imageLeftButton.isHidden = false
    imageLeftButton.isEnabled = true
    imageRightButton.isHidden = false
    imageRightButton.isEnabled = true
  } 
  

  // MARK: IB Actions

  @IBAction func leftNavBarButtonTapped(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "fromAddAccountToLandingPage", sender: self)
  }
  
  @IBAction func imageTopButtonTapped(_ sender: UIButton) {
    accountImageView.image = nil
  }
  
  @IBAction func imageLeftButtonTapped(_ sender: UIButton) {
    pickAccountImage()
  }

  @IBAction func imageRightButtonTapped(_ sender: UIButton) {
    useCamera()
  }
  
  @IBAction func addAccountButtonTapped(_ sender: UIButton) {
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
    hideAndDisableButtonsForKeyboard()
  }
  
  
  func keyboardWillHide(notification:NSNotification) {
    let contentInset:UIEdgeInsets = UIEdgeInsets.zero
    self.scrollView.contentInset = contentInset
    unhideAndEnableButtonsForKeyboard()
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



// MARK: UITextField Delegate Methods

extension AddAccountViewController: UITextFieldDelegate {
  
  func checkIfAccountnameTextFieldIsSatisfied(textField: UITextField) {
    if textField == firstTextField {
      if (textField.text?.isEmpty)! {
        firstIndicatorImageView.image = UIImage.init(named: "redEx.png")
        nameSatisfied = false
      } else {
        firstIndicatorImageView.image = UIImage.init(named: "greenCheck.png")
        nameSatisfied = true
      }
    }
    checkAllRequirements()
  }
  
  
  func checkIfAccountEmailTextFieldIsSatisfied(textField: UITextField) {
    if textField == secondTextField {
      if (textField.text?.isEmpty)! {
        emailSatisfied = true
        secondIndicatorImageView.image = nil
      } else if !(textField.text?.isEmpty)! && textField.text?.validateEmail() == false {
        secondIndicatorImageView.image = UIImage.init(named: "yellowCaution.png")
        emailSatisfied = false
      } else if !(textField.text?.isEmpty)! && textField.text?.validateEmail() == true {
        secondIndicatorImageView.image = UIImage.init(named: "greenCheck.png")
        emailSatisfied = true
      }
    }
    checkAllRequirements()
  }
  
  
} // End of UITextField Delegate Extension


// MARK: UIImagePickerControllerDelegate Methods

extension AddAccountViewController: UIImagePickerControllerDelegate {

  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      print(editedImage)
      selectedImageFromPicker = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      print(originalImage)
      selectedImageFromPicker = originalImage
    }
    if let selectedImage = selectedImageFromPicker {
      accountImageView.image = selectedImage
    }
    dismiss(animated: true, completion: nil)
  }
  
  
} // End of UIImagePickerControllerDelegate


// MARK: UINavigationControllerDelegate Methods

extension AddAccountViewController: UINavigationControllerDelegate {
  
}

















