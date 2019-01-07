import Foundation

enum OptimizeGif {

    private static var path: String {
        guard let path = Bundle.main.path(forResource: "gifsicle", ofType: nil) else {
            fatalError("gifsicle not found")
        }

        return path
    }

    static func optimize(_ filename: String, optimizationLevel: Int = 2, completion: @escaping () -> Void) {
        guard let desktopPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first else { return }
        
        let arguments = ["-i", filename.gif, "-O\(optimizationLevel)", "--output", "\(desktopPath)/\(filename.gif)"]

        Process.run(path, arguments: arguments, completion: completion)
    }

}
