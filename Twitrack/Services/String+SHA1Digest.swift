//
//  String+Digest.swift
//  ExploratoryProject1
//
//  Created by Mladen Nisevic on 09/08/2021.
//

import Foundation
import CommonCrypto

struct SHA1Algorithm {
    let hmacAlgorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)
    let digestAlgorithm = CC_SHA1
    let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
}

extension String {

    func digestSha1(key: Data?) -> [UInt8] {

        let alg = SHA1Algorithm()

        let str = Array(self.utf8CString)
        let strLen = str.count-1
        let digestLen = alg.digestLength
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)

        if let key = key {
            key.withUnsafeBytes { body in
                CCHmac(alg.hmacAlgorithm, body.baseAddress, key.count, str, count, result)
            }
        } else {
            _ = alg.digestAlgorithm(str, CC_LONG(strLen), result)
        }

        let a = UnsafeMutableBufferPointer(start: result, count: count)
        let array = Array(a)

        result.deallocate()

        return array
    }
}
