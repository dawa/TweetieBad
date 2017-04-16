//
//  TweetsViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/14/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  var isMoreDataLoading = false
  var tweets: [Tweet]!
  var maxId: Int64?

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

    // Infinite Scrolling
    let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    loadingView.startAnimating()
    loadingView.center = tableFooterView.center
    tableFooterView.addSubview(loadingView)
    self.tableView.tableFooterView = tableFooterView

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
    var parameters: [String : AnyObject] = [String : AnyObject]()

    if maxId != nil {
      parameters["max_id"] = maxId as AnyObject?
    }

    TwitterClient.sharedInstance?.homeTimeline(parameters: parameters, success: { (tweets: [Tweet]) in
      // If scrolling add the contents to the tweets array otherwise reloading
      if self.maxId == nil {
        self.tweets = tweets
      } else {
        self.tweets.append(contentsOf: tweets)
      }

      self.isMoreDataLoading = false
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
  }

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "detailsSegue"){
      let navController = segue.destination as! UINavigationController
      let destinationViewController = navController.topViewController as! TweetDetailViewController
      let cell = sender as! MessageCell
      let indexPath = tableView.indexPath(for: cell)!
      destinationViewController.tweet = tweets![indexPath.row]
    }
  }

  func refreshControlAction(refreshControl: UIRefreshControl){
    homeTimeline()
    refreshControl.endRefreshing()
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      // Calculate the position of one screen length before the bottom of the results
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

      // When the user has scrolled past the threshold, start requesting
      if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
        isMoreDataLoading = true

        if let maxId = tweets.last?.id {
          self.maxId = maxId - 1
        }

        homeTimeline()
      }
    }
  }

  @IBAction func onLogoutButton(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
  }
}
