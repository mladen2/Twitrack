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
    
    func viewDidLoad() {
        pr()
        SwifterAuthHelper().initSwifter(on: AuthViewController.instance()) { res in

            switch res {
            case .success(_):
                self.interactor?.startStreaming()

            case .failure(let error):
                self.view?.onError(error: error.localizedDescription)
            }
        }
    }

    func stopStreaming() {
        interactor?.stopStreaming()
    }
    
    func didSelect(_ row: Int) {
        
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
        "cr: \(interactor?.tweet(for: row)?.createdAtDate?.timeAgoDisplay() ?? ""), rec: \(interactor?.tweet(for: row)?.timeReceived?.timeAgoDisplay() ?? ""  )"
    }
}

extension MainPresenter: InteractorToPresenterMainProtocol {
    
    func refreshData() {
        view?.onDataRefresh()
    }
    
    func onError(error: Error) {
        view?.onError(error: error.localizedDescription)
    }
    
    
}
