//
//  Models.swift
//  Files
//
//  Created by Max Baumbach on 25/01/2019.
//

import Foundation

public enum Idiom: String, Codable {
    case ipad
    case iphone
    case mac
    case tv
    case universal
}

struct ColoresConfig: Codable {
    let gamut: String?
    let colorSpace: String?
    let locales: [String]?
    let idioms: [String]?
    let appearances: [AppearanceValue]?
    let colors: [String: [String]]
    
    var includeHighContrast: Bool? {
        guard let appearances = appearances else { return nil }
        return appearances.contains(.high)
    }
}

public struct ColorSet: Codable {
    let info: Info
    let properties: [Property]?
    let colors: [ColorInfo]
}

public struct Property: Codable {
    let localizable: Bool
}

public struct Info: Codable {
    let version: Int
    let author: String
}

public struct ColorInfo: Codable {
    let idiom: String
    let locale: String?
    let appearance: [Appearance]?
    let displayGamut: String?
    let color: Color
}

public struct Color: Codable {
    let colorSpace: String
    let components: Component
}

public struct Component: Codable {
    let red: String
    let green: String
    let blue: String
    let alpha: String
}

enum ComponentType {
    case rgb(red: String, green: String, blue: String, alpha: String)
    case hex(value: String)
    
    public var component: Component {
        switch self {
        case .hex(let value):
            let (red, green, blue) = Parser.parseHexValues(from: value)
            return Component(red: "0x\(red)", green: "0x\(green)", blue: "0x\(blue)", alpha: "1.000")
        case .rgb(let red, let green, let blue, let alpha):
            return Component(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

public struct Appearance: Codable {
    let appearance: String
    let value: String
}

public enum AppearanceValue: String, Codable {
    case dark
    case light
    case high
}

public enum AppearanceType {
    case contrast(value: AppearanceValue)
    case luminosity(value: AppearanceValue)
    
    public var appearance: Appearance {
        switch self {
        case .contrast(let value):
            return Appearance(appearance: "contrast", value: value.rawValue)
        case .luminosity(let value):
            return Appearance(appearance: "luminosity", value: value.rawValue)
        }
    }
}
