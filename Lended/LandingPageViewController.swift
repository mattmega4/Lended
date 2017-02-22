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
  
  @IBOutlet weak var rightNavBarButton: UIBarButtonItem!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var accountArray: [AccountClass] = []
  let ref = FIRDatabase.database().reference()
  let user = FIRAuth.auth()?.currentUser
  
  var selectedAccount: String?
  var accountNameToTransfer = ""
  var accountEmailToTransfer = ""
  var accountUrlToTransfer = ""
  var accountHasImage: Bool?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    setNavBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    checkIfDataExits()
  }
  
  
  // MARK: Nav Bar & View Design
  
  func setNavBar() {
    title = "Accounts"
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
  
  
  
  
  
  
  
  
  
  
  // MARK: Firebase Methods
  
  func checkIfDataExits() {
    DispatchQueue.main.async {
      self.accountArray.removeAll()
      self.ref.observeSingleEvent(of: .value, with: { snapshot in
        if snapshot.hasChild("accounts") {
          self.pullAllUsersCards()
        } else {
          self.collectionView.reloadData()
        }
      })
    }
  }
  
  
  func pullAllUsersCards() {
    accountArray.removeAll()
    let userRef = ref.child("users").child((user?.uid)!).child("accounts")
    userRef.observeSingleEvent(of: .value, with: { snapshot in
      for usersAccount in snapshot.children {
        let accountID = (usersAccount as AnyObject).key as String
        let accountRef = self.ref.child("cards").child(accountID)
        accountRef.observeSingleEvent(of: .value, with: { accountSnapShot in
          let accountSnap = accountSnapShot as FIRDataSnapshot
          let accountDict = accountSnap.value as! [String: AnyObject]
          
          let accountName = accountDict["accountName"]
          let accountEmail = accountDict["accountEmail"]
          let accountURL = accountDict["accountImage"]
          let accountHasImage = accountDict["accountHasImage"]
          
          self.accountNameToTransfer = accountName as! String
          self.accountEmailToTransfer = accountEmail as! String
          self.accountUrlToTransfer = accountURL as! String
          self.accountHasImage = accountHasImage as? Bool
          
          let aAccount = AccountClass()
          aAccount.accID = accountID
          aAccount.accName = accountName as! String
          aAccount.accEmail = accountEmail as! String
          aAccount.accUrl = accountURL as! String
          aAccount.hasImg = accountHasImage as? Bool
          
          self.accountArray.append(aAccount)
          
          DispatchQueue.main.async {
            self.collectionView.reloadData()
          }
        })
      }
    })
  }
  
  
  
  
  
  
  
  
  
  
  
  // TODO: IB Actions
  
  @IBAction func rightNavBarButtonTapped(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "fromLandingPageToAddCard", sender: self)
  }
  
  
  
  
  
} // End of LandingPageViewController Class


// TODO: UICollectionViewDataSource Methods

extension LandingPageViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return accountArray.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath as IndexPath) as! AccountCollectionViewCell
    let row = indexPath.row
    
    cell.accountImageView.createRoundImageView()
    
    
    
    
    
    
    if accountArray[row].hasImg == true {
      
      DispatchQueue.global(qos: .background).async {
        let myURLString: String = self.accountArray[row].accUrl
        DispatchQueue.main.async {
          if let myURL = URL(string: myURLString), let myData = try? Data(contentsOf: myURL), let image = UIImage(data: myData) {
            cell.accountImageView.image = image
          }
        }
      }
      
    }else {
      print("no image")
    }
    cell.accountNameLabel.text = accountArray[row].accName
    
    return cell
    
  }
  
}


// TODO: UICollectionViewDelegate Methods

extension LandingPageViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //
      }
  
    }


    // MARK: UICollectionViewDelegateFlowLayout Methods
    
    extension LandingPageViewController: UICollectionViewDelegateFlowLayout {
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 25
        let collectionCellSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
        
      }
      
}
