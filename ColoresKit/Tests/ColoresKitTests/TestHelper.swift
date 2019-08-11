//
//  File.swift
//  
//
//  Created by Max Baumbach on 11/08/2019.
//

import Foundation
import XCTest

final class TestHelper {
    // Test Data
    static var sketchDocument: String {
        return """
        {
        "_class": "document",
        "do_objectID": "8EC9C2CB-295F-49A4-B702-CF08B1CE890E",
        "colorSpace": 1,
        "layerStyles": {
        "_class": "sharedStyleContainer",
        "objects": [
        {
        "_class": "sharedStyle",
        "do_objectID": "0788777E-80E3-4CDC-8B60-0283595BBE27",
        "name": "BrandRed",
        "value": {
        "_class": "style",
        "endMarkerType": 0,
        "fills": [
        {
        "_class": "fill",
        "isEnabled": true,
        "color": {
        "_class": "color",
        "alpha": 1,
        "blue": 0.1568627450980392,
        "green": 0,
        "red": 0.9490196078431372
        },
        "fillType": 0,
        "noiseIndex": 0,
        "noiseIntensity": 0,
        "patternFillType": 1,
        "patternTileScale": 1
        }
        ],
        "miterLimit": 10,
        "startMarkerType": 0,
        "windingRule": 1
        }
        }
        ]
        }
        }
        
        """
    }
    
    static var coloresDocument: String {
        return """
        {
        "appearances": ["dark", "light", "high"],
        "idioms": ["universal"],
        "colorSpace": "srgb",
        "locale": "en",
        "colors": {
        "primaryBackground": ["#1f212b","1.000"],
        "secondaryBackground": ["#ffffff","1.000"],
        }
        }
        """
    }
}

extension XCTest {
    static func error(got: Any, expected: Any) -> String {
        return "Test failed. Expected value was \(expected) but got \(got)"
    }
}
