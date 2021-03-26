//
//  Geohasher.swift
//  Ember
//
//  Created by Sam Spencer on 3/25/21.
//

import Foundation
import Firebase

public struct Geohasher {
    
    /// Decode a given Geohash stored in Firestore
    ///
    /// - parameter hash: The encoded geohash string.
    ///
    public static func decode(hash: String) -> (latitude: (min: Double, max: Double), longitude: (min: Double, max: Double))? {
        // For example: hash = u4pruydqqvj
        let bits = hash.map { bitmap[$0] ?? "?" }.joined(separator: "")
        guard bits.count % 5 == 0 else { return nil }
        // bits = 1101000100101011011111010111100110010110101101101110001
        let (lat, lon) = bits.enumerated().reduce(into: ([Character](), [Character]())) {
            if $1.0 % 2 == 0 {
                $0.1.append($1.1)
            } else {
                $0.0.append($1.1)
            }
        }
        // lat = [1,1,0,1,0,0,0,1,1,1,1,1,1,1,0,1,0,1,1,0,0,1,1,0,1,0,0]
        // lon = [1,0,0,0,0,1,1,1,0,1,1,0,0,1,1,0,1,0,0,1,1,1,0,1,1,1,0,1]
        func combiner(array a: (min: Double, max: Double), value: Character) -> (Double, Double) {
            let mean = (a.min + a.max) / 2
            return value == "1" ? (mean, a.max) : (a.min, mean)
        }
        
        let latRange = lat.reduce((-90.0, 90.0), combiner)
        // latRange = (57.649109959602356, 57.649111300706863)
        let lonRange = lon.reduce((-180.0, 180.0), combiner)
        // lonRange = (10.407439023256302, 10.407440364360809)
        return (latRange, lonRange)
    }
    
    /// Encode a `GeoPoint` to a Geohash
    ///
    /// - parameter geopoint: The Firebase GeoPoint.
    /// - parameter precision: The desired hash precision.
    ///
    public static func encode(geopoint: GeoPoint, precision: Precision = .twoMeters) -> String {
        return Geohasher.encode(latitude: geopoint.latitude, longitude: geopoint.longitude, length: precision.rawValue)
    }
    
    /// Encode a coordinate set to a Geohash
    ///
    /// - parameter latitude: The latitude of the location.
    /// - parameter longitude: The longitude of the location.
    /// - parameter length: The target length of the geohash.
    ///
    public static func encode(latitude: Double, longitude: Double, length: Int) -> String {
        // For example: (latitude, longitude) = (57.6491106301546, 10.4074396938086)
        func combiner(array a: (min: Double, max: Double, array: [String]), value: Double) -> (Double, Double, [String]) {
            let mean = (a.min + a.max) / 2
            if value < mean {
                return (a.min, mean, a.array + "0")
            } else {
                return (mean, a.max, a.array + "1")
            }
        }
        
        let lat = Array(repeating: latitude, count: length * 5).reduce((-90.0, 90.0, [String]()), combiner)
        // lat = (57.64911063015461, 57.649110630154766, [1,1,0,1,0,0,0,1,1,1,1,1,1,1,0,1,0,1,1,0,0,1,1,0,1,0,0,1,0,0,...])
        let lon = Array(repeating: longitude, count: length * 5).reduce((-180.0, 180.0, [String]()), combiner)
        // lon = (10.407439693808236, 10.407439693808556, [1,0,0,0,0,1,1,1,0,1,1,0,0,1,1,0,1,0,0,1,1,1,0,1,1,1,0,1,0,1,..])
        let latlon = lon.2.enumerated().flatMap { [$1, lat.2[$0]] }
        // latlon - [1,1,0,1,0,0,0,1,0,0,1,0,1,0,1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,...]
        let bits = latlon.enumerated().reduce([String]()) { $1.0 % 5 > 0 ? $0 << $1.1 : $0 + $1.1 }
        //  bits: [11010,00100,10101,10111,11010,11110,01100,10110,10110,11011,10001,10010,10101,...]
        let arr = bits.compactMap { charmap[$0] }
        // arr: [u,4,p,r,u,y,d,q,q,v,j,k,p,b,...]
        return String(arr.prefix(length))
    }
    
    // MARK: Private
    private static let bitmap = "0123456789bcdefghjkmnpqrstuvwxyz".enumerated()
        .map {
            ($1, String(integer: $0, radix: 2, padding: 5))
        }
        .reduce(into: [Character: String]()) {
            $0[$1.0] = $1.1
        }
    
    private static let charmap = bitmap
        .reduce(into: [String: Character]()) {
            $0[$1.1] = $1.0
        }
}

private extension String {
    
    /// Synthesize a `String` from Geohash parameters
    init(integer n: Int, radix: Int, padding: Int) {
        let s = String(n, radix: radix)
        let pad = (padding - s.count % padding) % padding
        self = Array(repeating: "0", count: pad).joined(separator: "") + s
    }
    
}

private func + (left: [String], right: String) -> [String] {
    var arr = left
    arr.append(right)
    return arr
}

private func << (left: [String], right: String) -> [String] {
    var arr = left
    var s = arr.popLast()!
    s += right
    arr.append(s)
    return arr
}
