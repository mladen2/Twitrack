//
//  CharacterSet+PercentEncodeRemove.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import Foundation

extension CharacterSet {
    static let urlQueryValueAllowedFull: CharacterSet = {
        let generalDelimitersToEncode = "/:#[]@" // does not include "?" ?? // twitter requires '/' to be encoded
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
