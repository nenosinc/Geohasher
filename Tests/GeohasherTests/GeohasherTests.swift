import XCTest
@testable import Geohasher

final class GeohasherTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Geohasher().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
