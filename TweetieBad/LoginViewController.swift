//
//  LoginViewController.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/13/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func onLoginButton(_ sender: Any) {
    TwitterClient.sharedInstance?.login(success: {
      self.performSegue(withIdentifier: "hamburgerSegue", sender: nil)
    }, failure: { (error: Error) in
      print("error: \(error.localizedDescription)")
    })
  }

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let hamburgerViewController = segue.destination as! HamburgerViewController
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController

    menuViewController.hamburgerViewController = hamburgerViewController
    hamburgerViewController.menuViewController = menuViewController
  }
}
