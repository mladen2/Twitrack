//
//  LocalError.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import Foundation


public enum LocalError: Error {
    case badURL(String?)
    case badCallbackURL(String)
    case networkDisconnected
    case jsonError(String)
    case serverErrorReceived
    case cannotConvertUTF8ToData
    case cannotConvertStringToURL
    case completionHandlerMustBeSetBeforeCallingPost
}
