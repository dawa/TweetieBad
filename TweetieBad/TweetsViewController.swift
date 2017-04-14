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

    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120

    TwitterClient.sharedInstance?.homeTimeline(sucess: { (tweets: [Tweet]) in
      self.tweets = tweets
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tweets == nil ? 0 : self.tweets!.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
    cell.messagesLabel.text = tweets[indexPath.row].text
    return cell
  }

  @IBAction func onLogoutButton(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
  }
}
