//
//  UIImageView+Boilerplate.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 12/08/2021.
//

import UIKit


extension UIImageView {

    static func imageView(with systemName: String? = nil) -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        if let name = systemName,
           let image = UIImage(systemName: name)?.withTintColor(UIColor.label, renderingMode: .alwaysOriginal) {
            iv.image = image
        }
        return iv
    }
}
