# Geohasher

A lovely, simple little Swift package to encode and decode geohashes for location-based queries.

## What is a Geohash?
Generally speaking, the world is mapped using coordinates which identify can identify a specific point on the globe. Coordinates are just sets of numbers with varying levels of precision. Due to the nature of coordinates, it can be difficult to perform quick and efficient string matching queries, evaluate distance, or simply compare multiple locations.

**Enter Geohashes**

A geohash is an alphanumeric string with a minimum of 1 character and a maximum of 11 characters. 

The length of the geohash string directly corresponds to its accuracy. For instance, a geohash of `ab1` may specify the entirety of New York City. But, a similar geohash with additional characters appended, such as `ab12345` may specify the Empire State Building.

A geohash can be decoded *back* into its original coordinates to display information on a map. Or a coordinate can be encoded as a geohash for storage or evaluation.

The beauty of this whole system is that you only need to perform evaluations on a single data point, rather complex (and sometimes expensive) set comparisons. It's way easier to compare `abc123` to `def456` than it is to compare `35.1234567, -60.7654321` to `15.1234567, -70.7654321`.

## Overview
This Swift Package is a lightweight solution that makes encoding and decoding geohashes blissfully easy.

There are three ways you can go about using this package:

 1. Just add the `Geohash` package as a dependency on your project running Swift 5.3, iOS 13.0, or macOS 11.0 or later.
 2. Use the `Geohash Slim`  target as a dependency **instead** if you don't need any of the Google Firebase helpers.
 3. Or, there's a handy dandy shell script bundled in this repo. Go ahead -- download it and plug it into a project, automation, whatever your heart desires!

## The Code
Encoding a hash from coordinates is amazingly simple:

```swift
let newHash = Geohasher.encode(latitude: 10.0000, longitude: -50.00000, length: 5)
```

Decoding a hash is even simpler:

```swift
let coordinateTuple = Geohasher.decode(hash: "hA5h")
```

There's also some handy helper functions on `CLLocationCoodinate2D`:

```swift
let yourCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(geohash: "hA5h")
let hashFromCoordinate = yourCoordinate.geohash(length: 4)
```

Additionally, the `Geohasher.Precision` enum provides type-safe mappings (and inline documentation!) for the available hash lengths.