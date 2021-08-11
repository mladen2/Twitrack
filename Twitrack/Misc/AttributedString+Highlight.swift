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

    func highlight4(words: [String]) -> NSAttributedString {
//        let regex = try! NSRegularExpression(pattern: "(\\b[mM][Ee]\\b|\\bI\\b)", options: [.useUnicodeWordBoundaries])
        print("words: \(words)")
        let attributedText = NSMutableAttributedString(string: self)
        guard !words.isEmpty else { return attributedText }
        let regexPattern = RegexHelper.createRegexPattern(from: words)
        print("regexPattern: \(regexPattern)")

        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: [.useUnicodeWordBoundaries, .caseInsensitive])
            var ranges = [NSRange]()
            let stringRange = NSRange(location: 0, length: self.utf16.count)
            regex.enumerateMatches(in: self, options: [], range: stringRange) { match, _, stop in
                guard let match = match else { return }
                ranges.append(match.range)
            }

            for range in ranges {
                attributedText.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range)
                attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: range)
            }

            return attributedText
        } catch {
            print("error: \(error.localizedDescription)")
            return attributedText
        }
    }
}
