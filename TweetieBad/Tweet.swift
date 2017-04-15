//
//  Tweet.swift
//  TweetieBad
//
//  Created by Davis Wamola on 4/13/17.
//  Copyright © 2017 Davis Wamola. All rights reserved.
//

import UIKit

class Tweet: NSObject {

  var text: String?
  var timestamp: Date?
  var retweetCount: Int = 0
  var favoritesCount: Int = 0
  var author: User?

  init(dictionary: NSDictionary) {
    text = dictionary["text"] as? String
    retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
    favoritesCount = (dictionary["favourite_count"] as? Int) ?? 0
    author = User(dictionary: (dictionary["user"] as? NSDictionary)!)

    let timestampString = dictionary["created_at"] as? String
    if let timestampString = timestampString {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timestamp = formatter.date(from: timestampString)
    }
  }
  
  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()

    for dictionary in dictionaries {
      let tweet = Tweet(dictionary: dictionary)
      tweets.append(tweet)
    }

    return tweets
  }
}
