//
//  LandingViewController.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/21/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class LandingViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var eventArray: [Event] = []
  
  let LOAN_CELL_IDENTIFIER = "loanCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavBar()
    title = "Lended"
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if Auth.auth().currentUser == nil {
      eventArray.removeAll()
      self.tableView.reloadData()
      if let loginVc = storyboard?.instantiateViewController(withIdentifier: ENTRY_VC_STORYBOARD_IDENTIFIER) as? EntryViewController {
        let loginNavigation = UINavigationController(rootViewController: loginVc)
        self.tabBarController?.present(loginNavigation, animated: true, completion: nil)
        
        //                self.splitViewController?.present(loginNavigation, animated: true, completion: nil)
      }
    }
    else {
      pullAllEvents()
      
    }
  }
  
  
  func pullAllEvents() {
    
    FirebaseUtility.shared.getEvents { (events, errMessage) in
      if let theEvents = events {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.eventArray = theEvents
        self.tableView.reloadData()
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
      }
    }
    
  }
}

extension LandingViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: LOAN_CELL_IDENTIFIER, for: indexPath as IndexPath) as! LandingTableViewCell
    
    let row = indexPath.row
    
    
    cell.nameLabel.text = eventArray[row].eventName
    
    //        cell.profileImageOne
    
    
    
    
    //        if let img = cardArray[row].image {
    //            cell.cardBackgroundImage.image = img
    //        }
    //
    //        cell.cardNicknameLabel.text = cardArray[row].nickname
    //        cell.cardNicknameLabel.font = cell.cardNicknameLabel.font.withSize((UIDevice.current.userInterfaceIdiom == .pad ? 38 : 16))
    //        cell.cardNicknameLabel.textColor = cardArray[row].textColor
    //
    //
    //        cell.cardDetailsLabel.text =  "\(String(describing: cardArray[row].fourDigits ?? ""))"
    //        cell.cardDetailsLabel.textColor = cardArray[row].textColor
    //        cell.cardDetailsLabel.font = cell.cardDetailsLabel.font.withSize((UIDevice.current.userInterfaceIdiom == .pad ? 32 : 14))
    //
    //
    //        cell.cardTypeLabel.text = "\(String(describing: cardArray[row].type ?? ""))"
    //        cell.cardTypeLabel.textColor = cardArray[row].textColor
    //        cell.cardTypeLabel.font = cell.cardDetailsLabel.font.withSize((UIDevice.current.userInterfaceIdiom == .pad ? 32 : 14))
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return eventArray.count
  }
  
  
}




//extension LandingViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            venues = allVenues
//            self.collectionView.reloadData()
//            return
//        }
//        let tempVenues = allVenues.filter({ (aVenue) -> Bool in
//            if let venueName = aVenue.name {
//                if venueName.lowercased().substring(to: min(venueName.endIndex, searchText.endIndex)) == searchText.lowercased() {
//                    return true
//                }
//            }
//            if let words = aVenue.name?.components(separatedBy: .whitespaces) {
//                for aWord in words {
//                    return aWord.lowercased().substring(to: min(searchText.endIndex, aWord.endIndex)) == searchText.lowercased()
//                }
//            }
//            return false
//        })
//        venues = tempVenues
//        self.collectionView.reloadData()
//
//    }
//
//
//
//}
