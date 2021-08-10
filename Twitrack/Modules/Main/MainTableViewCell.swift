//
//  MainTableViewCell.swift
//  TestViews
//
//  Created by Mladen Nisevic on 03/08/2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    static var cellID = "MainCell"

    lazy var userNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.label
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    lazy var screenNameLabel: UILabel = {
        var label = UILabel.label(.footnote, textColour: UIColor.secondaryLabel)
        return label
    }()

    lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 10
        return label
    }()

    lazy var infoLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        return label
    }()

    lazy var avatarImageView: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func commonInit() {

        let margin: CGFloat = 8

        addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(screenNameLabel)
        screenNameLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
            avatarImageView.trailingAnchor.constraint(equalTo: userNameLabel.leadingAnchor, constant: -margin),
            avatarImageView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -margin),
            avatarImageView.widthAnchor.constraint(equalToConstant: 44)
        ])

        NSLayoutConstraint.activate([
//            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin),
            userNameLabel.bottomAnchor.constraint(equalTo: screenNameLabel.topAnchor, constant: -margin)
        ])

        NSLayoutConstraint.activate([
//            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            screenNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: margin/2),
            screenNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: margin),
            screenNameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -margin)
        ])

        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
            statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin)
        ])

        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin),
            infoLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: margin),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin)
        ])

        statusLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        //        NSLayoutConstraint.activate([
        //            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        //            avatarImageView.trailingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
        //            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor),
        //            avatarImageView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
        ////            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ////            avatarImageView.widthAnchor.constraint(equalToConstant: 44),
        //        ])
        //
        //        NSLayoutConstraint.activate([
        //            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        //            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
        //            userNameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor)
        //        ])
        //
        //        NSLayoutConstraint.activate([
        //            statusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        //            statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        //            statusLabel.topAnchor.constraint(equalTo: self.topAnchor),
        //            statusLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor)
        //        ])
    }
}
