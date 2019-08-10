//
//  main.swift
//  colores
//
//  Created by Max Baumbach on 29/07/2019.
//  Copyright © 2019 Colores. All rights reserved.
//

import Foundation
import ColoresKit

let arguments = CommandLine.arguments

func requireInput() -> String? {
    if let input = readLine(), !input.isEmpty {
        return input
    }
    return nil
}

if CommandLineHelper.parseArguments(arguments) == false {
    print("Please enter a file path and hit enter:")
    if let url = requireInput() {
        let url = URL(fileURLWithPath: url)
        ColoresKit.generateColors(fromAssets: url, outputURL: url, fileType: .json)
    }
}

