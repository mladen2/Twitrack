//
//  Authorization.swift
//  ExploratoryProject1
//
//  Created by Mladen Nisevic on 09/08/2021.
//

import Foundation

class Authorization {

    static func getAuthorizationString(_ dict: [String: String]) -> String {

        var str = URLRequestConstants.oAuth

        for key in AuthAndSignatureKey.authorizationValues {
            str += key.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            str += URLRequestConstants.paramDelimiter
            str += URLRequestConstants.quote
            str += (dict[key] ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            str += URLRequestConstants.quote
            if key != AuthAndSignatureKey.authorizationValues.last {
                str += URLRequestConstants.pairDelimiter
            }
        }
        return str
    }
}
