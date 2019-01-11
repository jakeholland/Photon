import AppKit
import AVFoundation
import ImageIO

enum ConvertGif {

    enum Constants {
        static let maximumSize = 1080
        static let defaultFramerate: Int = 10
    }

    private static var ffmpegPath: String {
        guard let path = Bundle.main.path(forResource: "ffmpeg", ofType: nil) else { fatalError("ffmpeg not found") }

        return path
    }

    static func convert(_ filepath: String, framerate: Int = Constants.defaultFramerate, completion: @escaping () -> Void) {
        let generateDate = Date()
        Process.run(ffmpegPath, arguments: ["-i", filepath, "-vf", "scale=\(Constants.maximumSize):-1", "-r", "\(framerate)", "-y", "-f", "gif", filepath.gif]) {
            print("FFMPEG: \(abs(generateDate.timeIntervalSinceNow))")
        }
    }

    private static func frameTimes(for video: AVAsset, framerate: Int) -> [CMTime] {
        let duration = Float(video.duration.value) / Float(video.duration.timescale)
        print("Duration: \(duration)")
        let frameCount = Int(duration * Float(framerate))
        
        var times: [CMTime] = []
        for frameNumber in 0 ..< frameCount {
            let time = CMTime(value: CMTimeValue(frameNumber), timescale: CMTimeScale(framerate))
            times.append(time)
        }
        
        return times
    }

}
