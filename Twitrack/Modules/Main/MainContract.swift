//
//  MainContract.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//  
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewMainProtocol {

    var tableView: UITableView { get set }

    func onDataRefresh()
    func onError(error: String)
    func showMessage(_ string: String)

    func toggleStreaming()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterMainProtocol {

    var view: PresenterToViewMainProtocol? { get set }
    var interactor: PresenterToInteractorMainProtocol? { get set }
    var router: PresenterToRouterMainProtocol? { get set }

//    var tweets: [Tweet]? { get set }

    func viewDidLoad()
    func toggleStreaming()

    func didSelect(_ row: Int)

    // tweet parts
    func hasTweet(for row: Int) -> Bool
    func name(for row: Int) -> String
    func screenName(for row: Int) -> String
    func avatar(for row: Int) -> UIImage
    func status(for row: Int) -> NSAttributedString
    func timeCreated(for row: Int) -> String
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMainProtocol {

    var presenter: InteractorToPresenterMainProtocol? { get set }
    var dataManager: DataManager { get set }
    var networkService: NetworkService { get set }

    var tweets: [Tweet] { get set }
//    var inTweets: [Tweet]? { get set }

    func startStreaming()
    func stopStreaming()
    func toggleStreaming()
    func save()

    func hasTweet(for row: Int) -> Bool
    func tweet(for row: Int) -> Tweet?
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterMainProtocol {
    func refreshData()
    func onError(error: Error)
    func showMessage(_ message: String, isExpire: Bool)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterMainProtocol {

    static func createModule() -> UINavigationController
    func pushToDetails(on view: PresenterToViewMainProtocol, with tweet: Tweet)

}

protocol NetworkDelegate {
    func newTweet(_ tweet: Tweet)
    func showError(_ error: Error)
    func showMessage(_ message: String)
    func networkDisconnected()
}
