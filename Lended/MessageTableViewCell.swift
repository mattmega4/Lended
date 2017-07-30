//
//  MessageTableViewCell.swift
//  Lended
//
//  Created by Matthew Howes Singleton on 7/29/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
  
  @IBOutlet weak var senderNameLabel: UILabel?
  @IBOutlet weak var senderProfileImageView: UIImageView?
  @IBOutlet weak var chatBubbleView: UIView!
  @IBOutlet weak var chatTextLabel: UILabel!
  @IBOutlet weak var profileImageViewHeightConstraint: NSLayoutConstraint?
  @IBOutlet weak var senderNameLabelHeightConstraint: NSLayoutConstraint?
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    senderProfileImageView?.createRoundImageView()
    chatBubbleView.createRoundedCorners()
  }
  
}
