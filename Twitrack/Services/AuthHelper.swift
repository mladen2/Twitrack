//
//  File.swift
//  ExploratoryProject1
//
//  Created by Mladen Nisevic on 07/08/2021.
//

import Foundation
import Swifter

enum AuthKey: String {
    case key, secret, screenName, userID, verifier
}

class AuthHelper {

    @discardableResult
    static func saveUserToken(_ data: Credential.OAuthAccessToken) -> Bool {

        let userdata = UserDefaults.standard

        userdata.set(data.key, forKey: AuthKey.key.rawValue)
        userdata.set(data.secret, forKey: AuthKey.secret.rawValue)
        userdata.set(data.screenName, forKey: AuthKey.screenName.rawValue)
        userdata.set(data.userID, forKey: AuthKey.userID.rawValue)
        userdata.set(data.verifier, forKey: AuthKey.verifier.rawValue)
        userdata.synchronize()

        return true
    }

    static func fetchUserToken() -> Credential? {

        let userdata = UserDefaults.standard

        if let tkey = userdata.object(forKey: AuthKey.key.rawValue) as? String {
            if let tsecret = userdata.object(forKey: AuthKey.secret.rawValue) as? String {

                let access = Credential.OAuthAccessToken(key: tkey, secret: tsecret)
                return Credential(accessToken: access)
            }
        }
        return nil
    }

    static func fetchUserQData() -> [String: String] {
        let userdata = UserDefaults.standard
        var data = [String: String]()
        data[AuthKey.screenName.rawValue] = userdata.string(forKey: AuthKey.screenName.rawValue)
        data[AuthKey.userID.rawValue] = userdata.string(forKey: AuthKey.userID.rawValue)
        return data
    }
}
