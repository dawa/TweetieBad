//
//  TweetsViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/14/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetDetailViewControllerDelegate, ComposeViewControllerDelegate, UIScrollViewDelegate {

  @IBOutlet weak var tableView: UITableView!

  var isMoreDataLoading = false
  var tweets: [Tweet]!
  var maxId: Int64?
  var mentionsTimeline = false

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

    timeLine()
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

  func timeLine() {
    var parameters: [String : AnyObject] = [String : AnyObject]()

    if maxId != nil {
      parameters["max_id"] = maxId as AnyObject?
    }

    if mentionsTimeline == true {
      TwitterClient.sharedInstance?.mentionsTimeline(parameters: parameters, success: { (tweets: [Tweet]) in
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
    } else {
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
  }

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "detailsSegue"){
      let navController = segue.destination as! UINavigationController
      let destinationViewController = navController.topViewController as! TweetDetailViewController
      let cell = sender as! MessageCell
      let indexPath = tableView.indexPath(for: cell)!
      destinationViewController.tweet = tweets![indexPath.row]
      destinationViewController.delegate = self
    } else if (segue.identifier == "newSegue"){
      let navController = segue.destination as! UINavigationController
      let destinationViewController = navController.topViewController as! ComposeViewController
      destinationViewController.delegate = self
    } else if(segue.identifier == "profileSegue"){
      let navController = segue.destination as! UINavigationController
      let destinationViewController = navController.topViewController as! ProfileViewController

      let cell = sender as! MessageCell
      let indexPath = tableView.indexPath(for: cell)!
      let tweet = tweets![indexPath.row]
      destinationViewController.screenName = tweet.screenName
    }
  }

  func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, didUpdateTweet tweet: Tweet) {
    if let index = tweets.index(of: tweet) {
      // Update the tweet with new object
      tweets[index] = tweet
    } else {
      // Prepend the new tweet
      tweets.insert(tweet, at: 0)
    }
    tableView.reloadData()
  }

  func composeViewController(composeViewController: ComposeViewController, didCreateTweet tweet: Tweet) {
    // Prepend the new tweet
    tweets.insert(tweet, at: 0)
    tableView.reloadData()
  }

  func refreshControlAction(refreshControl: UIRefreshControl){
    timeLine()
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

        timeLine()
      }
    }
  }

  @IBAction func onLogoutButton(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
  }

  @IBAction func onTapProfile(_ sender: UITapGestureRecognizer) {
    let imageView = sender.view as! UIImageView
    let cell = imageView.superview!.superview as! MessageCell //(of: MessageCell())

    self.performSegue(withIdentifier: "profileSegue", sender: cell)
  }

  @IBAction func onLongPressAccounts(_ sender: UILongPressGestureRecognizer) {
    self.performSegue(withIdentifier: "homeAccountsSegue", sender: nil)
  }
}

extension UIView {
  func superview<T>(of type: T.Type) -> T? {
    return superview as? T ?? superview.flatMap { $0.superview(of: T.self) }
  }
}
