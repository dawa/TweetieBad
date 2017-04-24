//
//  AccountsViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/23/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!

  var users: [User]?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 220

    users = User.userAccounts
    
    // Add account button
    let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    let plusView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "plus"))
    plusView.center = tableFooterView.center
    tableFooterView.addSubview(plusView)
    self.tableView.tableFooterView = tableFooterView
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users == nil ? 0 : users!.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
    cell.user = users?[indexPath.row]

    return cell
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let hamburgerViewController = segue.destination as! HamburgerViewController
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController

    menuViewController.hamburgerViewController = hamburgerViewController
    hamburgerViewController.menuViewController = menuViewController
  }

  @IBAction func onTapProfile(_ sender: UITapGestureRecognizer) {
    let imageView = sender.view as! UIImageView
    let cell = imageView.superview!.superview as! AccountCell
    User.currentUser = cell.user

    self.performSegue(withIdentifier: "accountsSegue", sender: cell)
  }
}
