//
//  TweetDB+CoreDataProperties.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 12/08/2021.
//
//

import Foundation
import CoreData


extension TweetDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetDB> {
        return NSFetchRequest<TweetDB>(entityName: "TweetDB")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var favoriteCount: Int64
    @NSManaged public var fullText: String?
    @NSManaged public var idStr: String?
    @NSManaged public var lattitude: Double
    @NSManaged public var replyCount: Int64
    @NSManaged public var retweetCount: Int64
    @NSManaged public var text: String?
    @NSManaged public var dateReceived: Date?
    @NSManaged public var longitude: Double
    @NSManaged public var user: UserDB?

}

extension TweetDB : Identifiable {

}
