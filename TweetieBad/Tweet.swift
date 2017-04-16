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
  var retweeted: Bool?
  var favorited: Bool?
  //var author: User?
  var id: Int64?
  var user: NSDictionary?

  var screenName: String!
  var realName: String?
  var profileImageUrl: URL?
  var retweetedByName: String?

  init(dictionary: NSDictionary){

    if let id_key = dictionary["id"]{
      if let id_int = id_key as? NSNumber {
        self.id = id_int.int64Value
      }
    }

    if let retweeted_status = dictionary["retweeted_status"] as? NSDictionary{
      if let retweeted = retweeted_status["retweeted"] as? Bool{
        self.retweeted = retweeted
      }

      if let favorited = retweeted_status["favorited"] as? Bool{
        self.favorited = favorited
      }

      if let user = retweeted_status["user"] as? NSDictionary {
        self.user = user

        if let statusText = retweeted_status["text"] as? String {
          self.text = statusText
        }else{
          self.text = ""
        }

        retweetCount = (retweeted_status["retweet_count"] as? Int) ?? 0
        favoritesCount = (retweeted_status["favorite_count"] as? Int) ?? 0

        let timestampString = retweeted_status["created_at"] as? String
        if let timestampString = timestampString{
          let formatter = DateFormatter()
          formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
          timestamp = formatter.date(from: timestampString)
        }

        if let profileImageUrl = user["profile_image_url_https"] as? String{
          if let realUrl = URL(string: profileImageUrl) {
            self.profileImageUrl = realUrl
          }
        }

        var screenNameInRTUser = false
        var realNameInRTUser = false
        if let screenName = user["screen_name"] as? String {
          self.screenName = screenName
          screenNameInRTUser = true
        }
        if let realName = user["name"] as? String {
          self.realName = realName
          realNameInRTUser = true
        }

        if screenNameInRTUser == false || realNameInRTUser == false{
          // Look for it in the entities dict if it's not in the retweeted_status > user dict
          if let entities = dictionary["entities"] as? NSDictionary {
            if let user_mentions = entities["user_mentions"] as? [NSDictionary] {
              if let name = user_mentions[0]["name"] as? String{
                self.realName = name
              }
              if let screenNameTmp = user_mentions[0]["screen_name"] as? String{
                self.screenName = screenNameTmp
              }
            }
          }
        }
      } else
        if let retweetedByUser = dictionary["user"] as? NSDictionary {
          if let realName = retweetedByUser["name"] as? String {
            self.retweetedByName = realName
          }
      }
    } else {
      if let retweeted = dictionary["retweeted"] as? Bool{
        self.retweeted = retweeted
      }

      if let favorited = dictionary["favorited"] as? Bool{
        self.favorited = favorited
      }

      text = (dictionary["text"] as? String) ?? ""
      retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
      favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0

      let timestampString = dictionary["created_at"] as? String
      if let timestampString = timestampString{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"

        timestamp = formatter.date(from: timestampString)
      }

      if let user = dictionary["user"] as? NSDictionary {
        self.user = user
        if let profileImageUrl = user["profile_image_url_https"] as? String{
          if let realUrl = URL(string: profileImageUrl) {
            self.profileImageUrl = realUrl
          }
        }
        if let screenName = user["screen_name"] as? String {
          self.screenName = screenName
        }
        if let realName = user["name"] as? String {
          self.realName = realName
        }
      }
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
