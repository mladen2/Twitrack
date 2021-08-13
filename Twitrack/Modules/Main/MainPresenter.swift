//
//  MainPresenter.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//  
//

import UIKit

class MainPresenter: ViewToPresenterMainProtocol {

    // MARK: Properties
    var view: PresenterToViewMainProtocol?
    var interactor: PresenterToInteractorMainProtocol?
    var router: PresenterToRouterMainProtocol?

    var tweets: [Tweet]?

    var timer: Timer?

    func viewDidLoad() {
        showMessage("Connecting...")
        SwifterAuthHelper().initSwifter(on: AuthViewController.instance()) { res in

            switch res {
            case .success(_):
                self.interactor?.startStreaming()

            case .failure(let error):
                self.view?.onError(error: error.localizedDescription)
            }
        }
    }

    func toggleStreaming() {
        interactor?.toggleStreaming()
    }

    func didSelect(_ row: Int) {
        if let tweet = interactor?.tweets[row] {
            router?.pushToDetails(on: view!, with: tweet)
        }
    }
}

// tweet fields
extension MainPresenter {

    func hasTweet(for row: Int) -> Bool {
        interactor?.hasTweet(for: row) == true
    }

    func name(for row: Int) -> String {
        interactor?.tweet(for: row)?.user.name ?? ""
    }

    func screenName(for row: Int) -> String {
        interactor?.tweet(for: row)?.user.screenName ?? ""
    }

    func avatar(for row: Int) -> UIImage {
        interactor?.tweet(for: row)?.user.avatarImage ?? UIImage()
    }

    func status(for row: Int) -> NSAttributedString {
        interactor?.tweet(for: row)?.textHighlighted ?? NSAttributedString()
    }

    func timeCreated(for row: Int) -> String {

        var locationString = ""
        if let locPoint = interactor?.tweet(for: row)?.geoLocation {
            locationString = "Lon: \(locPoint.longitude.roundedTo2Significant ?? ""), Lat: \(locPoint.lattitude.roundedTo2Significant ?? "")"
        }

        return "\(interactor?.tweet(for: row)?.createdAtDate?.timeAgoDisplay() ?? ""), rcvd: \(interactor?.tweet(for: row)?.timeReceived?.timeAgoDisplay() ?? "") \(locationString)"
    }
}

extension MainPresenter: InteractorToPresenterMainProtocol {

    func refreshData() {
        view?.onDataRefresh()
    }

    func onError(error: Error) {
        showMessage("") // clear message to avoid confusion
        view?.onError(error: error.localizedDescription)
    }

    func showMessage(_ message: String, isExpire: Bool = true) {
        view?.showMessage(message)
        if isExpire {
            startMessageTimer()
        }
    }

}

extension MainPresenter {

    func startMessageTimer() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
            self.view?.showMessage("")
        })
    }
}
