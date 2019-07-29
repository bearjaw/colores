//
//  FileService.swift
//  
//
//  Created by Max Baumbach on 29/07/2019.
//

import Foundation

enum FileExtension: String {
    case json
    case text
    case none
}

final class FileService {
    
    static func loadJSON(at url: URL) -> [String: Any] {
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONDecoder().decode([String: [String: String]].self, from: data)
            return json
        } catch {
            fatalError("Error: Could to open file. \(error)")
        }
    }
    
    @discardableResult
    static func createDirectoryIfNeeded(named name: String, at url: URL) throws -> URL? {
        let namedURL = url.appendingPathComponent(name)
        guard !FileManager.default.fileExists(atPath: namedURL.path) else { return namedURL }
        try FileManager.default.createDirectory(at: namedURL, withIntermediateDirectories: false, attributes: nil)
        return namedURL
    }
    
    static func persistFile(file data: Data, named name: String, fileTyoe: FileExtension, at url: URL) throws {
        try data.write(to: url.appendingPathComponent(name).appendingPathExtension(fileTyoe.rawValue))
    }
}