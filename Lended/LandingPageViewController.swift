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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    setNavBar()
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
    
    //
    
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
