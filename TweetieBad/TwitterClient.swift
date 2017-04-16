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

      let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")
      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }, failure: {(error: Error!) -> Void in
      self.loginFailure?(error)
    })
  }

  func logout() {
    User.currentUser = nil
    deauthorize()
    NotificationCenter.default.post(name: Notification.Name(rawValue: User.userDidLogoutNotification), object: nil)
  }

  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)

    fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential!) -> Void in
      self.currentAccount(success: { (user: User) in
        User.currentUser = user
        self.loginSuccess?()
      }, failure: { (error: Error) in
        self.loginFailure?(error)
      })
    }, failure: {(error: Error!) -> Void in
      self.loginFailure?(error)
    })
  }

  func homeTimeline(parameters: [String : AnyObject]? = nil, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      //print("Timeline: \(response!)")
      let dictionaries = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
      success(tweets)
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

  func favorite(id: Int64, create: Bool, success: @escaping () -> (), failure: @escaping (Error?) -> ()){
    let endpoint: String!

    // favorite or unfavorite
    if (create) {
      endpoint  = "1.1/favorites/create.json"
    }else{
      endpoint = "1.1/favorites/destroy.json"
    }

    var params = Dictionary<String, Any>()
    params["id"] = id

    post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      success()
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }

  func retweet(id: Int64, create: Bool, success: @escaping () -> (), failure: @escaping (Error?) -> ()){
    let endpoint: String!

    // retweet or unretweeet
    if (create) {
      endpoint = "1.1/statuses/retweet/\(id).json"
    }else{
      endpoint = "1.1/statuses/unretweet/\(id).json"
    }

    var params = Dictionary<String, Any>()
    params["id"] = id

    post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      success()
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }

  func postTweet(tweet: String, id: Int64?, success: @escaping (Tweet) -> (), failure: @escaping (Error?) -> ()){
    if (tweet.characters.count > 140 || tweet.characters.count == 0) {
      failure(nil)
      return
    }

    var params = Dictionary<String, Any>()
    params["status"] = tweet

    if id != nil {
      params["in_reply_to_status_id"] = id
    }

    post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      print("Tweet: \(response!)")
      let tweetDictionary = response as! NSDictionary
      let tweet = Tweet(dictionary: tweetDictionary)
      success(tweet)
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      failure(error)
    })
  }
}
