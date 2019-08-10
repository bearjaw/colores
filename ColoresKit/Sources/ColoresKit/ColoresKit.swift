import Foundation

public enum FileType {
    case json
    case sketch
}

final public class ColoresKit: NSObject {
    
    public static func generateColors(fromAssets assetsURL: URL, outputURL: URL, fileType: FileType) {
        switch fileType {
        case .json:
            let config: ColoresConfig = FileService.loadJSON(at: assetsURL)
            createColors(from: config.colors, at: outputURL, using: config)
        case .sketch:
            let config: SketchDocument = FileService.loadJSON(at: assetsURL)
            createColors(from: config, at: assetsURL)
        }
    }
    
    private static func createColors(from json: [String: [String]], at url: URL, using config: ColoresConfig) {
       let output = try! FileService.createDirectoryIfNeeded(named: "tempAssets", at: URL(fileURLWithPath: ""))
        for (key, value) in json {
            do {
                guard let folder = try FileService.createDirectoryIfNeeded(named: "\(key).colorset", at: output!) else { continue }
                let alpha = value.count == 2 ? value.last! : "1.000"
                let colorString = value.first!
                let colorSet = Parser.decodeColors(from: colorString, alpha: alpha, using: config)
                let encoded = try Parser.encodeContent(colorSet)
                try FileService.persistFile(file: encoded, named: "Contents", fileType: .json, at: folder)
            } catch {
                fatalError("Error while generating color set. Error thrown \(error.localizedDescription)")
            }
        }
    }
    
    private static func createColors(from sketch: SketchDocument, at url: URL) {
       
        let sets = Parser.creeteColorSets(from: sketch, at: url)
        do {
            let output = try FileService.createDirectoryIfNeeded(named: "tempAssets", at: URL(fileURLWithPath: ""))
            for set in sets {
                let name = set.name.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "/", with: "")
                guard let folder = try FileService.createDirectoryIfNeeded(named: "\(name).colorset", at: output!) else { continue }
                let encoded = try Parser.encodeContent(set.colorSet)
                try FileService.persistFile(file: encoded, named: "Contents", fileType: .json, at: folder)
            }
        } catch {
            fatalError("Error while generating color set. Error thrown \(error.localizedDescription)")
        }
    }
}
