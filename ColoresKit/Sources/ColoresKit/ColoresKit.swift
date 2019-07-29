import Foundation

final public class ColoresKit: NSObject {
    
    
    public static func generateColors(fromAssets assetsURL: URL, outputURL: URL) {
        let json = loadJSON(at: assetsURL)
        guard let colors = json["colors"] as? [String: String] else { return }
        let output = FileManager.default
                        .homeDirectoryForCurrentUser
                        .appendingPathComponent("Documents")
                        .appendingPathComponent("git")
                        .appendingPathComponent("colores")
                        .appendingPathComponent("colores")
        colors.forEach { createFiles(key: $0, value: $1, at: output) }
    }
    
    static func loadJSON(at url: URL) -> [String: Any] {
        let current = currentDirectory()
        do {
            let currentURL = FileManager.default
                .homeDirectoryForCurrentUser
                .appendingPathComponent("Documents")
                .appendingPathComponent("git")
                .appendingPathComponent("colores")
                .appendingPathComponent("colores")
                .appendingPathComponent("ColoresSample")
                .appendingPathExtension("json")
            let data = try Data(contentsOf: currentURL)
            let json = try JSONDecoder().decode([String: [String: String]].self, from: data)
            return json
        } catch {
            fatalError("Error: Could to open file. \(error)")
        }
        return [:]
    }
    
    static func currentDirectory() -> URL? {
        let cwd = FileManager.default.currentDirectoryPath
        return URL(string: cwd)
        
        print("script run from:\n" + cwd)

        let script = CommandLine.arguments[0];
        print("\n\nfilepath given to script:\n" + script)

        //get script working dir
        if script.hasPrefix("/") { //absolute
            let path = (script as NSString).deletingLastPathComponent
            print("\n\nscript at:\n" + path)
        } else {
            let urlCwd = URL(fileURLWithPath: cwd)
            if let path = URL(string: script, relativeTo: urlCwd)?.path {
                let path = (path as NSString).deletingLastPathComponent
                print("\n\nscript at:\n" + path)
            }
        }
        return nil
    }
    
    static func createFiles(key: String, value: String, at url: URL) {
        do {
            let modifiedKey = key.replacingOccurrences(of: ".", with: "")
            let colorSet = url.appendingPathComponent("\(modifiedKey).colorset")
            try FileManager.default.createDirectory(at: colorSet, withIntermediateDirectories: false, attributes: nil)
            let color = createColorSet(from: value)
            let data = try JSONEncoder().encode(color)
            try data.write(to: colorSet.appendingPathComponent("Contents").appendingPathExtension("json"))
        } catch {
            fatalError("Error: Writing files \(error)")
        }
        
    }
    
    static func createColorSet(from value: String) -> ColorSet {
        if isHex(value) {
            let modified = normalizeValue(value)
            let redIndex =  modified.index(modified.startIndex, offsetBy: 2)
            let red = modified.prefix(upTo: redIndex)
//            let range0 = NSRange(location: 0, length: 2)
            let range1 = NSRange(location: 2, length: 2)
            let range3 = NSRange(location: 2, length: 2)
//            let range00 = Range<String.Index>(range0, in: modified)
            let range01 = Range<String.Index>(range1, in: modified)
            let range02 = Range<String.Index>(range3, in: modified)
            let green = modified[range01!]
            let blue = modified[range02!]
            let component = Component(red: "\(red)", green: "\(green)", blue: "\(blue)", alpha: "1.000")
            let color = Color(colorSpace: "srgb", components: component)
            let colorInfo = ColorInfo(idiom: "universal", color: color)
            return ColorSet(info: Info(version: 1, author: "xcode"), colors: [colorInfo])
        }
        
        return ColorSet(info: Info(version: 1, author: "xcode"), colors: [])
    }
    
    static func isHex(_ value: String) -> Bool {
        let lowercased = value.lowercased()
        return lowercased.contains("#") || lowercased.contains("0x")
    }
    
    static func normalizeValue(_ value: String) -> String {
        return value.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "0x", with: "")
    }
}
