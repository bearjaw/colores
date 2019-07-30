//
//  Parser.swift
//  
//
//  Created by Max Baumbach on 29/07/2019.
//

import Foundation

final class Parser {
    typealias JSON = [String: Any]
    
    static func decodeColors(from value: String, alpha: String, using config: ColoresConfig) -> ColorSet {
        return createColorSet(from: value, alpha: alpha, using: config)
    }
    
    private static func createColorSet(from value: String, alpha: String, using config: ColoresConfig) -> ColorSet {
        if isHex(value) {
            let component = ComponentType.hex(value: value).component
            
            let colors = createColorsForAppearances(component: component, using: config)
            let properties: [Property]? = createProperties(from: config)
            return ColorSet(info: Info(version: 1, author: "xcode"), properties: properties, colors: colors)
        }
        
        return ColorSet(info: Info(version: 1, author: "xcode"), properties: nil, colors: [])
    }
    
    private static func isHex(_ value: String) -> Bool {
        let lowercased = value.lowercased()
        return lowercased.contains("#") || lowercased.contains("0x")
    }
    
    private static func normalizeValue(_ value: String) -> String {
        return value.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "0x", with: "")
    }
    
    static func parseHexValues(from value: String) -> (red: String, green: String,blue: String) {
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
        return (red: "\(red)", green: "\(green)", blue: "\(blue)")
    }
    
    static func encodeContent<T: Encodable>(_ content: T) throws -> Data {
        return try JSONEncoder().encode(content)
    }
}

extension Parser {
    static func createColorsForAppearances(component: Component, using config: ColoresConfig) -> [ColorInfo] {
        let color = createColor(from: component, using: config)
        guard let appearances = config.appearances else { return [createColorInfo(color: color, using: config)] }
        let types = appearances.map { AppearanceType.luminosity(value: $0) }
        return types.map { createColorInfo(for: $0, color: color, using: config) }
    }
    
    static func createColorInfo(for appearanceType: AppearanceType? = nil, locale: String? = nil, idiom: Idiom = .universal, color: Color, using config: ColoresConfig) -> ColorInfo {
        var appearances: [Appearance]?
        if let appearanceType = appearanceType {
            appearances = [appearanceType.appearance]
            if config.includeHighContrast == true {
                appearances?.append(AppearanceType.contrast(value: .dark).appearance)
            }
        }
        return ColorInfo(idiom: idiom.rawValue, locale: locale, appearance: appearances, displayGamut: config.gamut, color: color)
    }
    
    static func createColorInfo(for appearanceType: AppearanceType? = nil, color: Color, using config: ColoresConfig) -> [ColorInfo] {
        let hasLocales = config.locales
        let hasIdioms = config.idioms
        if let hasIdioms = hasIdioms, hasIdioms.isEmpty == false, let hasLocales = hasLocales, hasLocales.isEmpty == false {
            return createColorInfos(forIdioms: hasIdioms, locales: hasLocales, appearanceType: appearanceType, color: color, using: config)
        } else if let hasIdioms = hasIdioms, hasIdioms.isEmpty == false, hasLocales?.isEmpty == true {
            return createColorInfos(forIdioms: hasIdioms, appearanceType: appearanceType, color: color, using: config)
        } else if let hasLocales = hasLocales, hasLocales.isEmpty == false {
            return createColorInfos(forLocales: hasLocales, appearanceType: appearanceType, color: color, using: config)
        } else {
            return [createColorInfo(for: appearanceType, idiom: .universal, color: color, using: config)]
        }
    }
    
    static func createColorInfos(forIdioms idioms: [String], locales: [String], appearanceType: AppearanceType?, color: Color, using config: ColoresConfig) -> [ColorInfo] {
        precondition(!idioms.isEmpty && !locales.isEmpty)
        
        var colorInfos: [ColorInfo] = []
        for idiom in idioms {
            for locale in locales {
                guard let device = Idiom(rawValue: idiom) else { continue }
                let info = createColorInfo(for: appearanceType, locale: locale, idiom: device, color: color, using: config)
                colorInfos.append(info)
            }
        }
        return colorInfos
    }
    
    static func createColorInfos(forIdioms idioms: [String], appearanceType: AppearanceType?, color: Color, using config: ColoresConfig) -> [ColorInfo] {
        precondition(!idioms.isEmpty)
        
        var colorInfos: [ColorInfo] = []
        for idiom in idioms {
            guard let device = Idiom(rawValue: idiom) else { continue }
            let info = createColorInfo(for: appearanceType, idiom: device, color: color, using: config)
            colorInfos.append(info)
        }
        return colorInfos
    }
    
    static func createColorInfos(forLocales locales: [String], appearanceType: AppearanceType?, color: Color, using config: ColoresConfig) -> [ColorInfo] {
        precondition(!locales.isEmpty)
        
        var colorInfos: [ColorInfo] = []
        for locale in locales {
            let info = createColorInfo(for: appearanceType, locale: locale, idiom: .universal, color: color, using: config)
            colorInfos.append(info)
        }
        return colorInfos
    }
}

extension Parser {
    static func createColor(from component: Component, using config: ColoresConfig) -> Color {
        let color = Color(colorSpace: config.colorSpace ?? "srgb", components: component)
        return color
    }
}

extension Parser {
    static func createProperties(from config: ColoresConfig) -> [Property]? {
        guard let locales = config.locales, !locales.isEmpty else { return nil }
        return [Property(localizable: true)]
    }
}
