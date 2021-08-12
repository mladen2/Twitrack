//
//  LocationPoint.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 12/08/2021.
//

import Foundation

/**
 Instead of using CGPoint which could be used
 It's clearer when longitude and lattitude are named as such
 */
struct LocationPoint {
    var longitude: Double
    var lattitude: Double

    init(longitude: Double, lattitude: Double) {
        self.longitude = longitude
        self.lattitude = lattitude
    }

    init(_ loc: [Double]) {
        longitude = loc.first ?? 0
        lattitude = loc.last ?? 0
    }
}

/**
 As the place object often carries a 'boundingBox', we can take the centre of that box
 to display an approximate location but using our zoom level
 this simplifies storing of the data
 */

struct LocationRect {
    var southWest: LocationPoint
    var northEast: LocationPoint
    var centre: LocationPoint {
        let longitude = (southWest.longitude + northEast.longitude) / 2
        let lattitude = (southWest.lattitude + northEast.lattitude) / 2
        return LocationPoint(longitude: longitude, lattitude: lattitude)
    }
    init?(_ loc: [LocationPoint]) {
        if let first = loc.first {
            southWest = first
        } else {
            return nil
        }
        if loc.count > 2 {
            northEast = loc[2]
        } else {
            northEast = loc[0]
        }
    }
    init?(_ box: [[Double]]) {
        var locs = [LocationPoint]()
        for loc in box {
            locs.append(LocationPoint(loc))
        }
        self.init(locs)
    }
}
