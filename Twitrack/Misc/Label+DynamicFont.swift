//
//  LabelDynamicFont.swift
//  Trials2
//
//  Created by Scoop Apps on 21/07/2021.
//

import UIKit

extension UILabel {

    static func label(_ textStyle: UIFont.TextStyle = .body,
                      adjustsFont: Bool = true,
                      text: String = "Label",
                      textColour: UIColor = UIColor.label) -> UILabel {

        let label = UILabel()
        label.text = text
        label.textColor = textColour
        label.font = .preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = adjustsFont
        return label

    }
}
