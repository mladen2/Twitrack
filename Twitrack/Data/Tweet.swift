//
//  Tweet.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import UIKit


typealias SortDescriptor<Value> = (Value, Value) -> Bool

let tweetByDateCreatedDesc: SortDescriptor<Tweet> = {
    if $0.createdAtDate == nil { return false }
    if $1.createdAtDate == nil { return true }
    return $0.createdAtDate! > $1.createdAtDate!
}

let tweetByDateCreatedAsc: SortDescriptor<Tweet> = {
    if $0.createdAtDate == nil { return true }
    if $1.createdAtDate == nil { return false }
    return $0.createdAtDate! < $1.createdAtDate!
}

class Tweet: Decodable, Identifiable, Equatable {

    var id: Int
//    var idStr: String
    var text: String?
    var textHighlighted: NSAttributedString {
        let retw = retweetedStatus?.extendedTweet?.fullText
        let extt = extendedTweet?.fullText
        let text2 = extt ?? retw ?? fullText ?? text ?? ""
        return HighlightHelper.highlight(in: text2)
    }
    var fullText: String?

    var createdAt: String
    var createdAtDate: Date? {
        Date(createdAt)
    }

    var timeReceived: Date? = Date() // not doing anything, or is it

    var user: User
    var retweetedStatus: Tweet?
    var extendedTweet: ExtendedTweet?

    var favoriteCount: Int
    var retweetCount: Int
    var replyCount: Int?

    var coordinates: Coordinates?
    var errors: [TwitterError]?

    init() {
        self.id = 123
        self.text = "text"
        self.fullText = "fullText"
        self.createdAt = "createdAt"
        self.timeReceived = Date()
        self.user = User.test
        self.retweetedStatus = nil
        self.favoriteCount = 0
        self.retweetCount = 0
        self.replyCount = 0
        self.coordinates = nil
        self.errors = nil
    }

    internal init(id: Int, text: String? = nil, fullText: String? = nil, createdAt: String, timeReceived: Date? = nil, user: User, retweetedStatus: Tweet? = nil, favoriteCount: Int, retweetCount: Int, replyCount: Int? = nil, coordinates: Coordinates? = nil, errors: [TwitterError]? = nil) {
        self.id = id
        self.text = text
        self.fullText = fullText
        self.createdAt = createdAt
        self.timeReceived = timeReceived ?? Date()
        self.user = user
        self.retweetedStatus = retweetedStatus
        self.favoriteCount = favoriteCount
        self.retweetCount = retweetCount
        self.replyCount = replyCount
        self.coordinates = coordinates
        self.errors = errors
    }

    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        lhs.id == rhs.id
    }
}

extension Tweet {

}

extension Tweet {

    static var test: Tweet {

        let tweet = Tweet(id: 12345678,
//                          idStr: UUID().uuidString,
                          text: """
            You could write separate domain and persistence layers (separate modules even better)

                          Domain: business logic (with structs if you wanted)
                          Repository: persistence on API/databases/disk/etc

                          Done well, your domain could work with any persistence layer.
        """, fullText: "ethaucdeo /",
                          createdAt: "",
                          timeReceived: Date(),
                          user: User.test,
                          favoriteCount: 12,
                          retweetCount: 13,
                          replyCount: 14)
        return tweet
    }
}

struct User: Decodable, Identifiable, Equatable {

    var id: Int
    var name: String
    var screenName: String
    var location: String?

    var createdAt: String

    var profileImageUrlHttps: String?
    var avatarImageData: Data?
    var avatarImage: UIImage? {
        if let data = avatarImageData,
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }

    var followersCount: Int
    var statusesCount: Int
    var errors: [TwitterError]?
}

extension User {

    static var test: User {
        let user = User(id: 123456778, name: "Test User", screenName: "Test User", location: "Berlin", createdAt: "1234", profileImageUrlHttps: "test.com", avatarImageData: RandomSystemImage.image.pngData(), followersCount: 1, statusesCount: 2)
        return user
    }

}

struct ExtendedTweet: Decodable {
    let fullText: String
}

struct TwitterError: Decodable, Equatable {
    var code: Int
    var message: String
}

struct Coordinates: Decodable, Equatable {

}
