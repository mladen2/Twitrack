//
//  AttributedString+Highlight.swift
//  TestViews
//
//  Created by Mladen Nisevic on 03/08/2021.
//

import UIKit

extension String {

    func highlight(words: [String]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        let searchTerm = words.first ?? ""
        let range = attributedText.mutableString.range(of: searchTerm, options: .caseInsensitive)
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: range)
        return attributedText
    }

    func highlight2(words: [String]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)

        for searchTerm in words {
            let range = attributedText.mutableString.range(of: searchTerm, options: .caseInsensitive)
            attributedText.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: range)
        }
        return attributedText
    }

    /// Whole words only
    func highlight3(words: [String]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)

        for searchTerm in words {
            // it would need to be a regular expression, with
            let range = attributedText.mutableString.range(of: "\\s\(searchTerm)\\s", options: .regularExpression)
            attributedText.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: range)
        }
        return attributedText
    }
}

//extension NSAttributedString {
//
//    func highlight(_ words: [String]) -> NSAttributedString {
//
//
//
//
//
//
//
//    }
//
//
//
//
//
//}
//
//}

//extension NSAttributedString {
//
//    func highlight(searchedText: String?..., color: UIColor = .red) {
//        guard let txtLabel = self.text else { return }
//
//        let attributeTxt = NSMutableAttributedString(string: txtLabel)
//
//        searchedText.forEach {
//            if let searchedText = $0?.lowercased() {
//                let range: NSRange = attributeTxt.mutableString.range(of: searchedText, options: .caseInsensitive)
//
//                attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
//                attributeTxt.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: self.font.pointSize), range: range)
//            }
//        }
//
//        self.attributedText = attributeTxt
//    }

//}
