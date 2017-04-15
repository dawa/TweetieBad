//
//  TweetsViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/14/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  var tweets: [Tweet]!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Initialize a UIRefreshControl
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)

    tableView.insertSubview(refreshControl, at: 0)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 220

    homeTimeline()
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

  func homeTimeline() {
    TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
  }

  func refreshControlAction(refreshControl: UIRefreshControl){
    homeTimeline()
    refreshControl.endRefreshing()
  }

  @IBAction func onLogoutButton(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
  }
}
