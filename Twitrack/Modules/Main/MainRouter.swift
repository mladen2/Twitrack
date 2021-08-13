//
//  MainRouter.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//  
//

import Foundation
import UIKit
import TwitterStreamService

class MainRouter: PresenterToRouterMainProtocol {

    // MARK: Static methods
    static func createModule() -> UINavigationController {

        let viewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        let presenter: ViewToPresenterMainProtocol & InteractorToPresenterMainProtocol = MainPresenter()

        viewController.presenter = presenter
        viewController.presenter?.router = MainRouter()
        viewController.presenter?.view = viewController

        var interactor: PresenterToInteractorMainProtocol & NetworkDelegate = MainInteractor()

        viewController.presenter?.interactor = interactor
        interactor.presenter = presenter

        return navigationController
    }

    func pushToDetails(on view: PresenterToViewMainProtocol, with tweet: Tweet) {
        let viewController = view as! MainViewController
        let detailViewController = DetailsRouter.createModule(for: tweet)
//        viewController.navigationController?.present(detailNavigationController, animated: true)
        viewController.navigationController?.pushViewController(detailViewController, animated: true)
    }

}
