import Foundation

final public class ColoresKit: NSObject {
    
    public static func generateColors(fromAssets assetsURL: URL, outputURL: URL) {
        let json = FileService.loadJSON(at: assetsURL)
        guard let colors = json["colors"] as? [String: String] else { return }
        createColors(from: colors, at: outputURL)
    }
    
    private static func createColors(from json: [String: String], at url: URL) {
       let output = try! FileService.createDirectoryIfNeeded(named: "tempAssets", at: URL(fileURLWithPath: ""))
        for (key, value) in json {
            do {
                guard let folder = try FileService.createDirectoryIfNeeded(named: key, at: output!) else { continue }
                let colorSet = Parser.decodeColors(from: value)
                let encoded = try Parser.encodeContent(colorSet)
                try FileService.persistFile(file: encoded, named: "Contents", fileTyoe: .json, at: folder)
            } catch {
                fatalError("Error while generating color set. Error thrown \(error.localizedDescription)")
            }
        }
    }
}
