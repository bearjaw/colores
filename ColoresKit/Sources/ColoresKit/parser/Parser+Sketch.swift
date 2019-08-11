//
//  Parser+Sketch.swift
//  
//
//  Created by Max Baumbach on 10/08/2019.
//

import Foundation

extension Parser {
    
    static func creeteColorSets(from sketch: SketchDocument, at url: URL) -> [SketchColorSet] {
        let config = ColoresConfig(gamut: nil, colorSpace: nil, locales: nil, idioms: ["universal"], appearances: nil, colors: [:])
        let sets = sketch.layerStyles.objects.map { createColorSet(from: $0, using: config) }
        return sets
    }
    
    static func createColorSet(from sharedStyles: SharedStyle, using config: ColoresConfig) -> SketchColorSet {
        let infos = createColorInfos(from: sharedStyles.value.fills, using: config)
        let info = Info(version: 1, author: "xcode")
        let set = ColorSet(info: info, properties: nil, colors: infos)
        return SketchColorSet(name: sharedStyles.name, colorSet: set)
    }
    
    static func createColorInfos(from fills: [Fill], using config: ColoresConfig) -> [ColorInfo] {
        let components = fills.map { createComponent(from: $0 )}
        let colors = components.map { createColor(from: $0, using: config)}
        return colors.map { createColorInfo(color: $0, using: config) }
    }
    
    static func createComponent(from fill: Fill) -> Component {
        let component = Component(red: "\(fill.color.red)", green: "\(fill.color.green)", blue: "\(fill.color.blue)", alpha: "\(fill.color.alpha)")
        return component
    }
    
}
