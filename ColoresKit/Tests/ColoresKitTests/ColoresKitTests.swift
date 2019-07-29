import XCTest
@testable import ColoresKit

final class ColoresKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ColoresKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
