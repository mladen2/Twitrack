//
//  Date+TwitterFormat.swift
//  ExploratoryProject1
//
//  Created by Mladen Nisevic on 09/08/2021.
//

import Foundation

let twitterDateFormat = "EEE MMM dd HH:mm:ssZ yyyy"

extension Date {

    init?(_ string: String) {

        let fmt = DateFormatter()
        // "Wed Oct 10 20:19:24 +0000 2018",
        fmt.dateFormat = twitterDateFormat
        if let dt = fmt.date(from: string) {
            self = dt
        } else {
            return nil
        }
    }

    var stringValue: String {
        let fmt = DateFormatter()
        fmt.dateFormat = twitterDateFormat
        return fmt.string(from: self)
    }
}
