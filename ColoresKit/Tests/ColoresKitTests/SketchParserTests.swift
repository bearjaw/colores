//
//  File.swift
//  
//
//  Created by Max Baumbach on 11/08/2019.
//

import Foundation

import XCTest
@testable import ColoresKit

final class SketchParserTests: XCTestCase {
    
    private var testData: SketchDocument?
    private lazy var defaultConfig: ColoresConfig = {
        return ColoresConfig(gamut: nil,
                             colorSpace: "srgb",
                             locales: nil,
                             idioms: nil,
                             appearances: nil,
                             colors: [:])
    }()
    
    override func setUp() {
        guard testData == nil else { return }
        testData = SketchParserTests.loadTestData()
    }
    
    func testCreateColorFromFill() {
        let fill = SketchParserTests.fill()
        let color = Parser.createComponent(from: fill)
        XCTAssert(Float(color.alpha)! == 1.0, XCTest.error(got: Float(color.alpha)!, expected: 1.0))
        XCTAssert(Float(color.red)! == 0.9490, XCTest.error(got: Float(color.red)!, expected: 0.9490))
        XCTAssert(Float(color.green)! == 0.0, XCTest.error(got: Float(color.green)!, expected: 0.0))
        XCTAssert(Float(color.blue)! == 0.1568, XCTest.error(got: Float(color.blue)!, expected: 0.1568))
    }
    
    func testCreateColorInfo() {
        let fill = SketchParserTests.fill()
        let infos = Parser.createColorInfos(from: [fill], using: defaultConfig)
        XCTAssert(infos.count == 1, XCTest.error(got: infos.count, expected: 1))
    }
    
    static var allTests = [
        ("testCreateColorFromFill", testCreateColorFromFill,
         "testCreateColorInfo", testCreateColorInfo),
    ]
}

extension SketchParserTests {
    private static func loadTestData() -> SketchDocument {
        guard let data = TestHelper.sketchDocument.data(using: .utf8) else {
            XCTFail("Data was nil. Could not encode JSON to data")
            exit(EXIT_FAILURE)
        }
        do {
            let sketch: SketchDocument = try FileService.loadJSON(from: data)
            return sketch
        } catch {
            XCTFail("Test failed: Could not decode \(SketchDocument.self) from String. Reason: \(error)")
            exit(EXIT_FAILURE)
        }
    }
    
    private static func fill() -> Fill {
        let sketchColor = SketchColor(_class: "color", alpha: 1, red: 0.9490, green: 0, blue: 0.1568)
        let fill = Fill(_class: "fill", isEnabled: true, color: sketchColor)
        return fill
    }
}
