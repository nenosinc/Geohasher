import XCTest
import CoreLocation
@testable import Geohasher

final class GeohasherTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecode() {
        XCTAssertNil(Geohasher.decode(hash: "garbage"))

        let (lat, lon) = Geohasher.decode(hash: "u4pruydqqvj")!
        XCTAssertTrue(lat.min == 57.649109959602356)
        XCTAssertTrue(lat.max == 57.649111300706863)
        XCTAssertTrue(lon.min == 10.407439023256302)
        XCTAssertTrue(lon.max == 10.407440364360809)
    }

    func testEncode() {
        let (lat, lon) = (57.64911063015461, 10.40743969380855)
        let chars = "u4pruydqqvj"
        for i in 1...chars.count {
            XCTAssertTrue(Geohasher.encode(latitude: lat, longitude: lon, length: i) == String(chars.prefix(i)))
        }
    }
    
    func testCoreLocation() {
        XCTAssertFalse(CLLocationCoordinate2DIsValid(CLLocationCoordinate2D(geohash: "garbage")))

        let c = CLLocationCoordinate2D(geohash: "u4pruydqqvj")
        XCTAssertTrue(CLLocationCoordinate2DIsValid(c))
        XCTAssertTrue(c.geohash(length: 11) == "u4pruydqqvj")
    }
    
    static var allTests = [
        ("testDecode", testDecode),
        ("testEncode", testEncode),
        ("testCoreLocation", testCoreLocation),
    ]
    
}
