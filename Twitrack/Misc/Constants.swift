//
//  Constants.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import Foundation


// test
let tweetExpiryPeriod: TimeInterval = 15 // seconds
var defaultSearchTerms = ["I", "me"]

let urlCallback = "twitrack://success"

enum HTTPMethod: String {
    case GET
    case POST
}

struct POSTHeaderValue {
    static let appJson = "application/json; charset=utf-8"
    static let appXForm = "application/x-www-form-urlencoded"
}

struct POSTHeaderKey {
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let accept = "Accept"
    static let close = "Close"
}

struct TwitterConstant {
    static let APIKey = "0CrsDFf4EQ5AheO64AkdLjg91"
    static let APISecretKey = "ZFCovoZt76iLFLTfdNJ91ltAGwcAffsUq4X8osSlYOVJM6PG0a"
    static let bearerToken = "AAAAAAAAAAAAAAAAAAAAAHvGSAEAAAAA3yOrNse4GF3FvkZNoliDW0RF%2BMQ%3DMcCdBcBdLjHuCbuLhv6p3kcWNm0RGoj3vaTnjlviI0TdfshBOS"
}

struct StreamParamName {
    static let track = "track"
    static let follow = "follow"
}


