//
//  DetailsContract.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 11/08/2021.
//  
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewDetailsProtocol {

    func onFetchSuccess()
    func onMoreFetched()
    func onError(error: String)

    func showMore(_ sender: Any)

}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterDetailsProtocol {

    var view: PresenterToViewDetailsProtocol? { get set }
    var interactor: PresenterToInteractorDetailsProtocol? { get set }
    var router: PresenterToRouterDetailsProtocol? { get set }

    var tweet: Tweet? { get set }

    var coordinates: LocationPoint? { get }

    func viewDidLoad()
    func showMore()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorDetailsProtocol {

    var presenter: InteractorToPresenterDetailsProtocol? { get set }

    var tweet: Tweet? { get set }
    var isShowingMore: Bool { get set }

    func fetchDetails()

    func showMoreDetails()

}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterDetailsProtocol {

    func onDetailsFetched(for tweet: Tweet)
    func onShowMore(for tweet: Tweet)
    func onDetailsFetchError(error: Error)

}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterDetailsProtocol {

    static func createModule(for tweet: Tweet) -> UIViewController
    static func createModule2(for tweet: Tweet) -> UINavigationController

}
