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
        convertFFMPEG(filepath, framerate: framerate, completion: completion)
    }

    static private func convertFFMPEG(_ filepath: String, framerate: Int = Constants.defaultFramerate, completion: @escaping () -> Void) {
        let generateDate = Date()
        Process.run(ffmpegPath, arguments: ["-i", filepath, "-vf", "scale=\(Constants.maximumSize):-1", "-r", "\(framerate)", "-y", "-f", "gif", filepath.gif]) {
            print("FFMPEG: \(abs(generateDate.timeIntervalSinceNow))")
        }
    }

//    static private func convertNatively(_ filepath: String, framerate: Int = Constants.defaultFramerate, completion: @escaping () -> Void) {
//        print("Source: \(filepath)")
//        let sourceUrl = URL(fileURLWithPath: filepath)
//        let destinationUrl = URL(fileURLWithPath: filepath.gif)
//        let video = AVURLAsset(url: sourceUrl, options: nil)
//        let times = frameTimes(for: video, framerate: framerate)
//
//        guard !video.tracks(withMediaCharacteristic: .visual).isEmpty,
//            let destination = CGImageDestinationCreateWithURL(destinationUrl as CFURL, kUTTypeGIF, times.count, nil) else { return }
//
//        let generator = AVAssetImageGenerator(asset: video)
//
//        let tolerance = CMTime(value: 1, timescale: CMTimeScale(framerate * 2))
//        generator.requestedTimeToleranceBefore = tolerance
//        generator.requestedTimeToleranceAfter = tolerance
//        generator.appliesPreferredTrackTransform = true
//        generator.maximumSize = CGSize(width: Constants.maximumSize, height: Constants.maximumSize)
//
//        let generateDate = Date()
//
//        times.forEach { time in
//            guard let image = try? generator.copyCGImage(at: time, actualTime: nil) else { return }
//            CGImageDestinationAddImage(destination, image, nil)
//        }
//
//        CGImageDestinationFinalize(destination)
//
//        print("Generate: \(abs(generateDate.timeIntervalSinceNow))")
//        completion()
//    }

//    static private func convertNativelyOld(_ filepath: String, framerate: Int = Constants.defaultFramerate, completion: @escaping () -> Void) {
//        print("Source: \(filepath)")
//        let sourceUrl = URL(fileURLWithPath: filepath)
//        let destinationUrl = URL(fileURLWithPath: filepath.gif)
//        let video = AVURLAsset(url: sourceUrl, options: nil)
//        let times = frameTimes(for: video, framerate: framerate)
//
//        guard !video.tracks(withMediaCharacteristic: .visual).isEmpty,
//            let destination = CGImageDestinationCreateWithURL(destinationUrl as CFURL, kUTTypeGIF, times.count, nil) else { return }
//
//        let generator = AVAssetImageGenerator(asset: video)
//
//        let tolerance = CMTime(value: 1, timescale: CMTimeScale(framerate * 2))
//        generator.requestedTimeToleranceBefore = tolerance
//        generator.requestedTimeToleranceAfter = tolerance
//        generator.appliesPreferredTrackTransform = true
//        generator.maximumSize = CGSize(width: Constants.maximumSize, height: Constants.maximumSize)
//
//        let generateDate = Date()
//
//        generator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, image, actualTime, result, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//            }
//
//            guard let image = image else { return }
//
//            CGImageDestinationAddImage(destination, image, nil)
//
//            if requestedTime == times.last?.timeValue {
//                print("Generate: \(abs(generateDate.timeIntervalSinceNow))")
//                CGImageDestinationFinalize(destination)
//                completion()
//            }
//        }
//    }
//
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
