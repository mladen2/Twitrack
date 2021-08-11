//
//  RandomSystemImage.swift
//  TestViews
//
//  Created by Mladen Nisevic on 03/08/2021.
//

import UIKit

class RandomSystemImage {

    static let names = [
        "person",
        "person.3",
        "rectangle.and.pencil.and.ellipsis",
        "scribble.variable",
        "highlighter",
        "pencil.tip.crop.circle.badge.arrow.forward",
        "lasso.sparkles",
        "folder.badge.questionmark",
        "folder.fill.badge.questionmark",
        "square.grid.3x1.folder.badge.plus",
        "square.grid.3x1.folder.fill.badge.plus",
        "folder.badge.gear",
        "folder.fill.badge.gear"
    ]

    static var image: UIImage {
        let rando = Int.random(in: 0..<names.count)
        return UIImage(systemName: names[rando]) ?? UIImage()
    }

}
