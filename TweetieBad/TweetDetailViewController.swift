//
//  TweetDetailViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/15/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

  @IBOutlet weak var retweetedImageView: UIImageView!
  @IBOutlet weak var retweetedLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  @IBOutlet weak var replyImageView: UIImageView!
  @IBOutlet weak var retweetImageView: UIImageView!
  @IBOutlet weak var favoriteImageView: UIImageView!

  var tweet: Tweet!

  override func viewDidLoad() {
      super.viewDidLoad()

    usernameLabel.text = tweet.realName!
    screennameLabel.text = "@\(tweet.screenName!)"
    messageLabel.text = tweet.text
    if let profileImageUrl = tweet.profileImageUrl {
      self.profileImageView.setImageWith(profileImageUrl)
    }

    favoriteCountLabel.text = "\(tweet.favoritesCount) FAVORITES"
    retweetCountLabel.text = "\(tweet.retweetCount) RETWEETS"

    if let timestamp = tweet.timestamp {
      createdAtLabel.text = "\(timestamp)"
    }

    if let retweetedByName = tweet.retweetedByName {
      retweetedLabel.text = "\(retweetedByName) retweeted"
    } else {
      retweetedLabel.isHidden = true
      retweetedImageView.isHidden = true
    }

    if let retweeted = tweet.retweeted {
      if (retweeted) {
        retweetImageView.image = UIImage(named: "retweeted")
      } else {
        retweetImageView.image = UIImage(named: "retweet")
      }
    }

    if let favorited = tweet.favorited {
      if (favorited) {
        favoriteImageView.image = UIImage(named: "hearted")
      } else {
        favoriteImageView.image = UIImage(named: "heart")
      }
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  @IBAction func onHomeButtom(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func onReply(_ sender: Any) {
    performSegue(withIdentifier: "replySegue", sender: sender)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "replySegue"){
      let navController = segue.destination as! UINavigationController
      let composeViewController = navController.topViewController as! ComposeViewController
      composeViewController.tweet = tweet
    }
  }


}
