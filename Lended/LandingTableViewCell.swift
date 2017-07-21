//
//  LandingTableViewCell.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/21/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class LandingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageOne: UIImageView!
    @IBOutlet weak var profileImageTwo: UIImageView!
    @IBOutlet weak var profileImageThree: UIImageView!
    @IBOutlet weak var profileImageFour: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var profileImageArray: [UIImageView] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageArray+=[profileImageOne, profileImageTwo, profileImageThree, profileImageFour]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for each in profileImageArray {
            each.createRoundImageView()
        }
    }

}
