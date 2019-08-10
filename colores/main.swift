//
//  main.swift
//  colores
//
//  Created by Max Baumbach on 29/07/2019.
//  Copyright © 2019 Colores. All rights reserved.
//

import Foundation
import ColoresKit

if let index = CommandLine.arguments.firstIndex(of: "--sketch") {
    let file = CommandLine.arguments[index+1]
    let url = URL(fileURLWithPath: file).appendingPathComponent("document").appendingPathExtension("json")
    print("Generating colorsets")
    ColoresKit.generateColors(fromAssets: url, outputURL: url, fileType: .sketch)
} else {
    print("Please enter a file path and hit enter:")
    if let url = readLine(), !url.isEmpty {
        let url = URL(fileURLWithPath: url)
        ColoresKit.generateColors(fromAssets: url, outputURL: url, fileType: .json)
    } else {
        print("No file path provided ¯\\_(ツ)_/¯")
    }
}

