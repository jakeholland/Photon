import AppKit
import AVFoundation
import ImageIO

enum ConvertGif {

    enum Constants {
        static let maximumSize = CGSize(width: 1920, height: 1080)
        static let defaultFramerate: Int = 10
    }
    
    static func convert(_ filepath: String, framerate: Int = Constants.defaultFramerate, completion: @escaping () -> Void) {
        print("Source: \(filepath)")
        let sourceUrl = URL(fileURLWithPath: filepath)
        let destinationUrl = URL(fileURLWithPath: filepath.gif)
        let video = AVURLAsset(url: sourceUrl, options: nil)
        let times = frameTimes(for: video, framerate: framerate)
        
        guard !video.tracks(withMediaCharacteristic: .visual).isEmpty,
            let destination = CGImageDestinationCreateWithURL(destinationUrl as CFURL, kUTTypeGIF, times.count, nil) else { return }
        
        let generator = AVAssetImageGenerator(asset: video)
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero
        generator.maximumSize = Constants.maximumSize

        let generateDate = Date()

        generator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, image, actualTime, result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }

            guard let image = image else { return }
            
            CGImageDestinationAddImage(destination, image, nil)
            
            if requestedTime == times.last?.timeValue {
                print("Generate: \(abs(generateDate.timeIntervalSinceNow))")
                CGImageDestinationFinalize(destination)
                completion()
            }
        }
    }
    
    private static func frameTimes(for video: AVAsset, framerate: Int) -> [NSValue] {
        let duration = Float(video.duration.value) / Float(video.duration.timescale)
        print("Duration: \(duration)")
        let frameCount = Int(duration * Float(framerate))
        
        var times: [NSValue] = []
        for frameNumber in 0 ..< frameCount {
            let time = CMTime(value: CMTimeValue(frameNumber), timescale: CMTimeScale(framerate))
            times.append(NSValue(time: time))
        }
        
        return times
    }

}
