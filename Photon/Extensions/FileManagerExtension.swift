import Foundation

extension FileManager {
    func copyItemToDesktop(atPath filepath: String) {
        let filename = URL(fileURLWithPath: filepath).lastPathComponent
        let outputPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop").appendingPathComponent(filename).path
        try? copyItem(atPath: filepath, toPath: outputPath)
    }
}
