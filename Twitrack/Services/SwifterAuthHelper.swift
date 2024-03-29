//
//  SwifterAuthHelper.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import UIKit
import Swifter
import AuthenticationServices
import TwitterStreamService

final class SwifterAuthHelper {

    var swifter2: Swifter?

    func initSwifter(on viewController: ASWebAuthenticationPresentationContextProviding, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let cred = AuthHelper.fetchUserToken(),
           let key = cred.accessToken?.key,
           let secret = cred.accessToken?.secret {

            swifter2 = Swifter(consumerKey: TwitterConstant.APIKey, consumerSecret: TwitterConstant.APISecretKey, oauthToken: key, oauthTokenSecret: secret)
            completion(.success(true))

        } else {

            swifter2 = Swifter(consumerKey: TwitterConstant.APIKey, consumerSecret: TwitterConstant.APISecretKey)

            guard let callbackUrl = URL(string: urlCallback) else {
                completion(.failure(LocalError.badCallbackURL(url: urlCallback)))
                return
            }

            swifter2?.authorize(withProvider: viewController, callbackURL: callbackUrl) { credential, _ in
                if let cred = credential {
                    AuthHelper.saveUserToken(cred)
                }
                completion(.success(true))

            } failure: { error in
                pr("Error \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
