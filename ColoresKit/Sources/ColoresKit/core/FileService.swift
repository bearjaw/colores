//
//  FileService.swift
//  
//
//  Created by Max Baumbach on 29/07/2019.
//

import Foundation

public enum FileType {
    case json
    case sketch
}

enum FileExtension: String {
    case json
    case text
    case none
}

final class FileService {
    
    static func loadJSON<T: Decodable>(at url: URL) throws -> T {
        let data = try Data(contentsOf: url)
        return try loadJSON(from: data)
    }
    
    static func loadJSON<T: Decodable>(from data: Data) throws -> T {
        let json = try JSONDecoder().decode(T.self, from: data)
        return json
    }
    
    @discardableResult
    static func createDirectoryIfNeeded(named name: String, at url: URL) throws -> URL? {
        let namedURL = url.appendingPathComponent(name)
        guard !FileManager.default.fileExists(atPath: namedURL.path) else { return namedURL }
        try FileManager.default.createDirectory(at: namedURL, withIntermediateDirectories: false, attributes: nil)
        return namedURL
    }
    
    static func deleteDirectoryIfNeeded(named name: String, at url: URL) throws -> URL? {
        let namedURL = url.appendingPathComponent(name)
        guard !FileManager.default.fileExists(atPath: namedURL.path) else { return namedURL }
        try FileManager.default.removeItem(at: namedURL)
        return namedURL
    }
    
    static func moveContent(at url: URL, to output: URL) throws {
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        let content = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        try content.forEach { try FileManager.default.moveItem(at: $0, to: output) }
    }
    
    static func persistFile(file data: Data, named name: String, fileType: FileExtension, at url: URL) throws {
        try data.write(to: url.appendingPathComponent(name).appendingPathExtension(fileType.rawValue))
    }
}
