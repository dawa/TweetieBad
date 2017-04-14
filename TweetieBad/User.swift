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

  init(dictionary: NSDictionary){
    name = dictionary["name"] as? String
    screenname = dictionary["screenname"] as? String
    tagline = dictionary["description"] as? String

    let profileUrlString = dictionary["profile_image_url_https"] as? String
    if let profileUrlString = profileUrlString {
      profileUrl = URL(string: profileUrlString)
    }
  }
}
