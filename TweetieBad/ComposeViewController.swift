//
//  ComposeViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/15/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

  @IBOutlet weak var messageTextView: UITextView!
  @IBOutlet weak var placeholderLabel: UILabel!
  @IBOutlet weak var charactersLeftLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!

  var tweet: Tweet!
  var maxCharacters = 140

  override func viewDidLoad() {
      super.viewDidLoad()

    messageTextView.delegate = self
    self.automaticallyAdjustsScrollViewInsets = false

    if let username = tweet.realName {
      usernameLabel.text = username
    }

    if let screenname = tweet.screenName {
      screennameLabel.text = "@\(screenname)"
      messageTextView.text = "@\(screenname)"
      placeholderLabel.isHidden = true
    }

    if let profileImageUrl = tweet.profileImageUrl {
      self.profileImageView.setImageWith(profileImageUrl)
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func textViewDidChange(_ textView: UITextView) {
    if let messageText = messageTextView.text {
      if messageText.isEmpty {
        placeholderLabel.isHidden = false
      }else{
        placeholderLabel.isHidden = true
      }

      let charactersLeft = maxCharacters - messageText.characters.count

      charactersLeftLabel.text = "\(charactersLeft)"
      if(charactersLeft < 0) {
        charactersLeftLabel.textColor = UIColor.red
      }else{
        charactersLeftLabel.textColor = UIColor.black
      }
    }
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    placeholderLabel.isHidden = true
  }

  @IBAction func onCancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func onTweetButton(_ sender: Any) {
    guard messageTextView.text.characters.count > 0 &&
      messageTextView.text.characters.count <= 140 else {
      return
    }

    TwitterClient.sharedInstance?.postTweet(tweet: messageTextView.text, id: tweet.id, success: { () -> () in
        self.dismiss(animated: true)
        return Void()
    }, failure: { (error: Error?) -> () in
        if let error = error {
          print(error.localizedDescription)
        }
    })
  }
}
