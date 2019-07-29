//
//  Models.swift
//  Files
//
//  Created by Max Baumbach on 25/01/2019.
//

import Foundation

public struct ColorSet: Codable {
    let info: Info
    let colors: [ColorInfo]
}

public struct Info: Codable {
    let version: Int
    let author: String
}

public struct ColorInfo: Codable {
    let idiom: String
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

public struct Resources: Codable {
    let color: [[String: Any]]
    
    enum ColorKeys: String, CodingKey {
        case name
        case color
    }
    enum AttributeKeys: String, CodingKey {
        case color
    }
    
    public init(from decoder: Decoder) throws {
     let values = try decoder.container(keyedBy: ColorKeys.self)
        var container = try values.decode([String].self, forKey: .color)
        var test = try? decoder.unkeyedContainer()
        var test2 = try? decoder.container(keyedBy: ColorKeys.self)
        
        let nested = try? values.nestedContainer(keyedBy: ColorKeys.self, forKey: .color)
        
        color = []
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}

//public struct XMLColor: Codable {
//    let name: String
//
//
//    init(name: String) {
//        self.name = name
//    }
//
//    enum Keys: String, CodingKey {
//        case color
//    }
//
//    enum ColorKeys: String, CodingKey {
//        case name
//    }
//
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: Keys.self)
//
////        let generatorAgentValues = try values.nestedContainer(keyedBy: Keys.self, forKey: .color)
////        let ta = try generatorAgentValues.decode(String.self, forKey: .name)
//
//    }
//}
