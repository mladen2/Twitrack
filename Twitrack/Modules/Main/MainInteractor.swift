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
    var imageService: TwitterImageService

    var lock = DispatchSemaphore(value: 1)
    var removalTimer: Timer?

    init(dataManager: DataManager = .shared, networkService: NetworkService = .init(), imageService: TwitterImageService = .init()) {
        self.dataManager = dataManager
        self.networkService = networkService
        self.imageService = imageService
        self.networkService.delegate = self
    }

    var tweets: [Tweet] = []
//    var inTweets: [Tweet]?

    func startStreaming() {

        networkService.startStreaming { res in

            switch res {
            case .success(let success):
                pr("started streaming \(success)")


            case .failure(let error):
                presenter?.onError(error: error)
            }
        }
        scheduleRemovalTimer()
    }

    func save() {

    }

    func hasTweet(for row: Int) -> Bool {
        row < tweets.count
    }

    func tweet(for row: Int) -> Tweet? {
        if row < tweets.count {
            return tweets[row]
        }
        return nil
    }
}

// MARK: -
// MARK: Init
// MARK: -
extension MainInteractor {

    fileprivate func fetchAndAddImage(_ tweet: Tweet) {
        pr("tweet: \(String(describing: tweet.fullText))")
        fetchImage(for: tweet.user) { res in
            switch res {

            case .success(let data):
                self.lock.wait()
                tweet.user.avatarImageData = data
//                self.tweets.insert(tweet, at: 0)
                self.lock.signal()
                //            pr("tweets now: \(self.tweets?.count ?? 0)")
                self.presenter?.refreshData()

            case .failure(let error):
                pr("error: \(error.localizedDescription)")
//                self.presenter?.onDataFetchFailure(error: error)
            }
        }
    }

    func fetchImage(for user: User, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = user.profileImageUrlHttps else {
            completion(.failure(LocalError.badURL(user.profileImageUrlHttps)))
            return
        }
        imageService.fetchAvatar(url) { res in
            completion(res)
        }
    }

    fileprivate func scheduleRemovalTimer() {

        if removalTimer != nil {
            removalTimer?.invalidate()
        }

        pr()
        removalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let now = Date()
            let _5SecondsAgo = now.addingTimeInterval(-tweetExpiryPeriod)

            let expiredTweets = self.tweets.filter { tweet in
                if let tr = tweet.timeReceived {
                    return tr < _5SecondsAgo
                }
                // if they don't have timeReceived, we need to remove them, what else to do?!
                return true
            }

            for expired in expiredTweets {

                if let index = self.tweets.firstIndex(of: expired) {
                    self.lock.wait()
                    self.tweets.remove(at: index)
                    self.lock.signal()
                    self.presenter?.refreshData()
                }
            }
        }
    }
}

extension MainInteractor: NetworkDelegate {

    func newTweet(_ tweet: Tweet) {
        if tweet.user.avatarImageData == nil {
            self.fetchAndAddImage(tweet)
        }
        lock.wait()
        tweets.insert(tweet, at: 0)
        lock.signal()
        presenter?.refreshData()
    }

    func networkDisconnected() {
        presenter?.onError(error: LocalError.networkDisconnected)
    }

    func showError(_ error: Error) {
        pr("error: \(error.localizedDescription)")
//        presenter?.onError(error: error)
    }
}
