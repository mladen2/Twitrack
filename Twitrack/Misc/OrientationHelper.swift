//
//  OrientationHelper.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 13/08/2021.
//

import UIKit

class OrientationHelper {

    static var isPortrait: Bool {

        let orientation = UIDevice.current.orientation

        switch orientation {

        case .portrait, .portraitUpsideDown:
            return true

        case .landscapeLeft, .landscapeRight:
            return false

        default: // unknown or faceUp or faceDown // this does not work for compact window on iPad
            guard let window = UIApplication.shared.windows.first else { return false }
            return window.frame.size.width < window.frame.size.height
        }

    }

}
