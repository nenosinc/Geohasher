//
//  Geohasher+Location.swift
//  Ember
//
//  Created by Sam Spencer on 3/25/21.
//

import Foundation
import Firebase
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
