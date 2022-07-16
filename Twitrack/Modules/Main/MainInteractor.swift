//
//  MainInteractor.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//  
//

import Foundation
import TwitterStreamService

class MainInteractor: PresenterToInteractorMainProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterMainProtocol?

    var dataManager: DataManager
    var networkService: NetworkService
    var imageService: TwitterImageService
    var decoder: JSONDecoder

    var lock = DispatchSemaphore(value: 1)
    var removalTimer: Timer?

    var firstTweetReceived: Bool = false

    init(dataManager: DataManager = .shared, networkService: NetworkService = .init(), imageService: TwitterImageService = .init(), decoder: JSONDecoder = .init()) {
        self.dataManager = dataManager
        self.networkService = networkService
        self.imageService = imageService
        self.decoder = decoder

        self.networkService.delegate = self
        self.networkService.termsToSearch = defaultSearchTerms
        self.networkService.consumerKey = TwitterConstant.APIKey
        self.networkService.consumerSecret = TwitterConstant.APISecretKey
        let cred = AuthHelper.fetchUserToken()
        self.networkService.token = cred?.accessToken?.key ?? .empty
        self.networkService.tokenSecret = cred?.accessToken?.secret ?? .empty
     }

    var tweets: [Tweet] = []
//    var inTweets: [Tweet]?

    func startStreaming() {

        networkService.startStreaming { res in

            switch res {
            case .success(let success):
                pr("started streaming \(success)")
                presenter?.showMessage("Awaiting data...", isExpire: false)
                scheduleRemovalTimer()
                purgeExpiredLocalData()

            case .failure(let error):
                showLocalData()
                presenter?.onError(error: error)
            }
        }
    }

    func stopStreaming() {
        removalTimer?.invalidate()
        networkService.stop()
        save()
    }

    func toggleStreaming() {
        if networkService.isStreaming {
            stopStreaming()
            showLocalData()
        } else {
            startStreaming()
        }
    }

    func save() {
        dataManager.save(tweets)
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

// MARK: Init
extension MainInteractor {

    fileprivate func fetchAndAddImage(_ tweet: Tweet) {
        fetchImage(for: tweet.user) { res in
            switch res {
            case .success(let data):
                self.lock.wait()
                tweet.user.avatarImageData = data
                self.lock.signal()
                self.presenter?.refreshData()

            case .failure(let error):
                pr("error: \(error.localizedDescription)")
//                self.presenter?.onDataFetchFailure(error: error)
            }
        }
    }

    func fetchImage(for user: User, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = user.profileImageUrlHttps else {
            completion(.failure(LocalError.badURL(url: user.profileImageUrlHttps)))
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

        removalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in

            let _5SecondsAgo = Date().addingTimeInterval(-tweetExpiryPeriod)

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
        if !firstTweetReceived {
            firstTweetReceived = true
            showMessage("")
        }
        if tweet.user.avatarImageData == nil {
            self.fetchAndAddImage(tweet)
        }
        lock.wait()
        tweets.insert(tweet, at: 0)
        lock.signal()
        presenter?.refreshData()
    }

    func networkDisconnected() {
        presenter?.showMessage(LocalError.networkDisconnected.localizedDescription, isExpire: true)
        showLocalData()
    }

    func showError(_ error: Error) {
        switch error {
        case LocalError.jsonError(let msg):
            showMessage(msg)

        default:
            if error.localizedDescription == "cancelled" {
                showMessage(error.localizedDescription)
                firstTweetReceived = false
            } else {
                presenter?.onError(error: error)
            }
        }

        if !networkService.isStreaming {
            removalTimer?.invalidate()
            showLocalData()
        }
    }

    func showMessage(_ message: String) {
        presenter?.showMessage(message, isExpire: true)
    }

    func newData(_ data: Data) {
        do {
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tweet = try self.decoder.decode(Tweet.self, from: data)
            tweet.timeReceived = Date()
            newTweet(tweet)

        } catch DecodingError.keyNotFound(let key, let context) {
            let msg = "could not find key \(key) in JSON: \(context.debugDescription)"
            showMessage(LocalError.jsonError(message: msg).localizedDescription)

        } catch DecodingError.valueNotFound(let type, let context) {
            let msg = "could not find type \(type) in JSON: \(context.debugDescription)"
            showMessage(LocalError.jsonError(message: msg).localizedDescription)
        } catch DecodingError.typeMismatch(let type, let context) {
            let msg = "type mismatch for type \(type) in JSON: \(context.debugDescription)"
            showMessage(LocalError.jsonError(message: msg).localizedDescription)
        } catch DecodingError.dataCorrupted(let context) {
            let msg = "data found to be corrupted in JSON: \(context.debugDescription)"
            showMessage(LocalError.jsonError(message: msg).localizedDescription)
        } catch let error as NSError {
            let msg = "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)"
            showMessage(LocalError.jsonError(message: msg).localizedDescription)
        } catch {
            print("error: \(error.localizedDescription)")
            showError(error)
        }
    }
}

// MARK: CoreData
extension MainInteractor {

    func showLocalData() {
        guard let tweetsDB = dataManager.tweets(), !tweetsDB.isEmpty else { return }
        self.tweets = tweetsDB.tweets()
        presenter?.refreshData()
        showMessage("Showing local data")
    }

    func purgeExpiredLocalData() {
        guard let tweetsDB = dataManager.tweets(), !tweetsDB.isEmpty else { return }
        dataManager.purgeExpired(before: Date().addingTimeInterval(-tweetExpiryPeriod))
    }
}

extension Array where Element : TweetDB {
    func tweets() -> [Tweet] {
        guard !self.isEmpty else { return [] }
        var newTweets = [Tweet]()
        for tweetDB in self {
            newTweets.append(Tweet(tweetDB))
        }
        return newTweets
    }
}
