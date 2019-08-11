import XCTest
@testable import ColoresKit

final class FileServiceLoadingTests: XCTestCase {
    
    func testLoadSketchFromData() {
        guard let data = TestHelper.sketchDocument.data(using: .utf8) else {
            XCTFail("Data was nil. Could not encode JSON to data")
            return
        }
        do {
            let sketch: SketchDocument = try FileService.loadJSON(from: data)
            let count = sketch.layerStyles.objects.count
            let expected = 1
            XCTAssert(count == expected, XCTest.error(got: count, expected: expected))
        } catch {
            XCTFail("Test failed: Could not decode \(SketchDocument.self) from String")
        }
    }
    
    func testLoadColoresFromData() {
        guard let data = TestHelper.coloresDocument.data(using: .utf8) else {
            XCTFail("Data was nil. Could not encode JSON to data")
            return
        }
        do {
            let colores: ColoresConfig = try FileService.loadJSON(from: data)
            let count = colores.colors.count
            let expected = 2
            XCTAssert(count == expected, XCTest.error(got: count, expected: expected))
        } catch {
            XCTFail("Test failed: Could not decode \(ColoresConfig.self) from String")
        }
    }

    static var allTests = [
        ("testLoadSketchFromData", testLoadSketchFromData,
         "testLoadColoresFromData", testLoadColoresFromData),
    ]
}
