//
//  TweetDetailViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/15/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

protocol TweetDetailViewControllerDelegate: class {
  func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController,
                             didUpdateTweet tweet: Tweet)
}

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
  @IBOutlet weak var profileImageViewTopConstraint: NSLayoutConstraint!

  var tweet: Tweet!
  weak var delegate: TweetDetailViewControllerDelegate?

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
      retweetedLabel.isHidden = false
      retweetedImageView.isHidden = false
      retweetedLabel.text = "\(retweetedByName) retweeted"
      profileImageViewTopConstraint.constant = 10
    } else {
      retweetedLabel.isHidden = true
      retweetedImageView.isHidden = true
      profileImageViewTopConstraint.constant = -12
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
        favoriteImageView.image = UIImage(named: "starred")
      } else {
        favoriteImageView.image = UIImage(named: "star")
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

  @IBAction func onRetweet(_ sender: UITapGestureRecognizer) {
    var create: Bool!

    if let retweeted = tweet.retweeted {
      if (retweeted){
        // Unretweet
        create = false
      } else {
        // Retweet
        create = true
      }
    }

    TwitterClient.sharedInstance?.retweet(id: tweet.id!, create: create, success: { () -> () in
      // On success save state locally, update counts and retweeted image
      if (create == true){
        self.retweetImageView.image = UIImage(named: "retweeted")
        self.tweet.retweeted = true
        self.tweet.retweetCount = self.tweet.retweetCount + 1
        self.retweetCountLabel.text = "\(self.tweet.retweetCount) RETWEETS"
      } else {
        self.retweetImageView.image = UIImage(named: "retweet")
        self.tweet.retweeted = false
        self.tweet.retweetCount = self.tweet.retweetCount - 1
        self.retweetCountLabel.text = "\(self.tweet.retweetCount) RETWEETS"
      }

      // Let other view controllers know the tweet has been updated
      self.delegate?.tweetDetailViewController(tweetDetailViewController: self, didUpdateTweet: self.tweet)

      return Void()
    }, failure: { (error: Error?) -> () in
      if let error = error {
        print(error.localizedDescription)
      }
    })
  }

  @IBAction func onFavorite(_ sender: UITapGestureRecognizer) {
    var create: Bool!

    if let favorited = tweet.favorited {
      if (favorited){
        // Unfavorite
        create = false
      } else {
        // Favorite
        create = true
      }
    }

    TwitterClient.sharedInstance?.favorite(id: tweet.id!, create: create, success: { () -> () in
      if (create == true){
        // Favorite
        self.favoriteImageView.image = UIImage(named: "starred")
        self.tweet.favorited = true
        self.tweet.favoritesCount = self.tweet.favoritesCount + 1
        self.favoriteCountLabel.text = "\(self.tweet.favoritesCount) FAVORITES"
      } else {
        // Unfavorite
        self.favoriteImageView.image = UIImage(named: "star")
        self.tweet.favorited = false
        self.tweet.favoritesCount = self.tweet.favoritesCount - 1
        self.favoriteCountLabel.text = "\(self.tweet.favoritesCount) FAVORITES"
      }

      // Let other view controllers know the tweet has been updated
      self.delegate?.tweetDetailViewController(tweetDetailViewController: self, didUpdateTweet: self.tweet)

      return Void()
    }, failure: { (error: Error?) -> () in
      if let error = error {
        print(error.localizedDescription)
      }
    })
  }
}
