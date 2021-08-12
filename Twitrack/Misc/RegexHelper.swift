//
//  RegexHelper.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 11/08/2021.
//

import Foundation

struct RegexConstants {
    static let open = "("
    static let wordDelimiter = "\\b"
    static let or = "|"
    static let close = ")"
}

class RegexHelper {

    static let shared = RegexHelper(searchTerms: defaultSearchTerms)

    var searchTerms: [String] {
        didSet {
            regexPatternString = RegexHelper.createRegexPattern(from: searchTerms)
        }
    }
    var regexPatternString: String = ""
    var regex: NSRegularExpression?

    init(searchTerms: [String]) {
        self.searchTerms = searchTerms
        regexPatternString = RegexHelper.createRegexPattern(from: searchTerms)
        do {
            regex = try NSRegularExpression(pattern: regexPatternString, options: [.useUnicodeWordBoundaries, .caseInsensitive])
        } catch {
            pr("error: \(error.localizedDescription)")
        }
    }

    static func createRegexPattern(from searchTerms: [String]) -> String {

        guard !searchTerms.isEmpty else { return "" }

        var regexPattern = RegexConstants.open

        for word in searchTerms {
            regexPattern += RegexConstants.wordDelimiter
            regexPattern += word
            regexPattern += RegexConstants.wordDelimiter
            if word != searchTerms.last {
                regexPattern += RegexConstants.or
            } else {
                regexPattern += RegexConstants.close
            }
        }

        print("regexPattern: \(regexPattern)")
        return regexPattern
    }
}
