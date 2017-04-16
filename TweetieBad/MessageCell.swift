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
  @IBOutlet weak var profileImageViewTopConstraint: NSLayoutConstraint!

  var tweet: Tweet! {
    didSet {
      guard tweet != nil else {
        return
      }

      usernameLabel.text = tweet.realName

      if let screenName = tweet.screenName {
        screennameLabel.text = "@\(String(describing: screenName))"
      }

      if let profileImageUrl = tweet.profileImageUrl {
        profileImageView.setImageWith(profileImageUrl)
      }

      if tweet.favorited! {
        favoriteImageView.image = UIImage(named: "hearted")
      } else {
        favoriteImageView.image = UIImage(named: "heart")
      }

      if tweet.retweeted! {
        retweetImageView.image = UIImage(named: "retweeted")
      } else {
        retweetImageView.image = UIImage(named: "retweet")
      }

      if let retweetedByName = tweet.retweetedByName {
        retweetedLabel.isHidden = false
        retweetedImageView.isHidden = false
        retweetedLabel.text = "\(retweetedByName) retweeted"
        profileImageViewTopConstraint.constant = 10
      } else {
        retweetedLabel.isHidden = true
        retweetedImageView.isHidden = true
        profileImageViewTopConstraint.constant = -12
      }

      messagesLabel.text = tweet.text

      if let timestamp = tweet.timestamp {
        createAtLabel.text = "• " + timestamp.getElapsedInterval()
      }
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

extension Date {

  func getElapsedInterval() -> String {

    let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())

    if let year = interval.year, year > 0 {
      return year == 1 ? "\(year)" + " " + "year" :
        "\(year)" + " " + "years"
    } else if let month = interval.month, month > 0 {
      return month == 1 ? "\(month)" + " " + "month" :
        "\(interval)" + " " + "months"
    } else if let day = interval.day, day > 0 {
      return day == 1 ? "\(day)" + " " + "day" :
        "\(interval)" + " " + "days"
    } else {
      return "a moment ago"
    }
  }
}
