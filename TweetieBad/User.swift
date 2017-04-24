//
//  User.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/13/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class User: NSObject {

  var name: String?
  var screenname: String?
  var profileUrl: URL?
  var tagline: String?
  var dictionary: NSDictionary?
  var bannerUrl: URL?
  var followingCount: Int?
  var followersCount: Int?
  var statusesCount: Int?

  init(dictionary: NSDictionary){
    self.dictionary = dictionary

    name = dictionary["name"] as? String
    screenname = dictionary["screen_name"] as? String
    tagline = dictionary["description"] as? String

    let profileUrlString = dictionary["profile_image_url_https"] as? String
    if let profileUrlString = profileUrlString {
      profileUrl = URL(string: profileUrlString)
    }

    let bannerUrlString = dictionary["profile_banner_url"] as? String
    if let bannerUrlString = bannerUrlString {
      bannerUrl = URL(string: bannerUrlString)
    }

    followersCount = dictionary["followers_count"] as? Int
    followingCount = dictionary["friends_count"] as? Int
    statusesCount = dictionary["statuses_count"] as? Int
  }

  static let userDidLogoutNotification = "UserDidLogout"

  static var _currentUser: User?

  class var currentUser: User? {
    get {
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: "currentUserData") as? Data

        if let userData = userData,
          let dictionary = try? JSONSerialization.jsonObject(with: userData as Data, options: []) {
          _currentUser = User(dictionary: dictionary as! NSDictionary)
        }
      }
      return _currentUser
    }

    set(user) {
      _currentUser = user
      
      let defaults = UserDefaults.standard
      if let user = user,
        let userData = try? JSONSerialization.data(withJSONObject: user.dictionary!, options: []) {
          defaults.set(userData, forKey: "currentUserData")
      } else {
        defaults.removeObject(forKey: "currentUserData")
      }

      defaults.synchronize()
    }
  }

  static var _accounts: [User]?
  //static var userAccounts = [User]()

  class var userAccounts: [User]? {
    get {
      if _accounts == nil {
        let defaults = UserDefaults.standard
        let accountsData = defaults.object(forKey: "accountsData") as? Data

        if let accountsData = accountsData,
          let dictionary = try? JSONSerialization.jsonObject(with: accountsData as Data, options: []) {
            let users = dictionary as! [NSDictionary]
          for user in users {
            _accounts?.append(User(dictionary: user))
          }
        }
      }
      return _accounts
    }

    set(accounts) {
      _accounts = accounts

      let defaults = UserDefaults.standard
      if let accounts = accounts {
        var accountsData = [Data]()
        for user in accounts {
          if let item = try? JSONSerialization.data(withJSONObject: user.dictionary!, options: []) {
            accountsData.append(item)
          }
        }
        defaults.set(accountsData, forKey: "accountsData")
      } else {
        defaults.removeObject(forKey: "accountsData")
      }

      defaults.synchronize()
    }
  }
}
