//
//  DetailsRouter.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 11/08/2021.
//  
//

import Foundation
import UIKit

class DetailsRouter: PresenterToRouterDetailsProtocol {

    // MARK: Static methods
    static func createModule(for tweet: Tweet) -> UIViewController {

        let viewController = DetailsViewController()

        let presenter: ViewToPresenterDetailsProtocol & InteractorToPresenterDetailsProtocol = DetailsPresenter()

        viewController.presenter = presenter
        viewController.presenter?.router = DetailsRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = DetailsInteractor()
        viewController.presenter?.interactor?.tweet = tweet
        viewController.presenter?.interactor?.presenter = presenter

        return viewController
    }

    static func createModule2(for tweet: Tweet) -> UINavigationController {
        let vc = createModule(for: tweet)
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }

}
