import Foundation

enum ConvertGif {

    enum Constants {
        static let maximumSize = 720
        static let defaultFramerate = 10
    }

    private static var ffmpegPath: String {
        guard let path = Bundle.main.path(forResource: "ffmpeg", ofType: nil) else { fatalError("ffmpeg not found") }

        return path
    }

    static func convert(_ filepath: String, framerate: Int = Constants.defaultFramerate, completion: @escaping () -> Void) {
        Process.run(ffmpegPath, arguments: ["-y", "-i", filepath, "-vf", "fps=\(framerate),scale=\(Constants.maximumSize):-1", filepath.gif], completion: completion)
    }

    static func convertUsingPalette(_ filepath: String, framerate: Int = Constants.defaultFramerate, completion: @escaping () -> Void) {
        let palettePath = "palette.png"
        let filters = "fps=\(framerate),scale=\(Constants.maximumSize):-1:flags=lanczos"

        Process.run(ffmpegPath, arguments: ["-y", "-i", filepath, "-vf", "\(filters),palettegen", palettePath]) {
            Process.run(ffmpegPath, arguments: ["-i", filepath, "-i", palettePath, "-lavfi", "\(filters)[x];[x][1:v]paletteuse", filepath.gif], completion: completion)
        }
    }

}
