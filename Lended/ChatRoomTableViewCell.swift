//
//  ChatRoomTableViewCell.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/28/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profileThumbView: UIImageView!
  @IBOutlet weak var senderName: UILabel!
  @IBOutlet weak var latestMessageLabel: UILabel!
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    profileThumbView.createRoundImageView()
  }
}
