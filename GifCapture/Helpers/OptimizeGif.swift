import Foundation

enum OptimizeGif {

    private static var gifsiclePath: String {
        guard let path = Bundle.main.path(forResource: "gifsicle", ofType: nil) else { fatalError("gifsicle not found") }

        return path
    }

    static func optimize(at filepath: String, optimizationLevel: OptimizationLevel, completion: @escaping () -> Void) {
        let filename = URL(fileURLWithPath: filepath).lastPathComponent
        let outputPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop").appendingPathComponent(filename.gif).path
        let arguments = ["-i", filepath.gif, "-O\(optimizationLevel.rawValue)", "--colors", "128", "--output", outputPath]

        Process.run(gifsiclePath, arguments: arguments) { _ in
            completion()
        }
    }

}
