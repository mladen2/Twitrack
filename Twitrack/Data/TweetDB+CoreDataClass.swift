//
//  TweetDB+CoreDataClass.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 12/08/2021.
//
//

import Foundation
import CoreData

@objc(TweetDB)
public class TweetDB: NSManagedObject {


    func populate(with tweet: Tweet, isSave: Bool = true) {

        self.idStr = tweet.idStr
        self.createdAt = tweet.createdAtDate
        self.dateReceived = tweet.timeReceived

        self.text = tweet.text
        self.fullText = tweet.fullTextAny
        self.favoriteCount = Int64(tweet.favoriteCount)
        self.replyCount = Int64(tweet.replyCount ?? 0)
        self.retweetCount = Int64(tweet.retweetCount)

        self.lattitude = tweet.geoLocation?.lattitude ?? 0
        self.longitude = tweet.geoLocation?.longitude ?? 0

        if let user = DataManager.shared.addUser(for: tweet.user, isSave: isSave) {
            self.user = user
        }
    }

    var longitudeLattitude: [Double] {
        [longitude, lattitude]
    }
}
