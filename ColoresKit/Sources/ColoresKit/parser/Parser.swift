//
//  Parser.swift
//  
//
//  Created by Max Baumbach on 29/07/2019.
//

import Foundation

final class Parser {
    typealias JSON = [String: Any]
    
    static func decodeColors(from value: String) -> ColorSet {
        return createColorSet(from: value)
    }
    
    private static func createColorSet(from value: String) -> ColorSet {
            if isHex(value) {
                let modified = normalizeValue(value)
                let redIndex =  modified.index(modified.startIndex, offsetBy: 2)
                let red = modified.prefix(upTo: redIndex)
                //            let range0 = NSRange(location: 0, length: 2)
                let range1 = NSRange(location: 2, length: 2)
                let range3 = NSRange(location: 2, length: 2)
                //            let range00 = Range<String.Index>(range0, in: modified)
                let range01 = Range<String.Index>(range1, in: modified)
                let range02 = Range<String.Index>(range3, in: modified)
                let green = modified[range01!]
                let blue = modified[range02!]
                let component = Component(red: "\(red)", green: "\(green)", blue: "\(blue)", alpha: "1.000")
                let color = Color(colorSpace: "srgb", components: component)
                let colorInfo = ColorInfo(idiom: "universal", color: color)
                return ColorSet(info: Info(version: 1, author: "xcode"), colors: [colorInfo])
            }
            
            return ColorSet(info: Info(version: 1, author: "xcode"), colors: [])
        }
        
        private static func isHex(_ value: String) -> Bool {
            let lowercased = value.lowercased()
            return lowercased.contains("#") || lowercased.contains("0x")
        }
        
        private static func normalizeValue(_ value: String) -> String {
            return value.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "0x", with: "")
        }
    
    static func encodeContent<T: Encodable>(_ content: T) throws -> Data {
            return try JSONEncoder().encode(content)
    }
}
