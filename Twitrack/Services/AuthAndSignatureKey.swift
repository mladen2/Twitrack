//
//  AuthAndSignature.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import Foundation


struct AuthAndSignatureKey {

    // Signature only
    static let oauthConsumerSecret = "oauth_consumer_secret"
    static let oauthTokenSecret = "oauth_token_secret"

    // Auth Only
    static let oauthSignature = "oauth_signature"

    // common
    static let oauthConsumerKey = "oauth_consumer_key"
    static let oauthNonce = "oauth_nonce"
    static let oauthSignatureMethod = "oauth_signature_method"
    static let oauthTimestamp = "oauth_timestamp"
    static let oauthToken = "oauth_token"
    static let oauthVersion = "oauth_version"

    // additional, or not always present, there are many more, not sure what to do with it
    static let status = "status"
    static let includeEntities = "include_entities"

    static let signatureValues = [oauthConsumerKey, oauthNonce, oauthSignatureMethod, oauthTimestamp, oauthToken, oauthVersion]
    static let signatureKeyValues = [oauthConsumerSecret, oauthTokenSecret]
    static let authorizationValues = [oauthConsumerKey, oauthNonce, oauthSignature, oauthSignatureMethod, oauthTimestamp, oauthToken, oauthVersion]
}
