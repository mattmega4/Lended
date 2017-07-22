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
    @IBOutlet weak var addButton: UIButton!
    
    
    let CELL_IDENTIFIER = "loanCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.createRoundView()
    }
    
    

    
    
    


    @IBAction func addButtonTapped(_ sender: UIButton) {
    }

}
