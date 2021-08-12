//
//  Int+Format.swift
//  ExploratoryProject1
//
//  Created by Mladen Nisevic on 07/08/2021.
//

import Foundation

extension Int {

    // useful for 1,000s separator
    var decimal: String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        return fmt.string(from: NSNumber(value: self)) ?? ""
    }
}
