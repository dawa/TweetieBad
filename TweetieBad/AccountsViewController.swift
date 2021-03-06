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

  var users: [User]!
  var originalLocation: CGPoint!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 220

    users = Array(User.userAccounts.values)
    
    // Add account button
    let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    let plusView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "plus"))
    plusView.center = tableFooterView.center
    tableFooterView.addSubview(plusView)
    self.tableView.tableFooterView = tableFooterView

    // Add gesture recognizer to the account button
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPlusButton(sender:)))

    // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
    plusView.isUserInteractionEnabled = true
    plusView.addGestureRecognizer(tapGestureRecognizer)
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

  func didTapPlusButton(sender: UITapGestureRecognizer) {
    TwitterClient.sharedInstance?.logout()
    TwitterClient.sharedInstance?.login(success: {
//      let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//      let accountsViewController = storyboard.instantiateViewController(withIdentifier: "AccountsViewController")
//
//      self.navigationController?.pushViewController(accountsViewController, animated: true)
      self.dismiss(animated: true, completion: nil)
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
  }

  @IBAction func didPanAccount(_ sender: UIPanGestureRecognizer) {
    let velocity = sender.velocity(in: view)
    let translation = sender.translation(in: view)
    let account = sender.view as! AccountCell

    if sender.state == .began {
      originalLocation = account.center
    } else if sender.state == .changed {
      UIView.animate(withDuration: 0.5, animations: {
        account.center.x = self.originalLocation.x + translation.x
        account.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
      })
    } else if sender.state == .ended {
      if velocity.x > 0 {
        UIView.animate(withDuration: 0.3) {
          // Remove the user's account
          User.delete(user: account.user)
          if User.userAccounts.isEmpty == true {
            TwitterClient.sharedInstance?.logout()
          } else {
            self.users = Array(User.userAccounts.values)
            account.removeFromSuperview()
            self.tableView.reloadData()
          }
        }
      }
    }
  }

  @IBAction func onLogoutButton(_ sender: Any) {
    TwitterClient.sharedInstance?.logout()
  }
}
