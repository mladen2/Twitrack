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

/// class instead of struct because structs don't support recursive fields
/// here there is at least Tweet/retweetedStatus
final class Tweet: Decodable, Identifiable, Equatable {

    var id: Int
    var idStr: String
    var text: String?
    var fullText: String?
    var fullTextAny: String {
        let retw = retweetedStatus?.extendedTweet?.fullText
        let extt = extendedTweet?.fullText
        let text2 = extt ?? retw ?? fullText ?? text ?? ""
        return text2
    }
    var textHighlighted: NSAttributedString {
        HighlightHelper.highlight(in: fullTextAny)
    }

    var createdAt: String
    var createdAtDate: Date? {
        Date(createdAt)
    }

    var timeReceived: Date? = Date() // not doing anything, or is it

    var user: User
    var retweetedStatus: Tweet? // needed for obtaining the full status
    var extendedTweet: ExtendedTweet? // ditto

    var favoriteCount: Int
    var retweetCount: Int
    var replyCount: Int?

    var hasGeoData: Bool {
        coordinates != nil || place != nil || geo != nil
    }
    var geoLocation: LocationPoint? {

        if let coor = coordinates {
            return LocationPoint(coor.coordinates)
        }

        if let coor = geo?.coordinates {
            return LocationPoint(coor.reversed()) // latt long -> long, lat
        }

        if let boundingBox = place?.boundingBox {
            return boundingBox.centre
        }

        return nil
    }
    var coordinates: Coordinates?
    var place: Place?
    var geo: Geo?

    var errors: [TwitterError]?

    init() {
        self.id = 123
        self.idStr = "123"
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

    internal init(id: Int, idStr: String, text: String? = nil, fullText: String? = nil, createdAt: String, timeReceived: Date? = nil, user: User, retweetedStatus: Tweet? = nil, favoriteCount: Int, retweetCount: Int, replyCount: Int? = nil, coordinates: Coordinates? = nil, errors: [TwitterError]? = nil) {
        self.id = id
        self.idStr = idStr
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

    convenience init(_ tweetDB: TweetDB) {
        self.init()
        self.idStr = tweetDB.idStr ?? ""

        self.createdAt = tweetDB.createdAt?.stringValue ?? ""
        self.timeReceived = tweetDB.dateReceived

        self.text = tweetDB.text
        self.fullText = tweetDB.fullText
        self.favoriteCount = Int(tweetDB.favoriteCount)
        self.replyCount = Int(tweetDB.replyCount)
        self.retweetCount = Int(tweetDB.retweetCount)

        if tweetDB.lattitude != 0 && tweetDB.longitude != 0 {
            self.coordinates = Coordinates(type: BoundingBoxType.Point.rawValue, coordinates: tweetDB.longitudeLattitude)
        }

        self.user = tweetDB.user != nil ? User(tweetDB.user!) : User.test
    }
}


extension Tweet {

    static var test: Tweet {

        let tweet = Tweet(id: 12345678,
                          idStr: "12345678",
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



struct ExtendedTweet: Decodable {
    let fullText: String
}

struct TwitterError: Decodable, Equatable {
    var code: Int
    var message: String
}

// 1. long 2. lat?
struct Geo: Decodable {
    let type: String
    let coordinates: [Double]
}

// 1. lat, 2. long?
struct Coordinates: Decodable {
    let type: String
    let coordinates: [Double]
}

struct Place: Decodable {
    let id: String
    let url: String
    let placeType: String
    let name: String
    let boundingBox: BoundingBox
}

struct BoundingBox: Decodable {
    let type: String
    let coordinates: [[[Double]]]
}

/**
 "bounding_box": {
     "type": "Polygon",
     "coordinates": [
         [
             [
                 -87.940033,
                 41.644102
             ],
             [
                 -87.940033,
                 42.023067
             ],
             [
                 -87.523993,
                 42.023067
             ],
             [
                 -87.523993,
                 41.644102
             ]
         ]
     ]
 },
 */

enum BoundingBoxType: String {
    case Polygon, Point
}

extension BoundingBox {

    var centre: LocationPoint? {

        guard let type = BoundingBoxType(rawValue: type) else { return nil }

        switch type {

        case .Polygon:
            guard let locations = coordinates.first else { return nil }
            let rect = LocationRect(locations)
            return rect?.centre

        case .Point:
            // not sure if bounding box will be sent with one point only, probably not
            if let first = coordinates.first?.first {
                return LocationPoint(first)
            }
        }
        return nil
    }
}
