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
        if validateArgument(arguments, index: index) {
            let url = parseURLIfAvailable(arguments: arguments)
            let file = URL(fileURLWithPath: arguments[index+1])
            guard validateFilePath(file) else { exit(EXIT_FAILURE) }
            createColorSets(from: file, outputURL: url)
        } else {
            print("Please provide a path to an unzipped sketch file:")
            if let url = readLine(), !url.isEmpty {
                let output = parseURLIfAvailable(arguments: arguments)
                let file = URL(fileURLWithPath: url)
                guard validateFilePath(file) else { exit(EXIT_FAILURE) }
                createColorSets(from: file, outputURL: output)
            } else {
                print("No file path provided ¯\\_(ツ)_/¯")
                exit(EXIT_FAILURE)
            }
        }
    }
    
    private static func createColorSets(from file: URL, outputURL output: URL? = nil) {
        let url = file.appendingPathComponent("document").appendingPathExtension("json")
        print("Generating colorsets")
        ColoresKit.generateColors(fromAssets: url, outputURL: output, fileType: .sketch)
    }
    
    private static func validateArgument(_ arguments: [String], index: Int) -> Bool {
        return index+1 < arguments.count && !arguments[index+1].isEmpty
    }
    
}


// MARK: - Sketch

extension CommandLineHelper {
    
    private static func hasSketchArgument(arguments: [String]) -> Int? {
        guard let index = arguments.firstIndex(of: "--sketch") else {
            guard let index = arguments.firstIndex(of: "-s") else { return nil }
            return index
        }
        return index
    }
    
    private static func validateFilePath(_ url: URL) -> Bool {
        guard !url.pathExtension.contains("sketch") else {
            print("Error. Please duplicate & unzip your sketch file first.")
            exit(1)
        }
        return true
    }
    
}

// MARK: - Output Path provided

extension CommandLineHelper {
    
    private static func hasOuputArgument(arguments: [String]) -> Int? {
        guard let index = arguments.firstIndex(of: "--output") else {
            guard let index = arguments.firstIndex(of: "-o") else { return nil }
            return index
        }
        return index
    }
    
    private static func parseURLIfAvailable(arguments: [String]) -> URL? {
        if let outputIndex = hasOuputArgument(arguments: arguments), validateArgument(arguments, index: outputIndex) {
            let path = arguments[outputIndex+1]
            return URL(fileURLWithPath: path)
        } else {
            return nil
        }
    }
    
}



