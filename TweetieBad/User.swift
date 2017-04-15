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

  init(dictionary: NSDictionary){
    self.dictionary = dictionary

    name = dictionary["name"] as? String
    screenname = dictionary["screenname"] as? String
    tagline = dictionary["description"] as? String

    let profileUrlString = dictionary["profile_image_url_https"] as? String
    if let profileUrlString = profileUrlString {
      profileUrl = URL(string: profileUrlString)
    }
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
        defaults.set(nil, forKey: "currentUserData")
      }

      defaults.synchronize()
    }
  }

}
