//
//  main.swift
//  colores
//
//  Created by Max Baumbach on 29/07/2019.
//  Copyright © 2019 Colores. All rights reserved.
//

import Foundation
import ColoresKit

print("Please enter a file url:")

if let url = readLine() {
    let url = URL(fileURLWithPath: url)
    ColoresKit.generateColors(fromAssets: url, outputURL: url)
} else {
    print("Why are you being so coy?")
}

