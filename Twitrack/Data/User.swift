//
//  User.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 12/08/2021.
//

import UIKit


struct User: Decodable, Identifiable, Equatable {

    var id: Int
    var idStr: String
    var name: String
    var screenName: String
    var location: String?

//    var createdAt: String
//    var createdAtDate: Date? {
//        Date(createdAt)
//    }

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
        let user = User(id: 123456778,
                        idStr: "12345678",
                        name: "Test User",
                        screenName: "Test User",
                        location: "Berlin",
//                        createdAt: "1234",
                        profileImageUrlHttps: "test.com",
                        avatarImageData: RandomSystemImage.image.pngData(),
                        followersCount: 1,
                        statusesCount: 2)
        return user
    }

}

extension User {

    init(_ user: UserDB) {

        self.idStr = user.idStr ?? ""
        if let id2 = user.idStr, let intVal = Int(id2) {
            self.id = intVal
        } else {
            self.id = 0
        }

//        self.createdAt = user.createdAt?.stringValue ?? ""
        self.location = user.location

        self.name = user.name ?? ""
        self.screenName = user.screenName ?? ""
        self.location = user.location

        self.profileImageUrlHttps = user.profileImageUrlHttps
        self.avatarImageData = user.avatarImage

        self.followersCount = Int(user.followersCount)
        self.statusesCount = Int(user.statusesCount)
    }
}

