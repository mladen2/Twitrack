//
//  UserDB+CoreDataClass.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 12/08/2021.
//
//

import Foundation
import CoreData

@objc(UserDB)
public class UserDB: NSManagedObject {

    func populate(with user: User) {

        self.idStr = user.idStr
//        self.createdAt = user.createdAtDate

        self.name = user.name
        self.screenName = user.screenName
        self.location = user.location

        self.profileImageUrlHttps = user.profileImageUrlHttps
        self.avatarImage = user.avatarImage?.jpegData(compressionQuality: 1.0)

        self.followersCount = Int64(user.followersCount)
        self.statusesCount = Int64(user.statusesCount)
    }
}
