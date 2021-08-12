//
//  LocalError.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import Foundation

public enum LocalError: Error {
    case badURL(url: String?)
    case badCallbackURL(url: String)
    case networkDisconnected
    case jsonError(message: String) // 3
    case serverErrorReceived
    case urlSessionBecameInvalid
    case urlSessionCompletedWithError // 6
    case cannotConvertUTF8ToData
    case cannotConvertStringToURL
    case completionHandlerMustBeSetBeforeCallingPost
}
