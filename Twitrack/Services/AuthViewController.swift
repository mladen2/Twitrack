//
//  AuthViewController.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import UIKit
import AuthenticationServices

final class AuthViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? ASPresentationAnchor()
    }
    static func instance() -> AuthViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: String(describing: Self.self))
    }
}
