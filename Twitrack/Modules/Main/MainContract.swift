//
//  MainContract.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//  
//

import UIKit

// TODO: remove me
struct Tweet {}
class DataManager {
    static let shared = DataManager()
}
struct NetworkService {}


// MARK: View Output (Presenter -> View)
protocol PresenterToViewMainProtocol {

    var tableView: UITableView { get set }

    func onDataRefresh()
    func onError(error: String)

}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterMainProtocol {
    
    var view: PresenterToViewMainProtocol? { get set }
    var interactor: PresenterToInteractorMainProtocol? { get set }
    var router: PresenterToRouterMainProtocol? { get set }

    var tweets: [Tweet]? { get set }

    func viewDidLoad()
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

    var tweets: [Tweet]? { get set }
    var inTweets: [Tweet]? { get set }

    func startStreaming()
    func save()
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterMainProtocol {
    func refreshData()
    func onError(error: Error)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterMainProtocol {

    static func createModule() -> UINavigationController
    func pushToDetails(for tweet: Tweet)
    
}

protocol NetworkDelegate {
    func newTweet(_ tweet: Tweet)
    func networkDisconnected()
    func networkError(_ error: Error)
}
