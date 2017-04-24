//
//  MenuViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/20/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!

  private var profileNavigationController: UIViewController!
  private var timelineNavigationController: UIViewController!
  private var mentionsNavigationController: UIViewController!
  private var accountsNavigationController: UIViewController!

  var viewControllers: [UIViewController] = []
  var hamburgerViewController: HamburgerViewController!

  let titles = ["Profile", "Timeline", "Mentions", "Accounts"]

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 165

    // Instantiate the navigation controllers and add them to the array
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
    viewControllers.append(profileNavigationController)

    timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
    viewControllers.append(timelineNavigationController)

    mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
    let tweetsViewController = mentionsNavigationController.childViewControllers.first as! TweetsViewController
    tweetsViewController.mentionsTimeline = true
    viewControllers.append(mentionsNavigationController)

    accountsNavigationController = storyboard.instantiateViewController(withIdentifier: "AccountsNavigationController")
    viewControllers.append(accountsNavigationController)

    hamburgerViewController.contentViewController = timelineNavigationController
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewControllers.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell

    cell.menuTitleLabel.text = titles[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    hamburgerViewController.contentViewController = viewControllers[indexPath.row]
  }
}
