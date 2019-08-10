//
//  File.swift
//  
//
//  Created by Max Baumbach on 10/08/2019.
//

import Foundation

struct SketchDocument: Codable {
    let _class: String
    let layerStyles: LayerStyles
}

struct LayerStyles: Codable {
    let _class: String
    let objects: [SharedStyle]
}

struct Style: Codable {
    let _class: String
    let fills: [Fill]
}

struct Fill: Codable {
    let _class: String
    let isEnabled: Bool
    let color: SketchColor
}

struct SketchColor: Codable {
    let _class: String
    let alpha: Float
    let red: Float
    let green: Float
    let blue: Float
}

struct SharedStyle: Codable {
    let _class: String
    let do_objectID: String
    let name: String
    let value: Style
}

struct SketchColorSet {
    let name: String
    let colorSet: ColorSet
}
