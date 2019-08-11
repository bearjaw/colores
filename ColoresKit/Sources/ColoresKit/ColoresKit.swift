import Foundation

final public class ColoresKit: NSObject {
    
    public static func generateColors(fromAssets assetsURL: URL, outputURL: URL?, fileType: FileType) {
        do {
            switch fileType {
            case .json:
                let config: ColoresConfig = try FileService.loadJSON(at: assetsURL)
                createColors(from: config.colors, at: assetsURL, output: outputURL, using: config)
            case .sketch:
                let config: SketchDocument = try FileService.loadJSON(at: assetsURL)
                createColors(from: config, at: assetsURL, output: outputURL)
            }
        } catch {
            print("Error while creating Xocde color assets. Reason: \(error)")
            exit(EXIT_FAILURE)
        }
    }
    
    private static func createColors(from json: [String: [String]], at url: URL, output: URL? = nil, using config: ColoresConfig) {
        do {
            let outputURL = output != nil ? output : try FileService.createDirectoryIfNeeded(named: "tempAssets", at: URL(fileURLWithPath: ""))
            for (key, value) in json {
                guard let folder = try FileService.createDirectoryIfNeeded(named: "\(key).colorset", at: outputURL!) else { continue }
                let alpha = value.count == 2 ? value.last! : "1.000"
                let colorString = value.first!
                let colorSet = Parser.decodeColors(from: colorString, alpha: alpha, using: config)
                let encoded = try Parser.encodeContent(colorSet)
                try FileService.persistFile(file: encoded, named: "Contents", fileType: .json, at: folder)
                
            }
        } catch {
            print("Error while generating color set. Error thrown \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        }
    }
    
    private static func createColors(from sketch: SketchDocument, at url: URL, output: URL? = nil) {
        
        let sets = Parser.creeteColorSets(from: sketch)
        do {
            let outputURL = output != nil ? output : try FileService.createDirectoryIfNeeded(named: "tempAssets", at: URL(fileURLWithPath: ""))
            for set in sets {
                let name = set.name.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "/", with: "")
                guard let folder = try FileService.createDirectoryIfNeeded(named: "\(name).colorset", at: outputURL!) else { continue }
                let encoded = try Parser.encodeContent(set.colorSet)
                try FileService.persistFile(file: encoded, named: "Contents", fileType: .json, at: folder)
            }
        } catch {
            print("Error while generating color set. Error thrown \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        }
    }
}
