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

  var viewControllers: [UIViewController] = []
  var hamburgerViewController: HamburgerViewController!

  let titles = ["Profile", "Timeline", "Mentions"]

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self

    // Instantiate the navigation controllers and add them to the array
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
    timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
    mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")

    viewControllers.append(profileNavigationController)
    viewControllers.append(timelineNavigationController)
    viewControllers.append(mentionsNavigationController)

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
