//
//  TwitterAuthSignature.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import Foundation

struct TwitterAuthSignature {
    var oauthConsumerKey: String
    var oauthConsumerSecret: String?
    var oauthNonce: String
    var oauthSignatureMethod: String
    var oauthSignature: String?
    var oauthTimestamp: String
    var oauthToken: String
    var oauthTokenSecret: String?
    var oauthVersion: String
    var otherParams: [String: String]?
}

extension TwitterAuthSignature {

    func signatureParams() -> [String: String] {
        let params: [String: String] = [
            AuthAndSignatureKey.oauthConsumerKey: oauthConsumerKey,
            AuthAndSignatureKey.oauthNonce: oauthNonce,
            AuthAndSignatureKey.oauthTimestamp: oauthTimestamp,
            AuthAndSignatureKey.oauthSignatureMethod: oauthSignatureMethod,
            AuthAndSignatureKey.oauthToken: oauthToken,
            AuthAndSignatureKey.oauthVersion: oauthVersion
        ]

        return params
    }

    func authorizationParams() -> [String: String] {
        let params: [String: String] = [
            AuthAndSignatureKey.oauthConsumerKey: oauthConsumerKey,
            AuthAndSignatureKey.oauthNonce: oauthNonce,
            AuthAndSignatureKey.oauthTimestamp: oauthTimestamp,
            AuthAndSignatureKey.oauthSignatureMethod: oauthSignatureMethod,
            AuthAndSignatureKey.oauthSignature: oauthSignature ?? "",
            AuthAndSignatureKey.oauthToken: oauthToken,
            AuthAndSignatureKey.oauthVersion: oauthVersion
        ]
        return params
    }
}

extension TwitterAuthSignature {

    static var twitterExample: TwitterAuthSignature {

        let tas = TwitterAuthSignature(oauthConsumerKey: "xvz1evFS4wEEPTGEFPHBog",
                                       oauthConsumerSecret: TwitterSampleString.consumerSecret,
                                       oauthNonce: "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
                                       oauthSignatureMethod: URLRequestConstants.method,
                                       oauthTimestamp: "1318622958",
                                       oauthToken: "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
                                       oauthTokenSecret: TwitterSampleString.oathTokenSecret,
                                       oauthVersion: URLRequestConstants.version,
                                       otherParams: ["status": "Hello Ladies + Gentlemen, a signed OAuth request!",
                                                     "include_entities": "true"]
                                       )

        return tas
    }
}
