//
//  Geohasher+Location.swift
//  Ember
//
//  Created by Sam Spencer on 3/25/21.
//

import Foundation
import CoreLocation


// MARK: - CLLocationCoordinate2D

public extension CLLocationCoordinate2D {
    
    init(geohash: String) {
        if let (lat, lon) = Geohasher.decode(hash: geohash) {
            self = CLLocationCoordinate2DMake((lat.min + lat.max) / 2, (lon.min + lon.max) / 2)
        } else {
            self = kCLLocationCoordinate2DInvalid
        }
    }
    
    func geohash(length: Int) -> String {
        return Geohasher.encode(latitude: latitude, longitude: longitude, length: length)
    }
    
    func geohash(precision: Geohasher.Precision) -> String {
        return geohash(length: precision.rawValue)
    }
    
}
