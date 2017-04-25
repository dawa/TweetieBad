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

  static var userAccounts = [String: User]()
  static var _currentUser: User?

  class var currentUser: User?{
    get {
      if _currentUser == nil {
        if userAccounts.isEmpty == true {
          print("no users")
        }
        let defaults = UserDefaults.standard

        let usersData = defaults.object(forKey: "currentUserData") as? [String: Data]
        if let usersData = usersData {
          for (_, uservalue) in usersData {
            let dictionary = try! JSONSerialization.jsonObject(with: uservalue, options: []) as! NSDictionary
            _currentUser = User(dictionary: dictionary)
            if userAccounts[(_currentUser?.screenname)!] == nil {
              userAccounts[(_currentUser?.screenname)!] = _currentUser
            }
          }

        }
      }
      return _currentUser
    }
    set(user) {
      if user == nil {
        userAccounts.removeValue(forKey: (_currentUser?.screenname)!)
        _currentUser = user

      }
      else {
        _currentUser = user
        userAccounts[(_currentUser?.screenname)!] = _currentUser
      }

      let defaults = UserDefaults.standard

      if userAccounts.isEmpty {
        defaults.removeObject(forKey: "currentUserData")
      }
      else {
        var userData = [String: Data]()
        for (userkey, uservalue) in userAccounts {
          let data = try! JSONSerialization.data(withJSONObject: uservalue.dictionary!, options: [])
          userData[userkey] = data
        }
        defaults.set(userData, forKey: "currentUserData")
      }

      defaults.synchronize()

    }
  }

  class func changeUser(user: User) {
    if userAccounts[user.screenname!] != nil {
      _currentUser = user
    }
  }

  class func delete(user: User) {
    if _currentUser?.screenname == user.screenname {
      for (_, value) in userAccounts {
        if value.screenname != _currentUser?.screenname {
          _currentUser = value
          break
        }
      }
    }
    if userAccounts[user.screenname!] != nil {
      userAccounts.removeValue(forKey: user.screenname!)
    }
  }
}
