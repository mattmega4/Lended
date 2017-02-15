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
  @IBOutlet weak var tableView: UITableView!
  
  var accountArray: [AccountClass] = []
  let ref = FIRDatabase.database().reference()
  let user = FIRAuth.auth()?.currentUser
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    setNavBar()
  }
  
  
  // MARK: Nav Bar & View Design
  
  func setNavBar() {
    title = "Accounts"
    navigationController?.navigationBar.barTintColor = UIColor(red: 229.0/255.0, green: 112.0/255.0, blue: 85.0/255.0, alpha: 1.0)
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


// TODO: UITableViewDataSource Methods

extension LandingPageViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return accountArray.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath as IndexPath) as! AccountCellTableViewCell
    let row = indexPath.row
    
    ///
    
    return cell
  }
  
}


// TODO: UITableViewDelegate Methods

extension LandingPageViewController: UITableViewDelegate {
  
}
