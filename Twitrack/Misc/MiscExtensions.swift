//
//  MiscExtensions.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 13/08/2021.
//

import UIKit

extension UINavigationController {

    func makeMeClear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear
        self.navigationBar.backgroundColor = UIColor.clear
    }
}

extension UIDeviceOrientation {
    var name: String {
        switch self {
        case .unknown: return "unknown"
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .faceUp: return "faceUp"
        case .faceDown: return "faceDown"
        @unknown default:
            fatalError()
        }
    }
}

extension UIUserInterfaceSizeClass {
    var name: String {
        switch self {
        case .unspecified: return "unspecified"
        case .compact: return "compact"
        case .regular: return "regular"
        @unknown default:
            fatalError()
        }
    }
}

extension UIUserInterfaceIdiom {
    var name: String {
        switch self {
        case .unspecified: return "unspecified"
        case .phone: return "phone"
        case .pad: return "pad"
        case .tv: return "tv"
        case .carPlay: return "carPlay"
        case .mac: return "mac"
        @unknown default:
            fatalError()

        }
    }
}
