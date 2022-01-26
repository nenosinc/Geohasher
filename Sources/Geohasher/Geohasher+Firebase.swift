//
//  Geohasher+Firebase.swift
//  
//
//  Created by Sam Spencer on 8/25/21.
//

import Foundation
import Firebase
import CoreLocation

extension Geohasher {
    
    /// Encode a `GeoPoint` to a Geohash
    ///
    /// - parameter geopoint: The Firebase GeoPoint.
    /// - parameter precision: The desired hash precision.
    ///
    public static func encode(geopoint: GeoPoint, precision: Precision = .twoMeters) -> String {
        return Geohasher.encode(latitude: geopoint.latitude, longitude: geopoint.longitude, length: precision.rawValue)
    }
    
}

// MARK: - GeoPoint

public extension GeoPoint {
    
    class func new(from geohash: String) -> GeoPoint {
        if let (lat, lon) = Geohasher.decode(hash: geohash) {
            let coordinate = CLLocationCoordinate2DMake((lat.min + lat.max) / 2, (lon.min + lon.max) / 2)
            return GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        } else {
            return GeoPoint(latitude: 0, longitude: 0)
        }
    }
    
    func geohash(length: Int) -> String {
        return Geohasher.encode(latitude: latitude, longitude: longitude, length: length)
    }
    
    func geohash(precision: Geohasher.Precision) -> String {
        return geohash(length: precision.rawValue)
    }
    
}
