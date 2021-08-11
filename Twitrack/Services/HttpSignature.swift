//
//  Signature.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import Foundation


class HttpSignature {

    var httpMethod: HTTPMethod = .POST
    var baseURL = "https://api.twitter.com/1.1/statuses/update.json"

    var twitterAuthSigParams: TwitterAuthSignature

    init(method: HTTPMethod, baseURL: String, twitterAuthSigParams: TwitterAuthSignature) {
        self.httpMethod = method
        self.baseURL = baseURL
        self.twitterAuthSigParams = twitterAuthSigParams
    }

    func buildParamsString() -> String {
        // colect raw values of request params and all oauth_ params
        var params = twitterAuthSigParams.signatureParams()
        if let otherParams = twitterAuthSigParams.otherParams {
            params = params.merging(otherParams) { $1 }
        }

        pr("params: \(params)")
        let encodedDict = percentEncodeKeysValues(params)
    //    pr("encodedDict: \(encodedDict)")
        let str = composeParamsString(encodedDict)
    //    pr("str: \(str)")
//        let paramStringOK = str == TwitterSampleString.param
//        assert(paramStringOK)
//        pr("param str ok? \(paramStringOK)")
        return str
    }

    func percentEncodeKeysValues(_ params: [String: String]) -> [String: String] {
        let paramKeys = Array(params.keys)
        var encodedDict = [String: String]()
        for param in paramKeys {
            let newKey = param.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowedFull) ?? ""
            encodedDict[newKey] = params[param]?.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowedFull) ?? ""
        }
        return encodedDict
    }

    func composeParamsString(_ encodedParams: [String: String]) -> String {
        let encodedKeys = Array(encodedParams.keys).sorted()
        pr("encodedKeys, sorted: \(encodedKeys)")

        var str = ""
        var count = 0
        for key in encodedKeys {
            str += key
            str += URLRequestConstants.paramDelimiter
            str += encodedParams[key] ?? ""
            if count < (encodedKeys.count - 1 ) {
                str += URLRequestConstants.urlParamDelimiter
            }
            count += 1
        }
        return str
    }

    // build the string
    func buildBaseString(_ paramString: String) -> String {
        var str = ""
        // method, base URL, param string
    //    str += dict[AuthAndSignatureKey.oauthVersion]?.uppercased() ?? ""
        str += httpMethod.rawValue.uppercased()
        str += URLRequestConstants.urlParamDelimiter
        str += baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowedFull) ?? ""
        str += URLRequestConstants.urlParamDelimiter
        str += paramString.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowedFull) ?? ""
//        let baseStrOK = str == TwitterSampleString.baseString
//        assert(baseStrOK)
//        pr("baseString ok? \(baseStrOK)")
        return str
    }

    // Consumer secret    kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw
    let sampleConsumerSecret = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
    // OAuth token secret    LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE
    let sampleOathTokenSecret = "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"

    func buildTheKey(consumerSecret: String, oathTokenSecret: String) -> String {
        pr("consumerSecret: \(consumerSecret), oathTokenSecret: \(oathTokenSecret)")
        var str = ""
        str += consumerSecret.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowedFull) ?? ""
        str += URLRequestConstants.urlParamDelimiter
        str += oathTokenSecret.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowedFull) ?? ""
        return str
    }

    /// <#Description#>
    /// - Returns: Base64-encrypted SHA1_HMAC of the data with the key
    func signSha1Hmac(key: String, baseString: String) -> String {
        let binaryHmac = baseString.digestSha1(key: key.data(using: .utf8))
        let data = Data(bytes: binaryHmac, count: SHA1Algorithm().digestLength)
        let b64 = data.base64EncodedString()
        return b64
    }

    func sha1HmacSig() -> String {
        let paramString = buildParamsString()
        pr("paramString: \(paramString)")
        let baseString = buildBaseString(paramString)
        pr("baseString: \(baseString)")
        let theKey = buildTheKey(consumerSecret: twitterAuthSigParams.oauthConsumerSecret ?? "", oathTokenSecret: twitterAuthSigParams.oauthTokenSecret ?? "")
        pr("theKey: \(theKey)")
        let sig = signSha1Hmac(key: theKey, baseString: baseString)
        pr("sig: \(sig)")
        return sig
    }
}
