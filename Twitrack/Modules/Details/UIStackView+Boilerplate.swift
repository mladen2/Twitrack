//
//  UIStackView+Boilerplate.swift
//  ExploratoryProject1
//
//  Created by Mladen Nisevic on 11/08/2021.
//

import UIKit

extension UIStackView {
    static func stack(_ spacing: CGFloat = 12) -> UIStackView {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = spacing
        stack.axis = .horizontal
        return stack
    }
}
