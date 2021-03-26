//
//  Geohasher+Level.swift
//  Ember
//
//  Created by Sam Spencer on 3/25/21.
//

import Foundation

public extension Geohasher {
    
    enum Precision: Int {
        /// ±2500 km
        case twoMegameters = 1
        
        /// ±630 km
        case megameter
        
        /// ±78 km
        case eightyKilometers
        
        /// ±20 km
        case twentyKilometers
        
        /// ±2.4 km
        case twoKilometers
        
        // ±0.61 km
        case sixDecimeters
        
        /// ±0.076 km
        case decimeter
        
        /// ±0.019 km
        case twentyMeters
        
        /// ±0.0024 km
        case twoMeters
        
        /// ±0.00060 km
        case meter
        
        /// ±0.000074 km
        case centimeter
    }
    
    static func encode(latitude: Double, longitude: Double, precision: Precision) -> String {
        return encode(latitude: latitude, longitude: longitude, length: precision.rawValue)
    }
    
}
