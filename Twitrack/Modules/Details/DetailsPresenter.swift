//
//  DetailsPresenter.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 11/08/2021.
//  
//

import Foundation

class DetailsPresenter: ViewToPresenterDetailsProtocol {

    // MARK: Properties
    var view: PresenterToViewDetailsProtocol?
    var interactor: PresenterToInteractorDetailsProtocol?
    var router: PresenterToRouterDetailsProtocol?

    var tweet: Tweet?
    var coordinates: LocationPoint? {
        if let tweet = tweet,
           tweet.hasGeoData,
           let coords = tweet.geoLocation {
            return coords
        }
        return nil
    }

    func viewDidLoad() {
        interactor?.fetchDetails()
    }

    func showMore() {
        interactor?.showMoreDetails()
    }
}

extension DetailsPresenter: InteractorToPresenterDetailsProtocol {

    func onDetailsFetched(for tweet: Tweet) {
        self.tweet = tweet
        view?.onFetchSuccess()
    }

    func onShowMore(for tweet: Tweet) {
        self.tweet = tweet
        view?.onMoreFetched()
    }

    func onDetailsFetchError(error: Error) {

    }

}
