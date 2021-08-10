//
//  MainInteractor.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//  
//

import Foundation

class MainInteractor: PresenterToInteractorMainProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterMainProtocol?

    var dataManager: DataManager
    var networkService: NetworkService

    init(dataManager: DataManager = .shared, networkService: NetworkService = .init()) {
        self.dataManager = dataManager
        self.networkService = networkService
    }

    var tweets: [Tweet]?
    var inTweets: [Tweet]?

    func startStreaming() {

    }

    func save() {

    }


}

extension MainInteractor: NetworkDelegate {

    func newTweet(_ tweet: Tweet) {

    }

    func networkDisconnected() {

    }

    func networkError(_ error: Error) {

    }
}
