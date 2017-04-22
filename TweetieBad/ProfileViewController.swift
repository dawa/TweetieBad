//
//  ProfileViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/21/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetsLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var followingLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!

  var user: User!
  var tweets: [Tweet]!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 220
    tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")

    user = User.currentUser!
    profile()
  }

  func profile() {
    TwitterClient.sharedInstance?.userTimeline(screen_name: user.screenname!, success: { (tweets: [Tweet]) in
        self.tweets = tweets
        self.tableView.reloadData()
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })

    usernameLabel.text = user.name
    screennameLabel.text = "@\(user.screenname!)"

    if user.profileUrl != nil {
      profileImageView.setImageWith(user.profileUrl!)
    }

    if user.bannerUrl != nil {
      backgroundImageView.setImageWith(user.bannerUrl!)
    }

    if user.followersCount != nil {
      followersLabel.text = "\(user.followersCount!) FOLLOWERS"
    }

    if user.followingCount != nil {
      followingLabel.text = "\(user.followingCount!) FOLLOWING"
    }

    if user.statusesCount != nil {
      tweetsLabel.text = "\(user.statusesCount!) TWEETS"
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets == nil ? 0 : tweets!.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

    cell.tweet = tweets[indexPath.row]
    return cell
  }
}
