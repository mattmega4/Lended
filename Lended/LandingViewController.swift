//
//  LandingViewController.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/21/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit


class LandingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let CELL_IDENTIFIER = "loanCell"

    override func viewDidLoad() {
        super.viewDidLoad()

//        addButton.createRoundView()
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
