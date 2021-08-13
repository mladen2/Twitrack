//
//  UserDB+CoreDataProperties.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 12/08/2021.
//
//

import Foundation
import CoreData


extension UserDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDB> {
        return NSFetchRequest<UserDB>(entityName: "UserDB")
    }

    @NSManaged public var idStr: String?
    @NSManaged public var screenName: String?
    @NSManaged public var name: String?
    @NSManaged public var followersCount: Int64
    @NSManaged public var statusesCount: Int64
    @NSManaged public var avatarImage: Data?
    @NSManaged public var location: String?
    @NSManaged public var profileImageUrlHttps: String?
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for tweets
extension UserDB {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: TweetDB)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: TweetDB)

    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)

}

extension UserDB : Identifiable {

}
