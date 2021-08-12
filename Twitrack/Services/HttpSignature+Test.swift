//
//  Signature+Test.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import Foundation

struct TwitterSampleString {
    static let param = "include_entities=true&oauth_consumer_key=xvz1evFS4wEEPTGEFPHBog&oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1318622958&oauth_token=370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb&oauth_version=1.0&status=Hello%20Ladies%20%2B%20Gentlemen%2C%20a%20signed%20OAuth%20request%21"
    static let consumerSecret = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
    static let oathTokenSecret = "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"
    static let key = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"
    static let baseString = "POST&https%3A%2F%2Fapi.twitter.com%2F1.1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521"
}

extension HttpSignature {

    // build params
    func createSampleParamsDict() -> [String: String] {

        let dict = [
            "status": "Hello Ladies + Gentlemen, a signed OAuth request!",
            "include_entities": "true",
            "oauth_consumer_key": "xvz1evFS4wEEPTGEFPHBog",
            "oauth_nonce": "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": "1318622958",
            "oauth_token": "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
            "oauth_version": "1.0"
        ]
        return dict
    }

    static func test() {

        let sig = HttpSignature(method: .POST, baseURL: "https://api.twitter.com/1.1/statuses/update.json", twitterAuthSigParams: TwitterAuthSignature.twitterExample)

        //        let sampleDict = sig.createSampleParamsDict()

        //        let paramString = sig.buildParamsString(sampleDict)
        let paramString = sig.buildParamsString()
        pr("paramString: \(paramString)")
        //let baseString = buildBaseString(sampleParamString)
        let baseString = sig.buildBaseString(paramString)
        pr("baseString: \(baseString)")
        let theKey = sig.buildTheKey(consumerSecret: sig.twitterAuthSigParams.oauthConsumerSecret ?? "", oathTokenSecret: sig.twitterAuthSigParams.oauthTokenSecret ?? "")
        pr("theKey: \(theKey)")
        //let hmac = signSha1Hmac(key: sampleKey, baseString: sampleBaseString)
        //let hmac = signSha1Hmac(key: theKey, baseString: sampleBaseString)
        let hmac = sig.signSha1Hmac(key: theKey, baseString: baseString)

        pr("target: hCtSmYh+iHYCEqBWrE7C7hYmtUk=")
        pr("  hmac: \(hmac)")
        let hmacOK = hmac == "hCtSmYh+iHYCEqBWrE7C7hYmtUk="
        assert(hmacOK)
        pr("hmac ok? \(hmacOK)")
    }
}
