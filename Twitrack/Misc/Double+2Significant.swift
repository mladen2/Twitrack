//
//  File.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 12/08/2021.
//

import Foundation

extension Double {
    var roundedTo2Significant: String? {
        let nm = NumberFormatter()
        nm.maximumFractionDigits = 2
        nm.maximumSignificantDigits = 2
        nm.usesSignificantDigits = true
        return nm.string(from: NSNumber(value: self))
    }
}
