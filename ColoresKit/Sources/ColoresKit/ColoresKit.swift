import Foundation

final public class ColoresKit: NSObject {
    
    public static func generateColors(fromAssets assetsURL: URL, outputURL: URL?, fileType: FileType, verbose: Bool = false) {
        do {
            switch fileType {
            case .json:
                let config: ColoresConfig = try FileService.loadJSON(at: assetsURL)
                createColors(from: config.colors, at: assetsURL, output: outputURL, using: config, verbose: verbose)
            case .sketch:
                let config: SketchDocument = try FileService.loadJSON(at: assetsURL)
                createColors(from: config, at: assetsURL, output: outputURL, verbose: verbose)
            }
        } catch {
            print("Error while creating Xocde color assets. Reason: \(error)")
            exit(EXIT_FAILURE)
        }
    }
    
    private static func createColors(from json: [String: [String]], at url: URL, output: URL? = nil, using config: ColoresConfig, verbose: Bool = false) {
        do {
            let outputURL = output != nil ? output : try FileService.createDirectoryIfNeeded(named: "tempAssets", at: URL(fileURLWithPath: ""))
            for (key, value) in json {
                let folderName = "\(key).colorset".lowercased()
                if verbose { print("Will create \(folderName) at \(outputURL?.path ?? "Unknown path")") }
                guard let folder = try FileService.createDirectoryIfNeeded(named: folderName, at: outputURL!) else { continue }
                let alpha = value.count == 2 ? value.last! : "1.000"
                let colorString = value.first!
                let colorSet = Parser.decodeColors(from: colorString, alpha: alpha, using: config)
                let encoded = try Parser.encodeContent(colorSet)
                try FileService.persistFile(file: encoded, named: "Contents", fileType: .json, at: folder)
            }
            print("🎉 Assets have been generate them. Find them at \(outputURL?.path ?? "Unknown path")")
        } catch {
            print("Error while generating color set. Error thrown \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        }
    }
    
    private static func createColors(from sketch: SketchDocument, at url: URL, output: URL? = nil, verbose: Bool = false) {
        
        let sets = Parser.creeteColorSets(from: sketch)
        do {
            let temp = output != nil ? output : try FileService.createDirectoryIfNeeded(named: "tempAssets", at: URL(fileURLWithPath: ""))
            guard let outputURL = temp else { exit(EXIT_FAILURE) }
            if verbose { print("📦 Create assets at \(outputURL.path)") }
            for set in sets {
                try writeSetToLocation(set, output: outputURL, verbose: verbose)
            }
            print("🎉 Assets have been generate them. Find them at \(outputURL.path)")
        } catch {
            print("Error while generating color set. Error thrown \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        }
    }
    
    private static func writeSetToLocation(_ set: SketchColorSet, output: URL, verbose: Bool = false) throws {
        let name = set.name.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "/", with: "")
        let folderName = "\(name).colorset".lowercased()
        guard let folder = try FileService.createDirectoryIfNeeded(named: folderName, at: output) else {
            if verbose { print("⚠️ Did not create \(folderName)") }
            return
        }
        if verbose { print("✅ Success! Did create \(folderName)") }
        let encoded = try Parser.encodeContent(set.colorSet)
        try FileService.persistFile(file: encoded, named: "Contents", fileType: .json, at: folder)
    }
}
