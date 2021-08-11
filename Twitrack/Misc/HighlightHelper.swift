//
//  HighlightHelper.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 11/08/2021.
//

import UIKit

class HighlightHelper {

    static let highlightColour = UIColor.systemRed
    static let highlightFont = UIFont.boldSystemFont(ofSize: 20)


    static func highlight(in string: String) -> NSAttributedString {
        return highlight(words: defaultSearchTerms, in: string)
    }

    static func highlight(words: [String], in string: String) -> NSAttributedString {

        let attributedText = NSMutableAttributedString(string: string)

        guard let regex = RegexHelper.shared.regex else {
            return attributedText
        }

        var ranges = [NSRange]()
        let stringRange = NSRange(location: 0, length: string.utf16.count)
        regex.enumerateMatches(in: string, options: [], range: stringRange) { match, _, stop in
            guard let match = match else { return }
            ranges.append(match.range)
        }

        for range in ranges {
            attributedText.addAttribute(.foregroundColor, value: highlightColour, range: range)
            attributedText.addAttribute(.font, value: highlightFont, range: range)
        }

        return attributedText
    }
}
