import Foundation

enum OptimizeGif {

    private static var path: String {
        guard let path = Bundle.main.path(forResource: "gifsicle", ofType: nil) else {
            fatalError("gifsicle not found")
        }

        return path
    }

    static func optimize(_ filename: String, optimizationLevel: Int = 2, completion: @escaping () -> Void) {
        let outputPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop").appendingPathComponent(filename.gif).path
        let arguments = ["-i", filename.gif, "-O\(optimizationLevel)", "--output", outputPath]

        Process.run(path, arguments: arguments, completion: completion)
    }

}
