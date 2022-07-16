//
//  DataManager.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 12/08/2021.
//

import UIKit
import CoreData

struct EntityName {
    static let user = "UserDB"
    static let tweet = "TweetDB"
}

struct ColumnName {
    static let id = "id"
    static let idStr = "idStr"
    static let dateCreated = "createdAt"
    static let dateReceived = "dateReceived"
}

struct CoreDataQuery {
    static let idStr = "idStr == %@"
    static let name = "name == %@"
    static let beforeDateReceived = "dateReceived < %@"
}

final class DataManager {

    static let shared = DataManager()

    lazy var container: NSPersistentContainer = {
        var container: NSPersistentContainer!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }()

    var context: NSManagedObjectContext { container.viewContext }
}

// MARK: Tweet
extension DataManager {

    @discardableResult
    func addTweet(for tweet: Tweet, isSave: Bool = true) -> TweetDB? {

        let dbTweet = fetchTweet(with: tweet.idStr)

        guard dbTweet == nil else {
            pr("tweet already exists: \(dbTweet?.idStr ?? "")")
            return dbTweet
        }

        if let entityDescripition = NSEntityDescription.entity(forEntityName: EntityName.tweet, in: context) {
            let tweetDB = TweetDB(entity: entityDescripition, insertInto: context)
            tweetDB.populate(with: tweet, isSave: isSave)
            if isSave {
                saveContext()
            }
            return tweetDB
        }

        return nil
    }

    func fetchTweet(with idStr: String) -> TweetDB? {
        tweets(predicate: NSPredicate(format: CoreDataQuery.idStr, idStr as CVarArg))?.first
    }

    func tweets(predicate: NSPredicate? = nil,
                sortColumn: String? = ColumnName.dateReceived,
                ascending: Bool = false,
                limit: Int? = nil) -> [TweetDB]? {

        managedObjects(entityName: EntityName.tweet,
                       predicate: predicate,
                       sortColumn: sortColumn,
                       ascending: ascending,
                       limit: limit) as? [TweetDB]
    }

    func save(_ tweets: [Tweet]) {

        for tweet in tweets {
            addTweet(for: tweet, isSave: false)
        }
        saveContext()
    }

    func purgeExpired(before date: Date) {

        guard let tweets = tweets(predicate: NSPredicate(format: CoreDataQuery.beforeDateReceived, date as CVarArg)), !tweets.isEmpty else {
            return
        }

        for i in 0..<tweets.count {
            let tweet = tweets[i]
            if let user = tweet.user,
               let userTweets = user.tweets,
               userTweets.count == 1 {
                context.delete(user)
            }
            context.delete(tweet)
        }

        saveContext()
    }
}

// MARK: User
extension DataManager {

    @discardableResult
    func addUser(for user: User, isSave: Bool = true) -> UserDB? {

        let dbUser = fetchUser(with: user.idStr)

        guard dbUser == nil else {
            pr("tweet already exists: \(dbUser?.idStr ?? "")")
            return dbUser
        }

        if let entityDescripition = NSEntityDescription.entity(forEntityName: EntityName.user, in: context) {

            let userDB = UserDB(entity: entityDescripition, insertInto: context)
            userDB.populate(with: user)
            if isSave {
                saveContext()
            }
            return userDB
        }
        return nil
    }

    func fetchUser(with idStr: String) -> UserDB? {
        users(predicate: NSPredicate(format: CoreDataQuery.idStr, idStr as CVarArg))?.first
    }

    func users(predicate: NSPredicate? = nil,
               sortColumn: String? = ColumnName.idStr,
               ascending: Bool = false,
               limit: Int? = nil) -> [UserDB]? {

        managedObjects(entityName: EntityName.user,
                       predicate: predicate,
                       sortColumn: sortColumn,
                       ascending: ascending,
                       limit: limit) as? [UserDB]
    }
}

// MARK: General
extension DataManager {

    func managedObjects(entityName: String,
                        predicate: NSPredicate? = nil,
                        sortColumn: String? = nil,
                        ascending: Bool = true,
                        limit: Int? = nil) -> [NSManagedObject]? {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        if let lim = limit {
            request.fetchLimit = lim
        }

        request.includesPendingChanges = true

        if predicate != nil {
            request.predicate = predicate
        }

        if let sc = sortColumn {
            let sortDescriptor = NSSortDescriptor(key: sc, ascending: ascending)
            request.sortDescriptors = [sortDescriptor]
        }

        var objs: [Any]?
        do {
            objs = try context.fetch(request)
        } catch {
            print("Error execute request: \(error.localizedDescription)")
        }

        return objs as? [NSManagedObject]
    }

    func saveContext () {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            pr("Error saving context: \(error.localizedDescription)\n\(error.userInfo)")
        }
    }
}
