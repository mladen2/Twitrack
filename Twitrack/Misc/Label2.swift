//
//  Label2.swift
//  RedditComments
//
//  Created by Mladen Nisevic on 05/08/2021.
//

import UIKit

class Label2: UIView {

    lazy var textLabel: UILabel = {
        let lab = UILabel.label(.body)
        return lab
    }()

    lazy var titleLabel: UILabel = {
        let lab = UILabel.label(.caption1, textColour: UIColor.secondaryLabel)
        return lab
    }()

    @IBInspectable var aTitle: String? {
        didSet {
            titleLabel.text = aTitle
        }
    }

    @IBInspectable var text: String? {
        didSet {
            textLabel.text = text
        }
    }

    func setupUI() {

        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])

        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        textLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        textLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}
