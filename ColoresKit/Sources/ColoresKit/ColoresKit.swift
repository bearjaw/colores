import Foundation

final public class ColoresKit: NSObject {
    
    public static func generateColors(fromAssets assetsURL: URL, outputURL: URL) {
        
        let config = FileService.loadJSON(at: assetsURL)
        createColors(from: config.colors, at: outputURL, using: config)
    }
    
    private static func createColors(from json: [String: [String]], at url: URL, using config: ColoresConfig) {
       let output = try! FileService.createDirectoryIfNeeded(named: "tempAssets", at: URL(fileURLWithPath: ""))
        for (key, value) in json {
            do {
                guard let folder = try FileService.createDirectoryIfNeeded(named: key, at: output!) else { continue }
                let alpha = value.count == 2 ? value.last! : "1.000"
                let colorString = value.first!
                let colorSet = Parser.decodeColors(from: colorString, alpha: alpha, using: config)
                let encoded = try Parser.encodeContent(colorSet)
                try FileService.persistFile(file: encoded, named: "Contents", fileTyoe: .json, at: folder)
            } catch {
                fatalError("Error while generating color set. Error thrown \(error.localizedDescription)")
            }
        }
    }
}
