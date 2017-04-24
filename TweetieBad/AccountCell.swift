//
//  AccountCell.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/23/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!

  var user: User! {
    didSet {
      guard user != nil else {
        return
      }

      usernameLabel.text = user.name

      if let screenname = user.screenname {
        screennameLabel.text = "@\(String(describing: screenname))"
      }

      if let profileUrl = user.profileUrl {
        profileImageView.setImageWith(profileUrl)
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
