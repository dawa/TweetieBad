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
    let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")! as URL, consumerKey: "b52iYR83b8M9b2GjN3bMQ6orF", consumerSecret: "axPai6SekbuqhcAlcz4g2yRsTlXkj3SLk6gL5c1ussCWE4UVaN")

    twitterClient?.deauthorize()
    twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "tweetiebad://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
      print("I got a token! \(requestToken!.token!)")
      let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")
      UIApplication.shared.open(url!, options: [:], completionHandler: { (bool: Bool) -> Void in
        print("completion handler fired")
      })
    }, failure: {(error: Error!) -> Void in
      print("error: \(error.localizedDescription)")
    })
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
