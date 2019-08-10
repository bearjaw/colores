//
//  CommandLineHelper.swift
//  
//
//  Created by Max Baumbach on 10/08/2019.
//

import Foundation


public class CommandLineHelper {
    
    public static func parseArguments(_ args: [String]) -> Bool {
        if let index = hasSketchArgument(arguments: args) {
            parseSketchFile(for: args, at: index)
            return true
        }
        return false
    }
    
    private static func parseSketchFile(for arguments: [String], at index: Int) {
        if validateSketch(arguments, index: index) {
            let file = arguments[index+1]
            createColorSets(from: file)
        } else {
            print("Please provide a path to an unzipped sketch file:")
            if let url = readLine(), !url.isEmpty {
                createColorSets(from: url)
            } else {
                print("No file path provided ¯\\_(ツ)_/¯")
            }
        }
    }
    
    private static func createColorSets(from file: String) {
        let url = URL(fileURLWithPath: file).appendingPathComponent("document").appendingPathExtension("json")
        print("Generating colorsets")
        ColoresKit.generateColors(fromAssets: url, outputURL: url, fileType: .sketch)
    }
    
    private static func hasSketchArgument(arguments: [String]) -> Int? {
        guard let index = arguments.firstIndex(of: "--sketch") else {
            guard let index = arguments.firstIndex(of: "-s") else { return nil }
            return index
        }
        return index
    }
    
    private static func validateSketch(_ arguments: [String], index: Int) -> Bool {
        return index+1 < arguments.count && !arguments[index+1].isEmpty
    }
}



