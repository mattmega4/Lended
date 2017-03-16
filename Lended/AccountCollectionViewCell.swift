//
//  AccountCollectionViewCell.swift
//  Lended
//
//  Created by Matthew Singleton on 2/22/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var accountImageView: UIImageView!
  @IBOutlet weak var accountNameLabel: UILabel!
  
  
  
  
  
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.accountImageView.layoutIfNeeded()
    self.accountImageView.layer.cornerRadius = accountImageView.frame.size.width/2
    self.accountImageView.clipsToBounds = true

  }

  
  
}



