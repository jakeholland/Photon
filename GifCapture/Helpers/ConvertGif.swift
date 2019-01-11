import Foundation

enum ConvertGif {

    enum Constants {
        static let maximumSize = 1080
        static let defaultFramerate = 10
    }

    private static var ffmpegPath: String {
        guard let path = Bundle.main.path(forResource: "ffmpeg", ofType: nil) else { fatalError("ffmpeg not found") }

        return path
    }

    static func convert(_ filepath: String, framerate: Int = Constants.defaultFramerate, completion: @escaping () -> Void) {
        Process.run(ffmpegPath, arguments: ["-i", filepath, "-vf", "scale=\(Constants.maximumSize):-1", "-r", "\(framerate)", "-y", "-f", "gif", filepath.gif], completion: completion)
    }

}
