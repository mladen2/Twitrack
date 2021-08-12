//
//  DetailsInteractor.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 11/08/2021.
//  
//

import Foundation

class DetailsInteractor: PresenterToInteractorDetailsProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterDetailsProtocol?

    var tweet: Tweet?
    var isShowingMore: Bool = false

    func fetchDetails() {
        presenter?.onDetailsFetched(for: tweet ?? Tweet.test)
    }

    func showMoreDetails() {
        presenter?.onShowMore(for: tweet ?? Tweet.test)
    }
}
