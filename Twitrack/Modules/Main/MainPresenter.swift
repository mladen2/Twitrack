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
        interactor?.startStreaming()
    }
    
    func didSelect(_ row: Int) {
        
    }
    
}

// tweet fields
extension MainPresenter {
    
    func hasTweet(for row: Int) -> Bool {
        true
    }
    
    func name(for row: Int) -> String {
        ""
    }
    
    func screenName(for row: Int) -> String {
        ""
    }
    
    func avatar(for row: Int) -> UIImage {
        UIImage()
    }
    
    func status(for row: Int) -> NSAttributedString {
        NSAttributedString()
    }
    
    func timeCreated(for row: Int) -> String {
        ""
    }
}

extension MainPresenter: InteractorToPresenterMainProtocol {
    
    func refreshData() {
        
    }
    
    func onError(error: Error) {
        
    }
    
    
}
