//
//  MessageCell.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/14/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

  @IBOutlet weak var messagesLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var retweetedLabel: UILabel!
  @IBOutlet weak var retweetedImageView: UIImageView!
  @IBOutlet weak var retweetImageView: UIImageView!
  @IBOutlet weak var favoriteImageView: UIImageView!
  @IBOutlet weak var replyImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var createAtLabel: UILabel!

  var tweet: Tweet! {
    didSet {
      if let author = tweet.author {
        usernameLabel.text = author.name
        if let screenname = author.screenname {
          screennameLabel.text = "@\(String(describing: screenname))"
        }

        if let profileUrl = author.profileUrl {
          profileImageView.setImageWith(profileUrl)
        }
      }

      messagesLabel.text = tweet.text
      createAtLabel.text = tweet.timestamp?.timeIntervalSinceNow.description
    }
  }

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
      profileImageView?.layer.cornerRadius = 3
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
}
