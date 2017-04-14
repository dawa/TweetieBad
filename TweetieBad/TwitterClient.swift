//
//  TwitterClient.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/13/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

  static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL, consumerKey: "b52iYR83b8M9b2GjN3bMQ6orF", consumerSecret: "axPai6SekbuqhcAlcz4g2yRsTlXkj3SLk6gL5c1ussCWE4UVaN")

  var loginSuccess: (() -> ())?
  var loginFailure: ((Error) -> ())?

  func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    loginSuccess = success
    loginFailure = failure

    deauthorize()
    fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "tweetiebad://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
      print("I got a token! \(requestToken!.token!)")
      let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")
      UIApplication.shared.open(url!, options: [:], completionHandler: { (bool: Bool) -> Void in
        print("completion handler fired")
      })
    }, failure: {(error: Error!) -> Void in
      //print("error: \(error.localizedDescription)")
      self.loginFailure?(error)
    })
  }

  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)

    fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential!) -> Void in
      print("I got an access token")
      self.loginSuccess?()
//      self.currentAccount(success: { (user: User) in
//        print("Username: \(String(describing: user.name))")
//      }, failure: { (error: Error) in
//        print("error: \(error.localizedDescription)")
//      })
//
    }, failure: {(error: Error!) -> Void in
      print("error: \(error.localizedDescription)")
      self.loginFailure?(error)
    })
  }

  func homeTimeline(sucess: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      //print("Timeline: \(response!)")
      let dictionaries = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
      sucess(tweets)
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }

  func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      //print("Account: \(response!)")
      let userDictionary = response as! NSDictionary
      let user = User(dictionary: userDictionary)
      success(user)
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
}
